//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

//* WELCOME TO THE SEVENTH CIRCLE OF WEBDEV HELL
/// For efficiency, rigs will internally track and cache what needs to update.
/// We heavily abuse the TGUI modules system to selectively update data
/// with the module system's 2-deep reducer.

/obj/item/rig/proc/ui_queue()
	ui_queued_general = TRUE
	if(isnull(ui_queued_timer))
		ui_queued_timer = addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/item/rig, ui_flush), 0, TIMER_STOPPABLE))

/obj/item/rig/proc/ui_queue_piece(datum/component/rig_piece/piece)
	LAZYDISTINCTADD(ui_queued_pieces, piece)
	if(isnull(ui_queued_timer))
		ui_queued_timer = addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/item/rig, ui_flush), 0, TIMER_STOPPABLE))

/obj/item/rig/proc/ui_queue_module(obj/item/rig_module/module)
	LAZYDISTINCTADD(ui_queued_modules, module)
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

		for(var/id in piece_lookup)
			var/datum/component/rig_piece/piece = piece_lookup[id]
			var/reference = RIG_UI_ENCODE_PIECE_REF(ref(piece))
			assembled_fragments[reference] = piece.tgui_piece_data()
			piece_refs += reference
			piece.ui_update_queued = FALSE

		for(var/id in module_lookup)
			var/obj/item/rig_module/module = module_lookup[id]
			var/reference = RIG_UI_ENCODE_MODULE_REF(ref(module))
			// todo: for when modules are made
			#warn module data + how to handle data vs static?
			assembled_fragments[reference] = list()
			module_refs += reference
			module.ui_update_queued = FALSE

		// control flags skipped as it's per-person, and is updated later.
		push_ui_data(data = list(
			"pieceRefs" = piece_refs,
			"moduleRefs" = module_refs,
			"theme" = theme_name,
		))
		push_ui_modules(updates = assembled_fragments)
		return

	if(ui_queued_general)
		ui_queued_general = FALSE

	if(ui_queued_reflists)
		ui_queued_reflists = FALSE
		var/list/piece_refs = list()
		var/list/module_refs = list()
		for(var/id in piece_lookup)
			var/datum/component/rig_piece/piece = piece_lookup[id]
			var/reference = RIG_UI_ENCODE_PIECE_REF(ref(piece))
			piece_refs += reference
		for(var/id in module_lookup)
			var/obj/item/rig_module/module = module_lookup[id]
			var/reference = RIG_UI_ENCODE_MODULE_REF(ref(module))
			module_refs += reference
		push_ui_data(data = list(
			"pieceRefs" = piece_refs,
			"moduleRefs" = module_refs,
		))

	if(length(ui_queued_modules))
		var/list/assembled_fragments = list()

		for(var/obj/item/rig_module/module as anything in ui_queued_modules)
			var/reference = RIG_UI_ENCODE_MODULE_REF(ref(module))
			// todo: for when modules are made
			assembled_fragments[reference] = list()
			module.ui_update_queued = FALSE

		push_ui_modules(updates = assembled_fragments)
		ui_queued_modules = null

	if(length(ui_queued_pieces))
		var/list/assembled_fragments = list()

		for(var/datum/component/rig_piece/piece as anything in ui_queued_pieces)
			var/reference = RIG_UI_ENCODE_PIECE_REF(ref(piece))
			assembled_fragments[reference] = piece.tgui_piece_data()
			piece.ui_update_queued = FALSE

		push_ui_modules(updates = assembled_fragments)
		ui_queued_pieces = null

#warn impl all

/obj/item/rig/ui_static_data(mob/user, datum/tgui/ui, is_module)
	#warn icecream update will modify this, check the root definition!
	. = ..()
	.["theme"] = theme_name
	.["windowTheme"] = ui_theme || detect_ui_theme()
	.["activation"] = activation_state
	.["sprite64"] = isnull(cached_tgui_icon_b64)? (cached_tgui_icon_b64 = icon2base64(icon(icon, state_sealed, SOUTH, 1, FALSE))) : cached_tgui_icon_b64
	var/list/piece_refs = list()
	var/list/module_refs = list()
	for(var/id in piece_lookup)
		var/datum/component/rig_piece/piece = piece_lookup[id]
		var/reference = RIG_UI_ENCODE_PIECE_REF(ref(piece))
		piece_refs += reference
	for(var/id in module_lookup)
		var/obj/item/rig_module/module = module_lookup[id]
		var/reference = RIG_UI_ENCODE_MODULE_REF(ref(module))
		// todo: for when modules are made
		module_refs += reference
	.["pieceRefs"] = piece_refs
	.["moduleRefs"] = module_refs
	.["wornCorrectly"] = is_in_right_slot()

/obj/item/rig/ui_data(mob/user, datum/tgui/ui)
	. = ..()
	// todo: maybe cache this
	.["controlFlags"] = effective_control_flags(user)

/obj/item/rig/ui_static_modules(mob/user, datum/tgui/ui)
	. = ..()
	for(var/obj/item/rig_module/module as anything in null)
		// todo: modules
		.[RIG_UI_ENCODE_MODULE_REF(ref(module))] = list()
	for(var/id in piece_lookup)
		var/datum/component/rig_piece/piece = piece_lookup[id]
		.[RIG_UI_ENCODE_PIECE_REF(ref(piece))] = piece.tgui_piece_data()

/obj/item/rig/ui_route(action, list/params, datum/tgui/ui, id)
	. = ..()
	if(.)
		return
	// P / M switch
	// todo: need fast lookup for module control
	switch(id[1])
		if("P")
			var/lookup_id = params["id"]
			#warn piece control (?)
			return TRUE
		if("M")
			var/lookup_id = params["id"]
			// todo: route to modules
			return TRUE
	#warn impl :/

/obj/item/rig/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	var/mob/user = usr
	switch(action)
		if("activation")
			var/desired = text2num(params["on"])
			// todo: better reject
			if(!check_control_flags_or_reject(user, RIG_CONTROL_ACTIVATION))
				return TRUE
			if(isnull(desired))
				return TRUE
			if(desired)
				if(activation_state == RIG_ACTIVATION_ACTIVATING || activation_state == RIG_ACTIVATION_ONLINE)
					return TRUE
				INVOKE_ASYNC(src, PROC_REF(activation_sequence))
			else
				if(activation_state == RIG_ACTIVATION_DEACTIVATING || activation_state == RIG_ACTIVATION_OFFLINE)
					return TRUE
				INVOKE_ASYNC(src, PROC_REF(deactivation_sequence))
			return TRUE
		if("seal")
			if(activation_state != RIG_ACTIVATION_ONLINE)
				return TRUE
			var/piece = params["piece"]
			var/desired = text2num(params["on"])
			// todo: better reject
			if(!check_control_flags_or_reject(user, RIG_CONTROL_PIECES))
				return TRUE
			if(isnull(desired))
				return TRUE
			if(isnull(piece))
				return TRUE
			var/datum/component/rig_piece/piece_instance = piece_lookup[piece]
			if(isnull(piece_instance))
				return TRUE
			if(desired)
				if(piece_instance.sealed == RIG_PIECE_SEALING || piece_instance.sealed == RIG_PIECE_SEALED)
					return TRUE
				INVOKE_ASYNC(src, PROC_REF(seal_piece_sync), piece_instance)
			else
				if(piece_instance.sealed == RIG_PIECE_UNSEALING || piece_instance.sealed == RIG_PIECE_UNSEALED)
					return TRUE
				INVOKE_ASYNC(src, PROC_REF(unseal_piece_sync), piece_instance)
			return TRUE
		if("deploy")
			var/piece = params["piece"]
			var/desired = text2num(params["on"])
			// todo: better reject
			if(!check_control_flags_or_reject(user, RIG_CONTROL_PIECES))
				return TRUE
			if(isnull(desired))
				return TRUE
			if(isnull(piece))
				if(desired)
					deploy_suit_async(TRUE)
				else
					undeploy_suit_async()
				return TRUE
			else
				var/datum/component/rig_piece/piece_instance = piece_lookup[piece]
				if(isnull(piece))
					return TRUE
				if(desired)
					if(piece_instance.is_deployed())
						return TRUE
					deploy_piece_async(piece_instance, TRUE)
				else
					if(!piece_instance.is_deployed())
						return TRUE
					INVOKE_ASYNC(src, PROC_REF(undeploy_piece_sync), piece_instance)
				return TRUE
		#warn impl all

/obj/item/rig/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(isnull(ui))
		ui = new(user, src, "RigsuitController")
		ui.open()

/obj/item/rig/ui_state()
	// give always state because we manually override all of this in ui_status
	#warn shitcode lol
	return GLOB.always_state

/obj/item/rig/ui_status(mob/user, datum/ui_state/state)
	#warn shitcode lol
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

/**
 * attempts to detect theme from wearer, if ui theme is not being forced
 */
/obj/item/rig/proc/detect_ui_theme()
	var/mob/living/carbon/human/casted = wearer
	if(!istype(casted))
		return
	if(!isnull(casted.nif))
		// 1: attempt to detect from nif
		var/detected = casted.nif.save_data["ui_theme"]
		if(detected in global.all_tgui_themes)
			return detected
	// failed
