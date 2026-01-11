//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * RIG piece definition datums
 * Should only ever be belonging to one /datum/rig_theme at a time
 */
/datum/rig_theme_piece
	abstract_type = /datum/rig_theme_piece
	/// path
	var/path
	/// display name - overrides name on UIs
	var/display_name
	/// visible name - appended directly to host theme's visible name
	var/visible_name
	/// lookup prefix
	var/lookup_prefix
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
	/// body cover flags
	var/body_cover_flags = NONE
	/// rig zone flags
	var/rig_zone_bits = NONE

/datum/rig_theme_piece/New()
	CONSTRUCT_BODYTYPES(worn_bodytypes)
	CONSTRUCT_BODYTYPES(worn_bodytypes_fallback)

/**
 * returns rig_piece component
 */
/datum/rig_theme_piece/proc/instantiate(datum/rig_theme/theme, obj/item/rig/controller)
	ASSERT(ispath(path, /obj/item))
	var/obj/item/created_item = new path(controller)
	var/datum/component/rig_piece/created_piece = created_item.AddComponent(/datum/component/rig_piece, controller)
	imprint_appearance(theme, created_piece)
	imprint_behavior(theme, created_piece)
	// trigger an update by unsealing
	created_piece.unseal()
	return created_piece

/datum/rig_theme_piece/proc/imprint_appearance(datum/rig_theme/theme, datum/component/rig_piece/piece_component)
	var/obj/item/physical = piece_component.parent
	// inv appearance / hide / cover flags
	piece_component.inv_hide_flags_sealed = inv_hide_flags_active
	piece_component.inv_hide_flags_unsealed = inv_hide_flags_inactive
	physical.body_cover_flags = body_cover_flags
	physical.heat_protection_cover = body_cover_flags
	physical.cold_protection_cover = body_cover_flags
	// rendering
	physical.worn_render_flags = worn_render_flags || theme.worn_render_flags
	// bodytypes
	physical.worn_bodytypes = worn_bodytypes || theme.worn_bodytypes
	physical.worn_bodytypes_fallback = worn_bodytypes_fallback || theme.worn_bodytypes_fallback
	// icon
	physical.icon = theme.base_icon
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

/datum/rig_theme_piece/proc/imprint_behavior(datum/rig_theme/theme, datum/component/rig_piece/piece_component)
	var/obj/item/physical = piece_component.parent
	piece_component.inv_hide_flags_sealed = inv_hide_flags_active
	piece_component.inv_hide_flags_unsealed = inv_hide_flags_inactive
	piece_component.rig_piece_flags = rig_piece_flags
	piece_component.inventory_slot = equip_slot
	piece_component.lookup_prefix = lookup_prefix
	piece_component.rig_zone_bits = rig_zone_bits

/datum/rig_theme_piece/helmet
	display_name = "helmet"
	visible_name = "Helmet"
	lookup_prefix = "helmet"
	path = /obj/item/clothing/head/rig
	rig_piece_flags = RIG_PIECE_APPLY_ARMOR | RIG_PIECE_APPLY_ENVIRONMENTALS
	piece_state_append = "-helmet"
	inv_hide_flags_active = HIDEFACE | HIDEEARS | HIDEEARS | HIDEEYES | HIDEMASK | BLOCKHEADHAIR
	equip_slot = /datum/inventory_slot_meta/inventory/head
	body_cover_flags = HEAD

/datum/rig_theme_piece/chestplate
	display_name = "chestplate"
	visible_name = "Chestplate"
	lookup_prefix = "torso"
	path = /obj/item/clothing/suit/rig
	rig_piece_flags = RIG_PIECE_APPLY_ARMOR | RIG_PIECE_APPLY_ENVIRONMENTALS
	piece_state_append = "-chestplate"
	inv_hide_flags_active = HIDETAIL | HIDEJUMPSUIT | HIDETIE
	equip_slot = /datum/inventory_slot_meta/inventory/suit
	body_cover_flags = UPPER_TORSO | LOWER_TORSO | ARMS | LEGS

/datum/rig_theme_piece/gloves
	display_name = "gauntlets"
	visible_name = "Gauntlets"
	lookup_prefix = "arms"
	path = /obj/item/clothing/gloves/rig
	rig_piece_flags = RIG_PIECE_APPLY_ARMOR | RIG_PIECE_APPLY_ENVIRONMENTALS
	piece_state_append = "-gloves"
	equip_slot = /datum/inventory_slot_meta/inventory/gloves
	body_cover_flags = HANDS

/datum/rig_theme_piece/gloves/imprint_behavior(datum/rig_theme/theme, datum/component/rig_piece/piece_component)
	. = ..()
	// todo: legacy
	if(theme.insulated_gloves)
		piece_component.always_fully_insulated = TRUE

/datum/rig_theme_piece/boots
	display_name = "boots"
	visible_name = "Boots"
	lookup_prefix = "legs"
	path = /obj/item/clothing/shoes/rig
	rig_piece_flags = RIG_PIECE_APPLY_ARMOR | RIG_PIECE_APPLY_ENVIRONMENTALS
	piece_state_append = "-boots"
	equip_slot = /datum/inventory_slot_meta/inventory/shoes
	body_cover_flags = FEET
