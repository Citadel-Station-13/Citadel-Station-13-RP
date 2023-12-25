//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

GLOBAL_LIST_EMPTY(rig_theme_cache)

/proc/fetch_rig_theme(datum/rig_theme/path)
	if(!isnull(GLOB.rig_theme_cache[path]))
		return GLOB.rig_theme_cache[path]
	var/datum/rig_theme/instance = new path
	GLOB.rig_theme_cache[path] = instance
	return instance

/datum/rig_theme
	/// in code theme name
	var/name = "unknown rig"
	/// visible description
	var/desc = "A powered exochassis of unknown design."
	/// visible fluff description
	var/fluff_desc
	/// display name - overrides name on internal UIs.
	var/display_name
	/// visible name - overrides display name, which overrides name. renders as [visible_name][piece.visible_name]
	var/visible_name
	/// what this is called; usually just 'RIG'
	var/suit_name = "RIG"
	/// pieces - paths. init'd on, well, new/init.
	var/list/pieces = list(
		/datum/rig_piece/helmet,
		/datum/rig_piece/chestplate,
		/datum/rig_piece/gloves,
		/datum/rig_piece/boots,
	)
	/// base icon
	var/base_icon
	/// base icon state
	/// combined as "[base_state][piece_state_append][sealed_state_append]" to get final state
	/// the x_base_when_un/sealed vars can modify this.
	var/base_state
	/// control module state
	var/control_state_append = "-control"
	/// control module sealed append
	var/control_sealed_append = "-sealed"
	/// control module base state; defaults to base_state
	var/control_base_state
	/// control module worn icon uses base state; defaults to control_base_state, then base_state
	var/control_base_state_worn
	/// default coloration colors
	var/list/coloration_colors
	/// default coloration matrix
	var/list/coloration_matrix
	/// default coloration mode
	var/coloration_mode = COLORATION_MODE_NONE
	/// default coloration amount
	var/coloration_amount = 0
	/// bodytypes implemented
	var/datum/bodytypes/worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	/// fallback bodytypes
	var/datum/bodytypes/worn_bodytypes_fallback = BODYTYPES_ALL

	//* base stats
	/// startup / shutdown time
	var/boot_delay = 5 SECONDS
	/// piece seal/unseal time
	var/seal_delay = 3 SECONDS
	/// base weight
	#warn weight
	var/offline_weight = 0
	/// base encumbrance
	#warn encumbrance
	var/offline_encumbrance = 0
	/// base online weight
	#warn weight
	var/online_weight = 0
	/// base online encumbrance
	#warn encumbrance
	var/online_encumbrance = 0

	//* vars to be replaced by components/modules at some point
	var/datum/armor/armor = /datum/armor/rigsuit
	var/min_pressure_protect = 0 * ONE_ATMOSPHERE
	var/max_pressure_protect = 2 * ONE_ATMOSPHERE
	var/min_temperature_protect = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	var/max_temperature_protect = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	var/insulated_gloves = TRUE
	var/siemens_coefficient = 0.3

	#warn values lmao

/datum/rig_theme/New()
	CONSTRUCT_BODYTYPES(worn_bodytypes)
	CONSTRUCT_BODYTYPES(worn_bodytypes_fallback)
	var/list/old_pieces = pieces
	pieces = list()
	for(var/path in old_pieces)
		add_piece(path)

/datum/rig_theme/proc/imprint_control_appearance(obj/item/rig/control_module)
	control_module.icon = base_icon
	// todo: optimize
	// state
	control_module.state_sealed = "[control_base_state || base_state][control_state_append][control_sealed_append]"
	control_module.state_unsealed = "[control_base_state || base_state][control_state_append]"
	control_module.state_worn_sealed = "[control_base_state_worn || control_base_state || base_state][control_state_append][control_sealed_append]"
	control_module.state_worn_unsealed = "[control_base_state_worn || control_base_state || base_state][control_state_append]"
	// coloration
	control_module.coloration_amount = ccoloration_amount
	control_module.coloration_mode = coloration_mode
	if(control_module.coloration_mode == COLORATION_MODE_MATRIX)
		control_module.set_coloration_matrix(coloration_matrix)
	else
		control_module.set_coloration_parts(coloration_colors)
	#warn impl
	// update
	control_module.update_icon()
	control_module.update_encumbrance()
	control_module.update_weight()

/datum/rig_theme/proc/imprint_control_behavior(obj/item/rig/control_module)
	control_module.siemens_coefficient = siemens_coefficient
	control_module.offline_encumbrance = offline_encumbrance
	control_module.offline_weight = offline_weight
	control_module.online_encumbrance = online_encumbrance
	control_module.online_weight = online_weight
	control_module.boot_delay = boot_delay
	control_module.seal_delay = seal_delay
	#warn impl

/datum/rig_theme/proc/imprint_control_legacy(obj/item/rig/control_module)
	#warn impl - vars like armor/insulated/etc

/datum/rig_theme/proc/add_piece(datum/rig_piece/piece_path)
	if(ispath(piece_path))
		piece_path = new piece_path
	#warn imprint piece with base states

/datum/rig_theme/proc/apply_piece(datum/component/rig_piece/piece)
	#warn impl

/**
 * RIG piece definition datums
 * Should only ever be belonging to one /datum/rig_theme at a time
 */
/datum/rig_piece
	abstract_type = /datum/rig_piece
	/// path
	var/path
	/// display name - overrides name on UIs
	var/display_name
	/// visible name - appended directly to host theme's visible name
	var/visible_name
	/// piece component flags
	var/rig_piece_flags = NONE
	/// multiplier for armor to apply - does not affect tier.
	/// > 1 values don't scale the same as < 1 for balancing reasons,
	/// and will intsead use 2 = 50% *more armor* as opposed to 2x raw armor
	/// e.g. 1 = 0.5, 2 = 0.75, 3 = 0.875, etc.
	var/armor_multiplier = 1
	/// this piece's state append - this is separate from base_state so overriding is easier
	var/piece_state_append
	/// sealed state append
	var/sealed_state_append = "-sealed"
	/// base state - defaults to rig theme
	var/piece_base_state
	/// base state used when worn - defaults to piece_base_state, then rig theme
	var/piece_base_state_worn
	/// worn rendering flags
	var/worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	/// bodytypes implemented
	var/datum/bodytypes/worn_bodytypes
	/// fallback bodytypes
	var/datum/bodytypes/worn_bodytypes_fallback
	/// slot this goes in - SLOT_ID_HANDS for an inhand item. specific-hand binding not supported yet.
	var/equip_slot
	/// inv hide flags while unsealed
	var/inv_hide_flags_inactive = NONE
	/// inv hide flags while sealed
	var/inv_hide_flags_active = NONE
	/// default coloration colors - defaults to rig theme
	var/list/coloration_colors
	/// default coloration matrix - defaults to rig theme
	var/list/coloration_matrix
	/// default coloration mode - defaults to rig theme
	var/coloration_mode
	/// default coloration amount - defaults to rig theme
	var/coloration_amount
	/// seal delay add to base seal delay
	var/piece_seal_delay_adjust = 0

/datum/rig_piece/New()
	CONSTRUCT_BODYTYPES(worn_bodytypes)
	CONSTRUCT_BODYTYPES(worn_bodytypes_fallback)

/**
 * returns rig_piece component
 */
/datum/rig_piece/proc/instantiate(datum/rig_theme/theme, obj/item/rig/controller)
	ASSERT(ispath(path, /obj/item))
	var/obj/item/created_item = new path(controller)
	var/datum/component/rig_piece/created_piece = created_item.AddComponent(/datum/component/rig_piece, controller)
	imprint_appearance(theme, created_piece)
	imprint_behavior(theme, created_piece)
	// trigger an update by unsealing
	created_piece.unseal()
	return created_piece

/datum/rig_piece/proc/imprint_appearance(datum/rig_theme/theme, datum/component/rig_piece/piece_component)
	var/obj/item/physical = piece_component.parent
	// inv appearance / hide flags
	piece_component.inv_hide_flags_sealed = inv_hide_flags_active
	piece_component.inv_hide_flags_unsealed = inv_hide_flags_inactive
	// bodytypes
	physical.worn_bodytypes = worn_bodytypes
	physical.worn_bodytypes_fallback = worn_bodytypes_fallback
	// state
	piece_component.state_sealed = "[piece_base_state || theme.base_state][piece_state_append][sealed_state_append]"
	piece_component.state_unsealed = "[piece_base_state || theme.base_state][piece_state_append]"
	piece_component.state_worn_sealed = "[piece_base_state_worn || piece_base_state || theme.base_state][piece_state_append][sealed_state_append]"
	piece_component.state_worn_unsealed = "[piece_base_state_worn || piece_base_state || theme.base_state][piece_state_append]"
	// coloration
	physical.coloration_amount = isnull(coloration_amount)? theme.coloration_amount : coloration_amount
	physical.coloration_mode = isnull(coloration_mode)? theme.coloration_mode : coloration_mode
	if(physical.coloration_mode == COLORATION_MODE_MATRIX)
		physical.set_coloration_matrix(isnull(coloration_matrix)? theme.coloration_matrix : coloration_matrix)
	else
		physical.set_coloration_parts(isnull(coloration_colors)? theme.coloration_colors : coloration_colors)
	#warn impl

/datum/rig_piece/proc/imprint_behavior(datum/rig_theme/theme, datum/component/rig_piece/piece_component)
	var/obj/item/physical = piece_component.parent
	piece_component.inv_hide_flags_sealed = inv_hide_flags_active
	piece_component.inv_hide_flags_unsealed = inv_hide_flags_inactive
	piece_component.rig_piece_flags = rig_piece_flags
	piece_component.inventory_slot = equip_slot

/datum/rig_piece/helmet
	display_name = "helmet"
	visible_name = "Helmet"
	path = /obj/item/clothing/head/rig
	rig_piece_flags = RIG_PIECE_APPLY_ARMOR | RIG_PIECE_APPLY_ENVIRONMENTALS
	piece_state_append = "-helmet"
	inv_hide_flags_active = HIDEFACE | HIDEEARS | HIDEEARS | HIDEEYES | HIDEMASK | BLOCKHEADHAIR

/datum/rig_piece/chestplate
	display_name = "chestplate"
	visible_name = "Chestplate"
	path = /obj/item/clothing/suit/rig
	rig_piece_flags = RIG_PIECE_APPLY_ARMOR | RIG_PIECE_APPLY_ENVIRONMENTALS
	piece_state_append = "-chestplate"
	inv_hide_flags_active = HIDETAIL | HIDEJUMPSUIT | HIDETIE

/datum/rig_piece/gloves
	display_name = "gauntlets"
	visible_name = "Gauntlets"
	path = /obj/item/clothing/gloves/rig
	rig_piece_flags = RIG_PIECE_APPLY_ARMOR | RIG_PIECE_APPLY_ENVIRONMENTALS
	piece_state_append = "-gloves"

/datum/rig_piece/gloves/imprint_behavior(datum/rig_theme/theme, datum/component/rig_piece/piece_component)
	. = ..()
	// todo: legacy
	if(theme.insulated_gloves)
		piece_component.always_fully_insulated = TRUE

/datum/rig_piece/boots
	display_name = "boots"
	visible_name = "Boots"
	path = /obj/item/clothing/shoes/rig
	rig_piece_flags = RIG_PIECE_APPLY_ARMOR | RIG_PIECE_APPLY_ENVIRONMENTALS
	piece_state_append = "-boots"
