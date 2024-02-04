//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * objects module
 *
 * handles static and dynamic object persistence on given map levels
 */
/datum/controller/subsystem/persistence

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

#warn impl all


