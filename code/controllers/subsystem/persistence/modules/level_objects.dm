//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * objects module
 *
 * handles static and dynamic object persistence on given map levels
 */
/datum/controller/subsystem/persistence

/datum/controller/subsystem/persistence/proc/level_objects_store_static(list/obj/entities, generation, level_id, map_id)
	if(!SSdbcore.Connect())
		return FALSE

	var/intentionally_allow_admin_proccall = usr
	usr = null
	#warn impl
	usr = intentionally_allow_admin_proccall

	#warn impl

	return TRUE

/datum/controller/subsystem/persistence/proc/level_objects_store_dynamic(list/obj/entities, generation, level_id)
	if(!SSdbcore.Connect())
		return FALSE

	var/intentionally_allow_admin_proccall = usr
	usr = null
	#warn impl
	usr = intentionally_allow_admin_proccall

	#warn impl

	return TRUE

/datum/controller/subsystem/persistence/proc/level_objects_load_dynamic(generation, level_id)
	if(!SSdbcore.Connect())
		return FALSE

	var/intentionally_allow_admin_proccall = usr
	usr = null
	#warn impl
	usr = intentionally_allow_admin_proccall

	#warn impl

	return TRUE

/datum/controller/subsystem/persistence/proc/level_objects_load_static(list/obj/entities, generation, level_id, map_id)
	if(!SSdbcore.Connect())
		return FALSE

	var/intentionally_allow_admin_proccall = usr
	usr = null
	#warn impl
	usr = intentionally_allow_admin_proccall

	#warn impl

	return TRUE

/datum/controller/subsystem/persistence/proc/level_objects_drop_old(generation)
	if(!SSdbcore.Connect())
		return FALSE

	var/intentionally_allow_admin_proccall = usr
	usr = null
	#warn impl
	usr = intentionally_allow_admin_proccall

	#warn impl

	return TRUE

/datum/controller/subsystem/persistence/proc/level_objects_drop_static_all()
	if(!SSdbcore.Connect())
		return FALSE

	var/intentionally_allow_admin_proccall = usr
	usr = null
	#warn impl
	usr = intentionally_allow_admin_proccall

	#warn impl

	return TRUE

/datum/controller/subsystem/persistence/proc/level_objects_drop_static_level(level_id)
	if(!SSdbcore.Connect())
		return FALSE

	var/intentionally_allow_admin_proccall = usr
	usr = null
	#warn impl
	usr = intentionally_allow_admin_proccall

	#warn impl

	return TRUE

/datum/controller/subsystem/persistence/proc/level_objects_drop_static_map(map_id)
	if(!SSdbcore.Connect())
		return FALSE

	var/intentionally_allow_admin_proccall = usr
	usr = null
	#warn impl
	usr = intentionally_allow_admin_proccall

	#warn impl

	return TRUE

/datum/controller/subsystem/persistence/proc/level_objects_drop_static_global()
	if(!SSdbcore.Connect())
		return FALSE

	var/intentionally_allow_admin_proccall = usr
	usr = null
	#warn impl
	usr = intentionally_allow_admin_proccall

	#warn impl

	return TRUE

/datum/controller/subsystem/persistence/proc/level_objects_drop_dynamic_all()
	if(!SSdbcore.Connect())
		return FALSE

	var/intentionally_allow_admin_proccall = usr
	usr = null
	#warn impl
	usr = intentionally_allow_admin_proccall

	#warn impl

	return TRUE

/datum/controller/subsystem/persistence/proc/level_objects_drop_dynamic_level(level_id)
	if(!SSdbcore.Connect())
		return FALSE

	var/intentionally_allow_admin_proccall = usr
	usr = null
	#warn impl
	usr = intentionally_allow_admin_proccall

	#warn impl

	return TRUE

/**
 * @return list(list(static objects), list(dynamic objects))
 */
/datum/controller/subsystem/persistence/proc/level_objects_gather_world()
	var/list/static_objects = list()
	var/list/dynamic_objects = list()

	for(var/obj/thing in world)
		// don't lock up the server
		CHECK_TICK
		// we only care about things on turfs
		if(!isturf(thing.loc))
			continue
		// are they static?
		if(thing.obj_persist_static_id)
			static_objects += thing
		// are they dynamic?
		else if(thing.obj_persist_dynamic_id)
			dynamic_objects += thing

	return list(static_objects, dynamic_objects)

/**
 * @return list(list(static objects), list(dynamic objects))
 */
/datum/controller/subsystem/persistence/proc/level_objects_gather_level(z)
	var/list/static_objects = list()
	var/list/dynamic_objects = list()

	for(var/obj/thing in world)
		// don't lock up the server
		CHECK_TICK
		// we only care about things on turfs
		// and since if you're not on a turf, z is 0, this works anyways lol
		if(thing.z != z)
			continue
		// are they static?
		if(thing.obj_persist_static_id)
			static_objects += thing
		// are they dynamic?
		else if(thing.obj_persist_dynamic_id)
			dynamic_objects += thing

	return list(static_objects, dynamic_objects)
