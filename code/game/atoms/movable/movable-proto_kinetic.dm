//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

// TODO: heavily reconsider what we're going to do with protokinetic  system;
//       does it really need to be here, or is a component that tracks marks
//       and accessed through GetComponent better?

/**
 * This file just has proto-kinetic weapon wrappers.
 * .. so a single wrapper.
 *
 * It's here in movable folder because it's a movable-wide API.
 */

/**
 * Tries to detonate any effects reactive to proto-kinetic weapons on ourselves.
 *
 * * `detonation_data`: see [COMSIG_MOVABLE_COMSIG_PROTO_KINETIC_SCAN]
 *
 * @return null or list(stacks)
 */
/atom/movable/proc/scan_proto_kinetic_detonation()
	var/list/detonation_data = PROTO_KINETIC_DETONATION_DATA_CREATE
	if(!(SEND_SIGNAL(src, COMSIG_MOVABLE_PROTO_KINETIC_SCAN, detonation_data) & RAISE_PROTO_KINETIC_SCAN_HANDLED))
		return null
	return detonation_data

/**
 * Called when we should detonate.
 *
 * * `detonation_data`: see [COMSIG_MOVABLE_COMSIG_PROTO_KINETIC_SCAN]
 *
 * Called when detonating.
 */
/atom/movable/proc/perform_proto_kinetic_detonation(list/detonation_data)
	SEND_SIGNAL(src, COMSIG_MOVABLE_PROTO_KINETIC_DETONATION, detonation_data)
