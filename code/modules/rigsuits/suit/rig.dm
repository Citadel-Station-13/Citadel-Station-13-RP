//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * # Rigsuits
 *
 * Modular suit system.
 *
 * ## Modules
 * * Modules are stored on the rig, not the rig theme.
 * * Module capacity / handling is sometimes determined by theme.
 *
 * ## Pieces
 * * Pieces are determined and created by theme.
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

	//* Hotbinds *//

	/// active hotbinds
	/// * lazy list
	var/list/datum/rig_hotbind/hotbinds

	//* Input *//
	/// Active module to route clicks to
	var/obj/item/rig_module/rig_module_click_active

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
	/// allow the wearer to reach their own maint panel
	/// * overpowered as hell; do not allow this by default!
	var/maint_panel_allow_wearer = FALSE

	//* Modules *//
	/// list of all modules in us; set to list to init on creation.
	VAR_PROTECTED/list/obj/item/rig_module/modules
	/// modules are online? this is FALSE if we ever run out of power, until module buffer is
	/// refilled.
	var/modules_online = TRUE
	/// list of /obj/item/rig_module's by its lookup_id
	VAR_PROTECTED/list/module_lookup
	/// total weight of all modules
	var/module_weight_tally = 0

	//* Pieces *//
	/// list of all /datum/component/rig_piece's
	VAR_PROTECTED/list/datum/component/rig_piece/pieces
	/// list of /datum/component/rig_piece's by its lookup_id
	VAR_PROTECTED/list/piece_lookup

	//* Power *//

	/// used for modules, functions, etc.
	var/datum/rig_power_bus/power_main_bus
	var/datum/rig_power_bus/power_aux_bus
	var/power_main_cell_type = /obj/item/cell/high
	var/power_aux_cell_type = /obj/item/cell/device/weapon

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
	/// default theme; set this to a datum path
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
	/// wearer actor hud
	/// * actor HUDs are used to separate intent from wearer vs controllers.
	var/datum/actor_hud/wearer_hud
	/// What slot we must be in - id
	var/wearer_required_slot_id = /datum/inventory_slot_meta/inventory/back::id

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
	#warn initialize power bus
	// todo: this is shitcode and just bypasses the init sleep check, if shit breaks idfk lmao
	INVOKE_ASYNC(src, PROC_REF(init_theme), theme_like || theme_preset)

/obj/item/rig/Destroy()
	hard_reset()
	wipe_everything()
	QDEL_NULL(power_main_bus)
	QDEL_NULL(power_aux_bus)
	QDEL_NULL(resources)
	// QDEL_NULL(console)
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

/obj/item/rig/proc/set_wearer(mob/new_wearer)
	if(wearer)
		UnregisterSignal(wearer, list(
			COMSIG_MOB_STATPANEL_STATUS_INJECTION,
		))
	wearer = new_wearer
	if(wearer)
		RegisterSignal(wearer, COMSIG_MOB_STATPANEL_STATUS_INJECTION, PROC_REF(wearer_on_statpanel_status))

/obj/item/rig/proc/wearer_on_statpanel_status(mob/source, list/data)
	#warn add cell data
	ADD_STATPANEL_DATA_ENTRY("[src] - Charge", "0")
	SEND_SIGNAL(src, COMSIG_RIG_STATPANEL_STATUS_INJECTION, data)

/obj/item/rig/proc/hard_reset()
	deactivate(TRUE, TRUE, TRUE, TRUE)

/obj/item/rig/proc/wipe_everything(skip_modules)
	hard_reset()
	for(var/id in piece_lookup)
		var/datum/component/rig_piece/piece = piece_lookup[id]
		remove_piece(piece)
	if(!skip_modules)
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


//* Processing *//

/obj/item/rig/process(delta_time)

	if(activation_state == RIG_ACTIVATION_OFFLINE)
		return
	process_power(delta_time)
	for(var/obj/item/rig_module/module as anything in get_modules())
		if(module.host_ticked)
			module.handle_rig_tick(delta_time)

	#warn impl
