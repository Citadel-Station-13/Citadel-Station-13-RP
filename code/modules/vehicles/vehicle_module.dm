//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/item/vehicle_module
	/// currently active chassis
	var/obj/vehicle/vehicle

//* Chassis - Physicality *//

/**
 * Returns if our mount is sufficiently close to something to be considered adjacent.
 *
 * * This is usually our mech.
 * * If we are not mounted, this always fails.
 */
/obj/item/vehicle_module/proc/sufficiently_adjacent(atom/entity)
	return chassis?.sufficiently_adjacent(entity)

/**
 * Supertype of shieldcalls that handle vehicle hits. Just subtype one
 * and set the path on your component to use them.
 */
/datum/shieldcall/bound/vehicle_module
	expected_type = /obj/vehicle

/datum/armor/vehicle_module
