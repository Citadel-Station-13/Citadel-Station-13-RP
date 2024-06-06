//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * mild misnomer
 *
 * this is basically the idea of a 'structure' that is spawned
 *
 * it holds roles.
 *
 * pawns spawn this in, and then populate them with roles.
 */
/datum/storyteller_entity
	abstract_type = /datum/storyteller_entity

#warn AAAAAAAAAAAAAAAAAAAAAAAA

/**
 * checks if the map is suitable for instantiating this
 */
/datum/storyteller_entity/proc/check_prerequisites(datum/storyteller_state/state)

/**
 * checks if we can be spawned in a specific location
 */
/datum/storyteller_entity/proc/check_location(datum/storyteller_state/state, datum/storyteller_location/location)

/**
 * instances us in a specific location
 */
/datum/storyteller_entity/proc/instance(datum/storyteller_state/state, datum/storyteller_location/location)

#warn impl

/**
 * get role spawns left
 */
/datum/storyteller_entity/proc/role_spawns_left(role_tag)

/**
 * get spawn location for a role (turf)
 */
/datum/storyteller_entity/proc/role_spawn_location(role_tag)

/**
 * post spawn hook for role mob
 *
 * other spawns are passed in too
 */
/datum/storyteller_entity/proc/post_role_spawn(role_tag, mob/character, list/atom/movable/other_spawns)
