//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * Shuttle controller
 *
 * Acts like a TGUI module.
 */
/datum/shuttle_controller
	//* Intrinsics
	/// our host shuttle
	var/datum/shuttle/shuttle

	//* Blocking
	/// registration list for 'hostile environment' system, aka 'shuttle cannot launch right now'
	///
	/// * keys are datums
	/// * values are reasons
	/// * unlike shuttle hooks, these are always hard blockers that cannot be overridden.
	/// * therefore it's safe to use this for backend purposes like when a zone is regenerating for beltmining.
	///
	/// todo: some kind of /datum/tgui_descriptive_text or something idfk for better error messages
	var/list/blocked_from_moving
	#warn hook

	//* Docking
	/// stored docking codes
	var/list/docking_codes
	/// current manual landing dock
	var/obj/shuttle_dock/manual_dock
	/// /datum/shuttle_docker instances by user
	/// user is real user of a tgui interface / the client viewing it,
	/// *not* the actor-performer tuple.
	/// that's encoded on the shuttle_docker.
	var/list/datum/shuttle_docker/docker_by_user

	//* UI
	/// tgui interface to load
	var/tgui_module

/datum/shuttle_controller/proc/initialize(datum/shuttle/shuttle)
	src.shuttle = shuttle
	return TRUE

//* Blocking API *//

/datum/shuttle_controller/proc/register_movement_block(datum/source, reason)
	LAZYSET(blocked_from_moving, source, reason)

/datum/shuttle_controller/proc/unregister_movement_block(datum/source)
	LAZYREMOVE(blocked_from_moving, source)

//* Docking API - use this API always, do not manually control the shuttle. *//

/**
 * @params
 * * dock - dock to move to
 * * force - hard force, ram everything out of the way on the destination side if needed
 * * immediate - blow past all docking procedures, do not block on anything IC fluff or otherwise
 *
 * @return TRUE / FALSE on success / failure
 */
/datum/shuttle_controller/proc/move_to_dock(obj/shuttle_dock/dock, force = FALSE, immediate = FALSE)
	#warn impl

/datum/shuttle_controller/proc/has_codes_for(obj/shuttle_dock/dock)
	#warn impl

/**
 * call to designate a manual landing position
 *
 * this is unchecked / has no safety checks.
 *
 * @return FALSE on failure
 */
/datum/shuttle_controller/proc/set_manual_landing(turf/lowerleft, orientation)
	if(!isnull(manual_dock))
		QDEL_NULL(manual_dock)
	#warn impl

//* Interface *//

/datum/shuttle_controller/proc/tgui_data()
	return list()

/datum/shuttle_controller/proc/tgui_static_data()
	return list(
		"$src" = REF(src),
		"$tgui" = tgui_module,
	)

/datum/shuttle_controller/proc/tgui_act(action, list/params, authorization)
	#warn impl

/datum/shuttle_controller/proc/tgui_push(list/data)
	// this is just a wrapper so we can change it later if need be
	return push_ui_data(data = data)

/datum/shuttle_controller/proc/push_ui_location()
	return
