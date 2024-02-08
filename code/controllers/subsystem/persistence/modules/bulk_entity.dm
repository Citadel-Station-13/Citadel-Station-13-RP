//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * bulk entity storage module
 *
 * handles things like debris
 */
/datum/controller/subsystem/persistence

/datum/controller/subsystem/persistence/proc/bulk_entity_save_chunks(persistence_id, list/datum/bulk_entity_chunk/chunks)
	if(!SSdbcore.Connect())
		return FALSE

	var/intentionally_allow_admin_proccall = usr
	usr = null
	#warn impl
	usr = intentionally_allow_admin_proccall

	#warn impl

	return TRUE


/datum/controller/subsystem/persistence/proc/bulk_entity_load_chunks_on_level(persistence_id, level_id)
	if(!SSdbcore.Connect())
		return FALSE

	var/intentionally_allow_admin_proccall = usr
	usr = null
	#warn impl
	usr = intentionally_allow_admin_proccall

	#warn impl

	return TRUE


/**
 * somewhat expensive
 *
 * runtimes if anything isn't on a turf
 *
 * @return list(list(areapath, turfpath) = list(entities))
 */
/datum/controller/subsystem/persistence/proc/bulk_entity_group_by_area_and_turf(list/atom/movable/entities)
	var/list/hash = list()
	var/list/split = list()
	for(var/atom/movable/entity as anything in entities)
		var/turf_type = entity.loc.type
		var/area_type = entity.loc.loc.type
		if(isnull(hash[area_type]))
			hash[area_type] = list()
		if(isnull(hash[area_type][turf_type]))
			hash[area_type][turf_type] = list()
		hash[area_type][turf_type] += entity
	for(var/area_type in hash)
		var/list/turf_types = hash[area_type]
		for(var/turf_type in turf_types)
			split[list(area_type, turf_type)] = turf_types[turf_type]
	return split

/**
 * runtimes if anything isn't on a turf.
 *
 * @return list(list(entities), ...) --> length = world.maxz
 */
/datum/controller/subsystem/persistence/proc/bulk_entity_group_by_zlevel(list/atom/movable/entities)
	var/list/split = new /list(world.maxz)
	for(var/i in 1 to world.maxz)
		split[i] = list()
	for(var/atom/movable/entity as anything in entities)
		split[entity.z] += entity
	return split

/**
 * @return list(list(entity, ...), ...)
 */
/datum/controller/subsystem/persistence/proc/bulk_entity_split_by_amount(list/atom/movable/entities, amount)
	if(length(entities) <= amount)
		return list(entities.Copy())
	var/index = 1
	var/list/split = list()
	for(index in 1 to length(entities) step amount)
		split[++split.len] = entities.Copy(index, min(index + amount, length(entities) + 1))
	return split

/datum/bulk_entity_persistence
	abstract_type = /datum/bulk_entity_persistence
	/// id - must be unique
	var/id
	/// if sql data doesn't match revision, it's tossed out
	var/revision = 1
	/// split entities returned from gather procs to this amount per chunk
	var/auto_entity_chunk_split = 500

/datum/bulk_entity_persistence/proc/gather_all()
	return list()

/datum/bulk_entity_persistence/proc/gather_level(z)
	return list()

/**
 * perform global filtering on all entities
 *
 * input list can be modified
 *
 * this is for 'drop n entities through the whole world'; this is only called when the entire world is being
 * serialized, as opposed to a single level.
 *
 * @return filtered list
 */
/datum/bulk_entity_persistence/proc/perform_global_filter(list/atom/movable/entities)
	return entities

/**
 * perform level filtering
 */
/datum/bulk_entity_persistence/proc/perform_level_filter(list/atom/movable/entities, datum/map_level/level)

/**
 * serialize entities into chunks for a single level
 *
 * @return list(count saved, count dropped, count errored)
 */
/datum/bulk_entity_persistence/proc/serialize_entities_into_chunks(list/atom/movable/entities, datum/map_level/level)
	return list(0, 0, 0)

/**
 * @return list(count loaded, count dropped, count errored)
 */
/datum/bulk_entity_persistence/proc/load_chunks(list/datum/bulk_entity_chunk/chunks)
	return list(0, 0, 0)

/datum/bulk_entity_chunk
	//* Set by serialize_entities_into_chunks *//
	var/level_id
	var/amount
	var/list/data

	//* Set by serialization and deserialization, do not manually set. *//
	/// our generation
	/// * set by load from DB
	/// * set on save by save proc before being sent into bulk_entity_save_chunks()
	var/generation

	//* Set by loader, do not manually set. *//
	/// round id we were saved on
	var/round_id_saved
	/// rounds since we were saved
	var/rounds_since_saved
	/// hours since we were saved
	var/hours_since_saved
