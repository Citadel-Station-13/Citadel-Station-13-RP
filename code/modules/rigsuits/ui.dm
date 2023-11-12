//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//* WELCOME TO THE SEVENTH CIRCLE OF WEBDEV HELL
/// For efficiency, rigs will internally track and cache what needs to update.
/// We heavily abuse the TGUI modules system to selectively update data
/// with the module system's 2-deep reducer.

/obj/item/rig/proc/ui_queue()
	ui_queued_general = TRUE
	if(isnull(ui_queued_timer))
		ui_queued_timer = addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/item/rig, ui_flush), 0, TIMER_STOPPABLE))

/obj/item/rig/proc/ui_queue_piece(datum/component/rig_piece/piece)
	LAZYADD(ui_queued_pieces, piece)
	if(isnull(ui_queued_timer))
		ui_queued_timer = addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/item/rig, ui_flush), 0, TIMER_STOPPABLE))

/obj/item/rig/proc/ui_queue_module(obj/item/rig_module/module)
	LAZYADD(ui_queued_modules, module)
	if(isnull(ui_queued_timer))
		ui_queued_timer = addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/item/rig, ui_flush), 0, TIMER_STOPPABLE))

/obj/item/rig/proc/ui_queue_reflists()
	ui_queued_reflists = TRUE
	if(isnull(ui_queued_timer))
		ui_queued_timer = addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/item/rig, ui_flush), 0, TIMER_STOPPABLE))

/obj/item/rig/proc/ui_queue_everything()
	ui_queued_everything = TRUE
	if(isnull(ui_queued_timer))
		ui_queued_timer = addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/item/rig, ui_flush), 0, TIMER_STOPPABLE))

/obj/item/rig/proc/ui_flush()
	if(!isnull(ui_queued_timer))
		deltimer(ui_queued_timer)
	if(ui_queued_everything)
		ui_queued_everything = FALSE
		ui_queued_general = FALSE
		ui_queued_reflists = FALSE
		ui_queued_pieces = null
		ui_queued_modules = null

		var/list/assembled_fragments = list()
		var/list/piece_refs = list()
		var/list/module_refs = list()

		for(var/datum/component/rig_piece/piece as anything in piece_components)
			var/reference = RIG_UI_ENCODE_PIECE_REF(ref(piece))
			assembled_fragments[reference] = piece.tgui_piece_data()
			piece_refs += reference

		//! yes, in null. fuck you.
		for(var/obj/item/rig_module/module as anything in null)
			var/reference = RIG_UI_ENCODE_MODULE_REF(ref(module))
			// todo: for when modules are made
			assembled_fragments[reference] = list()
			module_refs += reference

		// control flags skipped as it's per-person, and is updated later.
		push_ui_data(data = list(
			"pieceRefs" = piece_refs,
			"moduleRefs" = module_refs,
		))
		push_ui_modules(updates = assembled_fragments)
		return

	if(ui_queued_general)
		ui_queued_general = FALSE

	if(ui_queued_reflists)
		ui_queued_reflists = FALSE
		var/list/piece_refs = list()
		var/list/module_refs = list()
		for(var/datum/component/rig_piece/piece as anything in piece_components)
			var/reference = RIG_UI_ENCODE_PIECE_REF(ref(piece))
			piece_refs += reference
		//! yes, in null. fuck you.
		for(var/obj/item/rig_module/module as anything in null)
			var/reference = RIG_UI_ENCODE_MODULE_REF(ref(module))
			// todo: for when modules are made
			module_refs += reference
		push_ui_data(data = list(
			"pieceRefs" = piece_refs,
			"moduleRefs" = module_refs,
		))

	if(length(ui_queued_modules))
		var/list/assembled_fragments = list()

		//! yes, in null. fuck you.
		for(var/obj/item/rig_module/module as anything in ui_queued_modules)
			var/reference = RIG_UI_ENCODE_MODULE_REF(ref(module))
			// todo: for when modules are made
			assembled_fragments[reference] = list()

		push_ui_modules(updates = assembled_fragments)
		ui_queued_modules = null

	if(length(ui_queued_pieces))
		var/list/assembled_fragments = list()

		for(var/datum/component/rig_piece/piece as anything in piece_components)
			var/reference = RIG_UI_ENCODE_PIECE_REF(ref(piece))
			assembled_fragments[reference] = piece.tgui_piece_data()

		push_ui_modules(updates = assembled_fragments)
		ui_queued_pieces = null


#warn impl all

/obj/item/rig/ui_static_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	var/list/piece_refs = list()
	var/list/module_refs = list()
	for(var/datum/component/rig_piece/piece as anything in piece_components)
		var/reference = RIG_UI_ENCODE_PIECE_REF(ref(piece))
		piece_refs += reference
	//! yes, in null. fuck you.
	for(var/obj/item/rig_module/module as anything in null)
		var/reference = RIG_UI_ENCODE_MODULE_REF(ref(module))
		// todo: for when modules are made
		module_refs += reference
	.["pieceRefs"] = piece_refs
	.["moduleRefs"] = module_refs

/obj/item/rig/ui_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	// todo: maybe cache this
	.["controlFlags"] = effective_control_flags(user)

/obj/item/rig/ui_module_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	// todo: some pieces/modules data might need updating every tick?

/obj/item/rig/ui_module_static(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	for(var/obj/item/rig_module/module as anything in null)
		// todo: modules
		.[RIG_UI_ENCODE_MODULE_REF(ref(module))] = list()
	for(var/datum/component/rig_piece/piece as anything in piece_components)
		.[RIG_UI_ENCODE_PIECE_REF(ref(piece()))] = piece.tgui_piece_data()

/obj/item/rig/ui_module_act(action, list/params, datum/tgui/ui, id)
	. = ..()
	if(.)
		return
	// P / M switch
	// todo: need fast lookup for module control
	switch(id[1])
		if("P")
			#warn piece control (?)
			return TRUE
		if("M")
			// todo: route to modules
			return TRUE

/obj/item/rig/ui_act(action, list/params, datum/tgui/ui)
	. = ..()

/obj/item/rig/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(isnull(ui))
		ui = new(user, src, "Rigsuit")
		ui.open()

/obj/item/rig/ui_state(mob/user, datum/tgui_module/module)
	// give always state because we manually override all of this in ui_status
	return GLOB.always_state

/obj/item/rig/ui_status(mob/user, datum/ui_state/state, datum/tgui_module/module)
	// "guys, I swear I have a reason to reimplement all of this"
	// rigs use a very complicated status system so things like AI control can be done
	// it'd be a better idea to use state datums but i don't care

	// if they're admin abusing, give full control
	if(is_admin_interactive(user, src))
		return UI_INTERACTIVE

	// check if they should be able to view
	var/can_observe = isobserver(user) && user.client?.roughly_within_render_distance(src)

	#warn impl - default state behaviors
	#warn this is just a testing shim
	return UI_INTERACTIVE

/*
	var/src_object = ui_host(user)
	. = UI_CLOSE
	if(!state)
		return

	if(isobserver(user))
		// If they turn on ghost AI control, admins can always interact.
		if(IsAdminGhost(user))
			. = max(., UI_INTERACTIVE)

		// Regular ghosts can always at least view if in range.
		if(user.client)
			// todo: in view range for zooming
			if(get_dist(src_object, user) < max(CEILING(user.client.current_viewport_width / 2, 1), CEILING(user.client.current_viewport_height / 2, 1)))
				. = max(., UI_UPDATE)

	// Check if the state allows interaction
	var/result = state.can_use_topic(src_object, user)
	. = max(., result)
*/
