//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * separate maintenance handler from main rig interface
 */
/datum/rig_maint_panel
	/// owner
	var/obj/item/rig/host

/datum/rig_maint_panel/New(obj/item/rig/rig)
	src.host = rig

/datum/rig_maint_panel/Destroy()
	src.host = null
	return ..()

/datum/rig_maint_panel/ui_host()
	return host

/datum/rig_maint_panel/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()
	.["activation"] = host.activation_state
	var/list/assembled_ids = list()
	for(var/id in host.piece_lookup)
		assembled_ids += id
	.["pieceIDs"] = assembled_ids
	// .["console"] = host.request_console().tgui_console_data()
	.["theme"] = host.theme_name
	// todo: b64 is shit
	.["sprite64"] = host.cached_tgui_icon_b64 || (host.cached_tgui_icon_b64 = icon2base64(icon(host.icon, host.icon_state, SOUTH, 1, FALSE)))
	#warn piece IDs updates

/datum/rig_maint_panel/ui_data(mob/user, datum/tgui/ui)
	. = ..()
	// todo: update this more smartly with push data instead
	.["panelLock"] = host.maint_panel_locked
	.["panelOpen"] = host.maint_panel_open
	.["panelBroken"] = host.maint_panel_broken
	.["panelIntegrityRatio"] = host.maint_panel_integrity / host.maint_panel_integrity_max

/datum/rig_maint_panel/ui_static_modules(mob/user, datum/tgui/ui)
	. = ..()
	for(var/id in host.piece_lookup)
		var/datum/component/rig_piece/piece = host.piece_lookup[id]
		.[piece.lookup_id] = list(
			"id" = piece.lookup_id,
			"sealed" = piece.sealed,
			"deployed" = piece.is_deployed(),
		)

/datum/rig_maint_panel/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	switch(action)
		if("smashPanel")
			// todo: clickcd rewrite
			if(usr.next_click > world.time)
				return FALSE
			host.attack_maint_panel(new /datum/event_args/actor(usr), usr.get_active_held_item())
			return TRUE
		if("fixPanel")
			host.repair_maint_panel(new /datum/event_args/actor(usr), usr.get_active_held_item())
			return FALSE
		if("openPanel")
			#warn impl
		if("cutPanel")
			host.cut_maint_panel(new /datum/event_args/actor(usr), usr.get_active_held_item())
			return FALSE
		if("consoleInput")
			var/raw = params["command"]
			var/datum/rig_console/console = host.request_console()
			console.input_command(usr, raw, effective_control_flags = RIG_CONTROL_FLAGS_MAINT_PANEL, username = "root")
			return FALSE
		if("forceUnseal")
			var/piece = params["piece"]
			#warn impl
		if("forceSeal")
			var/piece = params["piece"]
			#warn impl
		if("forceDeploy")
			var/piece = params["piece"]
			#warn impl
		if("forceRetract")
			var/piece = params["piece"]
			#warn impl

/datum/rig_maint_panel/ui_route(action, list/params, datum/tgui/ui, id)
	#warn agh
	return ..()

/datum/rig_maint_panel/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "RigsuitMaintenance")
		ui.open()

#warn impl all
