//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/component/client_face_cursor
	var/list/sources = list()
	var/last_update

/datum/component/client_face_cursor/RegisterWithParent()
	..()
	RegisterSignal(parent, COMSIG_CLIENT_MOUSE_MOVED, PROC_REF(on_mouse_moved))
	on_mouse_moved(parent)

/datum/component/client_face_cursor/UnregisterFromParent()
	..()
	UnregisterSignal(parent, COMSIG_CLIENT_MOUSE_MOVED)

/datum/component/client_face_cursor/proc/on_mouse_moved(client/source)
	SIGNAL_HANDLER
	if(world.time - last_update < GLOB.client_mouse_fast_update_backoff)
		return
	last_update = world.time
	// TODO: better dir prediction
	var/dir_to_turn = get_dir(source.mob, source.mouse_predicted_last_atom)
	// TODO: use self-turn
	#warn turn

/datum/component/client_face_cursor/proc/add_source(source)
	sources |= source

/datum/component/client_face_cursor/proc/remove_source(source)
	sources -= source
	if(!length(sources))
		addtimer(CALLBACK(src, PROC_REF(qdel_self_if_empty)), 0)

/datum/component/client_face_cursor/proc/qdel_self_if_empty()
	if(!length(sources))
		qdel(src)

/client/proc/start_facing_cursor(source)
	var/datum/component/client_face_cursor/comp = LoadComponent(/datum/component/client_face_cursor)
	comp.add_source(source)

/client/proc/stop_facing_cursor(source)
	var/datum/component/client_face_cursor/comp = GetComponent(/datum/component/client_face_cursor)
	if(!comp)
		return
	comp.remove_source(source)
