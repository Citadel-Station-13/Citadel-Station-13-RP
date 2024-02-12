//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/controller/subsystem/persistence/proc/block_on_world_mutex(timeout = 10 SECONDS)
	var/expire_at = world.time + timeout
	UNTIL(!world_serialization_mutex || world.time > expire_at)
	if(world_serialization_mutex)
		. = FALSE
		CRASH("failed to obtain world mutex")
	return TRUE

/datum/controller/subsystem/persistence/proc/load_the_world()
	block_on_world_mutex()

	if(world_loaded)
		CRASH("cannot load world twice or bad shit happens")
	world_loaded = TRUE

	var/start_time

	// handle bulk entities
	for(var/datum/bulk_entity_persistence/bulk_serializer as anything in subtypesof(/datum/bulk_entity_persistence))
		if(initial(bulk_serializer.abstract_type) == bulk_serializer)
			continue
		bulk_serializer = new bulk_serializer

	// handle objects

	#warn impl

/datum/controller/subsystem/persistence/proc/save_the_world()
	block_on_world_mutex()

	++world_saved_count

	var/start_time
	#warn impl all

	var/list/datum/map_level_persistence/ordered_level_metadata = new /list(length(SSmapping.ordered_levels))

	// handle objects

	// handle bulk entities
	for(var/datum/bulk_entity_persistence/bulk_serializer as anything in subtypesof(/datum/bulk_entity_persistence))
		if(initial(bulk_serializer.abstract_type) == bulk_serializer)
			continue
		bulk_serializer = new bulk_serializer
		var/list/atom/movable/entities = bulk_serializer.gather_all()
		var/list/datum/bulk_entity_chunk/chunks = bulk_serializer.serialize_entities_into_chunks(entities)
		#warn impl

	// cleanup
	start_time = REALTIMEOFDAY
	clean_the_world()
	subsystem_log("world-save: clean took [round((end_time - start_time) * 0.1, 0.01)]s")

/**
 * called to clean out unused data from the database.
 */
/datum/controller/subsystem/persistence/proc/clean_the_world()
	if(!SSdbcore.Connect())
		return FALSE

	var/intentionally_allow_admin_proccall = usr
	usr = null

	var/list/metadata = new /list(world.maxz)
	#warn impl
	usr = intentionally_allow_admin_proccall

	#warn impl

	return TRUE

/**
 * separate from world for performance; gathering entities is often slower if done one by one.
 */
/datum/controller/subsystem/persistence/proc/load_specific_level(z)

/**
 * separate from world for performance; gathering entities is often slower if done one by one.
 */
/datum/controller/subsystem/persistence/proc/save_specific_level(z)
