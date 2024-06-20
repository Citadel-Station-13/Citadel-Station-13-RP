//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * Procs here are namespaced on SSmap_sectors
 */

/datum/controller/subsystem/map_sectors/proc/rangefinding_coordinates_to_real(x, y, z)

/datum/controller/subsystem/map_sectors/proc/signal_flare_query(z, requires_active = TRUE, requires_on_ground = TRUE)

/datum/controller/subsystem/map_sectors/proc/laser_designation_query(z, requires_visible = TRUE, is_weapon = FALSE)

/**
 * default query:
 *
 * * all signal flares that are active and are on ground
 * * all laser designations that are currently visible
 *
 * @return list(signal flares, laser designations)
 */
/datum/controller/subsystem/map_sectors/proc/air_support_query(z, is_weapon = FALSE)
	return list(
		signal_flare_query(z),
		laser_designation_query(z, is_weapon = is_weapon),
	)

#warn use rangefinding_offset_(x/y) on /datum/map_level



#warn impl
