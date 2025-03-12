//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * A system used to spawn procedural entities.
 */
/datum/procedural_entity_descriptor

/**
 * @params
 * * location - where to spawn the entity
 * * seed_unimplemented - just a reserved arg.
 *
 * @return spawned entity
 */
/datum/procedural_entity_descriptor/proc/instantiate_single(atom/location, seed_unimplemented) as /atom/movable
	RETURN_TYPE(/atom/movable)
	CRASH("unimplemented instantiation called")
