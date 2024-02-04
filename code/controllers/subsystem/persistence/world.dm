//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/controller/subsystem/persistence/proc/load_the_world()
	if(loaded_persistent_world)
		CRASH("cannot load world twice or bad shit happens")
	loaded_persistent_world = TRUE

	// handle bulk entities
	for(var/datum/bulk_entity_persistence/bulk_serializer as anything in subtypesof(/datum/bulk_entity_persistence))
		if(initial(bulk_serializer.abstract_type) == bulk_serializer)
			continue
		bulk_serializer = new bulk_serializer

	// handle objects

	#warn impl

/datum/controller/subsystem/persistence/proc/save_the_world()
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

/**
 * separate from world for performance; gathering entities is often slower if done one by one.
 */
/datum/controller/subsystem/persistence/proc/load_specific_level(z)

/**
 * separate from world for performance; gathering entities is often slower if done one by one.
 */
/datum/controller/subsystem/persistence/proc/save_specific_level(z)
