//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * GAME PROC: level_virtualization_check(z)
 * Checks if we should use GetVirtualCoords or similar for things like GPSes, radios
 *
 * Returns TRUE if:
 * z is in a world_struct
 */
/datum/controller/subsystem/mapping/proc/level_virtualization_check(z)
	// todo: world structs
	return FALSE
	// return !isnull(struct_by_z[z])
