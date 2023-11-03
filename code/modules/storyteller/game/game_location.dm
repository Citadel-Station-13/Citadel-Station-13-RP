//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * location descriptor
 *
 * instantiate with bind_to set to a given thing.
 */
/datum/game_location
	abstract_type = /datum/game_location

/datum/game_location/New(bind_to)
	bind_to(bind_to)

/datum/game_location/proc/bind_to(to_where)
	CRASH("abstract proc unimplemented")

/**
 * emit details of where we actually point to
 */
/datum/game_location/proc/explain()
	CRASH("abstract proc unimplemented")

/**
 * is an entity inside us?
 */
/datum/game_location/proc/entity_is_inside(datum/game_entity/entity)
	CRASH("abstract proc unimplemented")

/**
 * get best-estimate distance from entity in tiles.
 *
 * decimals are allowed as we also support overmaps!
 */
/datum/game_location/proc/how_far_is_entity(datum/game_entity/entity)
	CRASH("abstract proc unimplemented")

#warn need range ops for placement and whatnot

/datum/game_location/specific_turf
	/// target turf
	var/turf/target

/datum/game_location/specific_turf/bind_to(to_where)
	. = FALSE
	ASSERT(isturf(to_where))
	target = to_where
	return TRUE

/datum/game_location/overmap_entity
	#warn impl

/datum/game_location/movable_entity
	#warn impl
