//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Procs here are namespaced on SSmap_sectors
 */

/**
 * @return list(x, y, z)
 */
/datum/controller/subsystem/map_sectors/proc/rangefinding_coordinates_to_real(x, y, z)
	return list(x, y, z)

/datum/controller/subsystem/map_sectors/proc/signal_flare_query(z, requires_active = TRUE, requires_on_ground = TRUE)
	. = list()
	for(var/obj/item/signal_flare/flare as anything in SSspatial_grids.signal_flares.all_atoms(z))
		if(requires_active && !flare.ready)
			continue
		if(requires_on_ground && !isturf(flare.loc))
			continue
		. += flare

/datum/controller/subsystem/map_sectors/proc/laser_designation_query(z, check_los = TRUE, for_weapons = FALSE)
	. = list()
	for(var/atom/movable/laser_designator_target/target as anything in SSspatial_grids.laser_designations.all_atoms(z))
		if(check_los)
			#warn check los
		if(for_weapons && !target.allow_weapons_guidance)
			continue
		. += target

/**
 * default query:
 *
 * * all signal flares that are active and are on ground
 * * all laser designations that are currently visible
 *
 * @return list(signal flares, laser designations)
 */
/datum/controller/subsystem/map_sectors/proc/air_support_query(z, for_weapons = FALSE)
	return list(
		signal_flare_query(z),
		laser_designation_query(z, for_weapons = for_weapons),
	)

/datum/controller/subsystem/map_sectors/proc/is_turf_visible_from_high_altitude(turf/origin)
	if(origin.sector_always_visible_from_high_altitude())
		return TRUE
	var/list/z_stack = SSmapping.get_z_stack(origin.z)
	var/something_is_granting_los
	var/not_first
	for(var/z in z_stack)
		var/turf/in_stack = locate(origin.x, origin.y, z)
		if(in_stack.outdoors || in_stack.sector_always_visible_from_high_altitude())
			something_is_granting_los = TRUE
		if(not_first && in_stack.sector_block_high_altitude_observation_to_below())
			return FALSE
		not_first = TRUE

	return something_is_granting_los
