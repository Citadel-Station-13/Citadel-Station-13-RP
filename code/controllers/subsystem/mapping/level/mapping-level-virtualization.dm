//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * GAME PROC: is_level_virtualized(z)
 * Checks if we should use GetVirtualCoords or similar for things like GPSes, radios
 *
 * Returns TRUE if:
 * z is in a world_struct
 */
/datum/controller/subsystem/mapping/proc/is_level_virtualized(z)
	// todo: world structs
	return FALSE
	// return !isnull(struct_by_z[z])
