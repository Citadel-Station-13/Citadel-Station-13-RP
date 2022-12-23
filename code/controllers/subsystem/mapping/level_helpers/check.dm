/**
 * GAME PROC: is_level_virtualized(z)
 * Checks if we should use GetVirtualCoords or similar for things like GPSes, radios
 *
 * Returns TRUE if:
 * z is in a world_struct
 */
/datum/controller/subsystem/mapping/proc/is_level_virtualized(z)
	return !!struct_by_z[z]
