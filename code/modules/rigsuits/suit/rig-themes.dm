//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/item/rig/proc/init_theme(datum/rig_theme/override)
	if(isnull(override))
		override = theme_preset
	if(isnull(override))
		override = initial(theme_preset)
	if(ispath(override))
		override = fetch_rig_theme(override)
	ASSERT(istype(override))
	wipe_everything(TRUE)
	theme_initialized = TRUE
	var/datum/rig_theme/initializing = override
	initializing.imprint_control_appearance(src)
	initializing.imprint_control_behavior(src)
	initializing.imprint_control_legacy(src)
	for(var/datum/rig_theme_piece/piece_data as anything in initializing.pieces)
		var/datum/component/rig_piece/piece = piece_data.instantiate(initializing, src)
		add_piece(piece)
		legacy_sync_piece(piece)
	// todo: modules
	ui_queue_everything()

/obj/item/rig/proc/ensure_theme()
	if(theme_initialized)
		return
	init_theme()
