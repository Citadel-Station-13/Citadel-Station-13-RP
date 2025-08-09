//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

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
		/datum/rig_theme_piece/helmet,
		/datum/rig_theme_piece/chestplate,
		/datum/rig_theme_piece/gloves,
		/datum/rig_theme_piece/boots,
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
	/// render flags
	var/worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	/// TGUI theme; unset to default
	var/ui_theme

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
	var/max_pressure_protect = 10 * ONE_ATMOSPHERE
	var/min_temperature_protect = COLD_PROTECTION_VOIDSUIT
	var/max_temperature_protect = HEAT_PROTECTION_NORMAL_VOIDSUIT
	var/insulated_gloves = TRUE
	// todo: this should be dropped down way more later so tasers hit the suit instead of the user
	//       this is pretty much a maintainer mandate too so discuss before trying to go against this
	//       if you're reading it
	//       hardsuits, like armor, absolutely should be one of those things that forces a lethal
	//       engagement if you don't want an easy 3 click win via stuns
	//       that said, ions/electrical stuns absolutely should fuck up internal systems and cause lockups
	//       so it's still very useful to pack a taser to a rig fight
	var/siemens_coefficient = 0.8

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
	control_module.coloration_amount = coloration_amount
	control_module.coloration_mode = coloration_mode
	if(control_module.coloration_mode == COLORATION_MODE_MATRIX)
		control_module.set_coloration_matrix(coloration_matrix)
	else
		control_module.set_coloration_parts(coloration_colors)
	// rendering
	control_module.worn_render_flags = worn_render_flags
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
	control_module.theme_name = display_name || name
	control_module.ui_theme = ui_theme
	#warn impl

/datum/rig_theme/proc/imprint_control_legacy(obj/item/rig/control_module)
	#warn impl - vars like armor/insulated/etc

/datum/rig_theme/proc/add_piece(datum/rig_theme_piece/piece_path)
	var/datum/rig_theme_piece/piece
	if(ispath(piece_path) || IS_ANONYMOUS_TYPEPATH(piece_path))
		piece = new piece_path
	else if(istype(piece_path))
		piece = piece_path
	pieces += piece

/datum/rig_theme/proc/apply_piece(datum/component/rig_piece/piece)
	#warn impl

