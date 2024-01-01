//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * # Rigsuits
 *
 * Modular suit system.
 *
 * ## Pieces
 *
 * * Pieces automatically un/seal based on activation state when un/deploying.
 */
/obj/item/rig
	name = "rig control module"
	desc = "A control module for some kind of suit."
	w_class = WEIGHT_CLASS_HUGE
	slot_flags = SLOT_BACK


	#warn we gotta refactor actions for this lmao, esp for remote control (?!!)
	action_button_name = "Debug UI"

	//* Activation
	/// activation state
	var/activation_state = RIG_ACTIVATION_OFFLINE
	/// currently in an activation operation.
	/// do not fuck with this var.
	var/activation_mutex = FALSE
	/// activation operation identifier - this lets us abort by just changing this while the loop is running
	var/activation_operation = 0

	//* Appearance (Self)
	var/state_worn_sealed
	var/state_worn_unsealed
	var/state_sealed
	var/state_unsealed

	//* Console
	/// Our console
	var/datum/rig_console/console

	//* Control
	// todo.

	//* Legacy - to be made into dynamic data once components/modules are done.
	var/datum/armor/suit_armor
	var/min_pressure_protect
	var/max_pressure_protect
	var/min_temperature_protect
	var/max_temperature_protect

	//* Internal
	/// lookup id
	var/next_lookup_id = 0

	//* Maintenance
	/// panel datum to host our maint tgui
	/// lazy-init'd
	var/datum/rig_maint_panel/maint_panel

	//* Modules
	//  todo: unfinished
	/// list of /obj/item/rig_module's by its lookup_id
	var/list/obj/item/rig_module/module_lookup

	//* Pieces
	/// list of /datum/component/rig_piece's by its lookup_id
	var/list/datum/component/rig_piece/piece_lookup
	/// direct access cache to the items held by those pieces
	var/list/obj/item/piece_items

	//* Stats - Base
	/// startup/shutdown time
	var/boot_delay
	/// seal/unseal time
	//  todo: maybe by-piece ones too..?
	var/seal_delay
	/// offline weight
	var/offline_weight
	/// offline encumbrance
	//  todo: maybe by-piece ones too..?
	var/offline_encumbrance
	/// online weight
	var/online_weight
	/// online encumbrance
	//  todo: maybe by-piece ones too..?
	var/online_encumbrance

	//* Theme
	/// default theme
	var/theme_preset = /datum/rig_theme/station/civilian/standard
	/// Is our theme initialized?
	var/theme_initialized = FALSE
	/// theme name - this is the fluff/player facing name
	var/theme_name = "Unknown"

	//* UI
	/// update timerid
	var/ui_queued_timer
	/// core systems awaiting update
	var/ui_queued_general = FALSE
	/// piece + component + module list awaiting update
	var/ui_queued_reflists = FALSE
	/// such a big change has happened that everything is queued
	var/ui_queued_everything = FALSE
	/// pieces awaiting update
	var/list/datum/component/rig_piece/ui_queued_pieces
	/// modules awaiting update
	var/list/obj/item/rig_module/ui_queued_modules
	//! todo: this is fucking evil
	/// cached b64 string of our UI icon
	var/cached_tgui_icon_b64

	//* Wearer
	/// Our wearer
	var/mob/wearer
	/// What slot we must be in - typepath or ID.
	var/wearer_required_slot_id = /datum/inventory_slot_meta/inventory/back

#warn impl all

//* Main

/obj/item/rig/Initialize(mapload, datum/rig_theme/theme_like)
	. = ..()
	// todo: this is shitcode and just bypasses the init sleep check, if shit breaks idfk lmao
	INVOKE_ASYNC(src, PROC_REF(init_theme), theme_like || theme_preset)

/obj/item/rig/Destroy()
	hard_reset()
	wipe_everything()
	QDEL_NULL(console)
	QDEL_NULL(maint_panel)
	return ..()

/obj/item/rig/unequipped()
	. = ..()
	// todo: should we optimize this?
	hard_reset()
	wearer = null

/obj/item/rig/dropped(mob/user, flags, atom/newLoc)
	. = ..()
	push_ui_data(data = list("wornCorrectly" = is_in_right_slot()))

/obj/item/rig/equipped(mob/user, slot, flags)
	. = ..()
	var/right_slot = is_in_right_slot()
	push_ui_data(data = list("wornCorrectly" = right_slot))
	if(right_slot)
		wearer = user

/obj/item/rig/proc/hard_reset()
	deactivate(TRUE, TRUE, TRUE, TRUE)

/obj/item/rig/proc/wipe_everything()
	hard_reset()
	#warn impl

/obj/item/rig/get_encumbrance()
	return fully_activated()? online_encumbrance : offline_encumbrance

/obj/item/rig/get_weight()
	return fully_activated()? online_weight : offline_weight

/obj/item/rig/update_icon_state()
	if(partially_activated())
		icon_state = state_sealed
		worn_state = state_worn_sealed
	else
		icon_state = state_unsealed
		worn_state = state_worn_unsealed
	return ..()

#warn debug only code below

/obj/item/rig/ui_action_click(datum/action/action, mob/user)
	. = ..()
	ui_interact(user)

//* Console

/obj/item/rig/proc/request_console()
	RETURN_TYPE(/datum/rig_console)
	if(isnull(rig_console))
		rig_console = new(src)
	return rig_console
