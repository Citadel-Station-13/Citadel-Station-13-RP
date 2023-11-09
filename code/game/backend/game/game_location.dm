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

/datum/game_location/specific_turf
	/// target turf
	var/turf/target

/datum/game_location/specific_turf/bind_to(to_where)
	. = FALSE
	ASSERT(isturf(to_where))
	target = to_where
	return TRUE

/datum/game_location/specific_turf/entity_is_inside(datum/game_entity/entity)
	. = entity.special_in_location(src)
	if(!isnull(.))
		return
	var/atom/movable/potential = entity.resolve()
	return istype(potential) && (potential in target)

/datum/game_location/entity
	abstract_type = /datum/game_location/entity
	/// target atom/movable
	var/atom/movable/target

/datum/game_location/entity/proc/bind_to(to_where)
	if(!isnull(target))
		UnreigsterSignal(target, COMSIG_PARENT_QDELETING)
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

/datum/game_location/entity/overmap_entity

	#warn impl

/datum/game_location/entity/movable_entity

/datum/game_location/entity/movable_entity/entity_is_inside(datum/game_entity/entity)
	. = entity.special_in_location(src)
	if(!isnull(.))
		return
	var/atom/movable/potential = entity.resolve()
	return istype(potential) && (potential in target)
