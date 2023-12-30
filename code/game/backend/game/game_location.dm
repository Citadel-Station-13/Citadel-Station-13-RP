//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * location descriptor
 *
 * instantiate with bind_to set to a given thing.
 *
 * unlike /datum/game_entity, this is not so abstract, as 'location'
 * here refers to a byond-allowed location or a descriptor to such.
 */
/datum/game_location
	abstract_type = /datum/game_location

/datum/game_location/New(bind_to)
	if(isnull(bind_to))
		return
	bind_to(bind_to)

/datum/game_location/proc/bind_to(to_where)
	CRASH("abstract proc unimplemented")

/**
 * emit details of where we actually point to
 *
 * @params
 * * detailed - exact trace, as opposed to just a location; this will let them home in.
 */
/datum/game_location/proc/explain(detailed)
	CRASH("abstract proc unimplemented")

/**
 * is an entity inside us?
 */
/datum/game_location/proc/entity_is_inside(datum/game_entity/entity)
	CRASH("abstract proc unimplemented")

/**
 * how far an entity is from us
 *
 * @return distance in tiles, null for invalid, INFINITY for "too much to care"
 */
/datum/game_location/proc/entity_distance(datum/game_entity/entity)
	CRASH("abstract proc unimplemented")

/**
 * basic comsig-qdeletion hooked tracker for locations that are represented by a movable object.
 */
/datum/game_location/entity
	abstract_type = /datum/game_location/entity
	/// target atom/movable
	var/atom/movable/target

/datum/game_location/entity/proc/bind_to(to_where)
	if(!isnull(target))
		UnregisterSignal(target, COMSIG_PARENT_QDELETING)
	if(!ismovable(to_where))
		. = FALSE
		CRASH("um")
	target = to_where
	RegisterSignal(target, COMSIG_PARENT_QDELETING, PROC_REF(on_target_deleted))
	return TRUE

/datum/game_location/entity/proc/on_target_deleted(datum/parent)
	if(parent != target)
		return
	target = null
