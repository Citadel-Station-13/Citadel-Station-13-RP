//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * bulk entity storage module
 *
 * handles things like debris
 */
/datum/controller/subsystem/persistence

#warn impl all

/**
 * @return list(list(areapath, turfpath) = list(entities))
 */
/datum/controller/subsystem/persistence/proc/bulk_entity_group_by_area_and_turf(list/atom/movable/entity)
	#warn impl

/**
 * @return list(list(entity, ...), ...)
 */
/datum/controller/subsystem/persistence/proc/bulk_entity_split_by_amount(list/atom/movable/entity, amount)
	#warn impl

/datum/bulk_entity_persistence

/datum/bulk_entity_persistence/proc/gather_all()

/datum/bulk_entity_persistence/proc/gather_level(z)

/datum/bulk_entity_persistence/proc/serialize_entities_into_chunks(list/atom/movable/entity)

/datum/bulk_entity_persistence/proc/load_chunk(datum/bulk_entity_chunk/chunks)

/datum/bulk_entity_chunk
	var/level_id
	var/amount
	var/list/data

