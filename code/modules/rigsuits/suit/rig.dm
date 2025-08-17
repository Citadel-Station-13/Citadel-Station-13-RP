//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

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

	//* Activation *//
	/// activation state
	var/activation_state = RIG_ACTIVATION_OFFLINE
	/// currently in an activation operation.
	/// do not fuck with this var.
	var/activation_mutex = FALSE
	/// activation operation identifier - this lets us abort by just changing this while the loop is running
	var/activation_operation = 0

	//* Appearance (Self) *//
	var/state_worn_sealed
	var/state_worn_unsealed
	var/state_sealed
	var/state_unsealed

	//* Console *//
	/// Our console
	var/datum/rig_console/console

	//* Control *//
	#warn todo

	//* Defense *//

	//* Environmentals *//
	#warn todo

	//* Legacy - to be made into dynamic data once components/modules are done. *//
	var/datum/armor/suit_armor
	var/min_pressure_protect
	var/max_pressure_protect
	var/min_temperature_protect
	var/max_temperature_protect

	//* Internal *//
	/// lookup id
	var/next_lookup_id = 0

	//* Maintenance *//
	/// panel datum to host our maint tgui
	/// lazy-init'd
	var/datum/rig_maint_panel/maint_panel
	/// is the panel open?
	var/maint_panel_open = FALSE
	/// is the panel locked?
	var/maint_panel_locked = FALSE
	/// is the panel broken?
	var/maint_panel_broken = FALSE
	/// points of health left on the panel
	var/maint_panel_integrity = 100
	/// points of health normally on the panel
	var/maint_panel_integrity_max = 100
	/// armor on panel - lazy-grabbed
	var/datum/armor/maint_panel_armor
	/// armor type on panel
	var/maint_panel_armor_type = /datum/armor/object/light

	//* Modules *//
	/// list of /obj/item/rig_module's by its lookup_id
	var/list/obj/item/rig_module/module_lookup
	/// total weight of all modules
	var/module_weight_tally = 0
	/// registered high power load from modules
	var/module_power_high = 0
	/// registered low power load from modules
	var/module_power_low = 0
	/// conflict enums and types
	var/list/module_conflict_lookup

	//* Pieces *//
	/// list of /datum/component/rig_piece's by its lookup_id
	var/list/datum/component/rig_piece/piece_lookup

	//* Power *//
	#warn todo.

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

	//* Resources *//
	/// resource bus
	var/datum/item_mount/rig_resources/resources

	//* Theme *//
	/// default theme
	var/theme_preset = /datum/rig_theme/station/civilian/standard
	/// Is our theme initialized?
	var/theme_initialized = FALSE
	/// theme name - this is the fluff/player facing name
	var/theme_name = "Unknown"

	//* UI *//
	/// update timerid
	var/ui_queued_timer
	/// core systems awaiting update
	var/ui_queued_general = FALSE
	/// piece + component + module list awaiting update
	var/ui_queued_reflists = FALSE
	/// such a big change has happened that everything is queued
	/// this will *not* resend module static data!
	var/ui_queued_everything = FALSE
	/// pieces awaiting update
	var/list/datum/component/rig_piece/ui_queued_pieces
	/// modules awaiting update
	var/list/obj/item/rig_module/ui_queued_modules
	//! todo: this is fucking evil
	/// cached b64 string of our UI icon
	var/cached_tgui_icon_b64
	/// ui theme, set by the theme datum; if null, use default
	#warn hook
	var/ui_theme

	//* Wearer *//
	/// Our wearer
	var/mob/wearer
	/// What slot we must be in - typepath or ID.
	var/wearer_required_slot_id = /datum/inventory_slot_meta/inventory/back

	//* Zones *//
	var/datum/rig_zone/z_head = new /datum/rig_zone/head
	var/datum/rig_zone/z_chest = new /datum/rig_zone/chest
	var/datum/rig_zone/z_left_arm = new /datum/rig_zone/left_arm
	var/datum/rig_zone/z_right_arm = new /datum/rig_zone/right_arm
	var/datum/rig_zone/z_left_leg = new /datum/rig_zone/left_leg
	var/datum/rig_zone/z_right_leg = new /datum/rig_zone/right_leg

#warn impl all

//* Main

/obj/item/rig/Initialize(mapload, datum/rig_theme/theme_like)
	. = ..()
	resources = new(src)
	// todo: this is shitcode and just bypasses the init sleep check, if shit breaks idfk lmao
	INVOKE_ASYNC(src, PROC_REF(init_theme), theme_like || theme_preset)

/obj/item/rig/Destroy()
	hard_reset()
	wipe_everything()
	QDEL_NULL(resources)
	QDEL_NULL(console)
	QDEL_NULL(maint_panel)
	QDEL_NULL(z_head)
	QDEL_NULL(z_chest)
	QDEL_NULL(z_left_arm)
	QDEL_NULL(z_right_arm)
	QDEL_NULL(z_left_leg)
	QDEL_NULL(z_right_leg)
	return ..()

/obj/item/rig/examine(mob/user, dist)
	. = ..()
	. += SPAN_NOTICE("<b>Alt-Click</b> while holding this or nearby to access the back panel.")

/obj/item/rig/context_query(datum/event_args/actor/e_args)
	. = ..()
	var/image/back_image = image(src)
	.["panel"] = ATOM_CONTEXT_TUPLE("back panel", back_image, 1, MOBILITY_CAN_USE)

/obj/item/rig/context_act(datum/event_args/actor/e_args, key)
	switch(key)
		if("panel")
			var/datum/rig_maint_panel/panel = request_maint()
			// todo: performer vs initiator
			panel.ui_interact(e_args.performer)
			return TRUE
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
	for(var/id in piece_lookup)
		var/datum/component/rig_piece/piece = piece_lookup[id]
		remove_piece(piece)
	#warn annihilate modules
	z_head.reset_state_after_wipe()
	z_chest.reset_state_after_wipe()
	z_left_arm.reset_state_after_wipe()
	z_right_arm.reset_state_after_wipe()
	z_left_leg.reset_state_after_wipe()
	z_right_leg.reset_state_after_wipe()
	ui_queue_everything()

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

//* Console *//

/obj/item/rig/proc/request_console()
	RETURN_TYPE(/datum/rig_console)
	if(isnull(console))
		console = new(src)
	return console

//* Inventory *//

/obj/item/rig/strip_menu_options(mob/user)
	. = ..()
	.["maint"] = "Access Panel"

/obj/item/rig/strip_menu_act(mob/user, action)
	. = ..()
	if(.)
		return
	if(action == "maint")
		var/datum/rig_maint_panel/panel = request_maint()
		panel.ui_interact(user)
		return TRUE

//* Maintenance *//

/obj/item/rig/proc/request_maint()
	RETURN_TYPE(/datum/rig_maint_panel)
	if(isnull(maint_panel))
		maint_panel = new(src)
	return maint_panel

/obj/item/rig/proc/is_maint_panel_locked()
	// todo: better access locking? maybe. for now, it's always unlocked if not being worn.
	return maint_panel_locked && (activation_state == RIG_ACTIVATION_ONLINE)

/obj/item/rig/proc/assert_maint_panel_armor()
	#warn impl

/obj/item/rig/proc/repair_maint_panel(datum/event_args/actor/actor, obj/item/tool)

/obj/item/rig/proc/attack_maint_panel(datum/event_args/actor/actor, obj/item/tool, damage_multiplier = 1)

/obj/item/rig/proc/cut_maint_panel(datum/event_args/actor/actor, obj/item/tool)

#warn handling for armor etc etc
