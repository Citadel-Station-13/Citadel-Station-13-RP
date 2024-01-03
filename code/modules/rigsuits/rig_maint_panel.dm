//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

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
	.["console"] = host.request_console().tgui_console_data()
	#warn piece IDs updates
	#warn console update

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
			id = piece.lookup_id,
			sealed = piece.sealed,
			deployed = piece.is_deployed(),
		)

/datum/rig_maint_panel/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	switch(action)
		if("smashPanel")
			#warn impl
		if("fixPanel")
			#warn impl
		if("openPanel")
			#warn impl
		if("cutPanel")
			#warn impl
		if("consoleInput")
			var/raw = params["command"]
			#warn impl
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
