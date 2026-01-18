//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

SUBSYSTEM_DEF(map_sectors)
	name = "Map Sectors"
	subsystem_flags = SS_NO_INIT | SS_NO_FIRE

// todo: eventual SSplanets replacement

/datum/controller/subsystem/map_sectors/proc/high_altitude_signal_query(z)
	. = list()
	for(var/datum/component/high_altitude_signal/signal as anything in GLOB.high_altitude_signals[z])
		if(!signal.is_active())
			continue
		. += signal

/datum/controller/subsystem/map_sectors/proc/is_turf_visible_from_high_altitude(turf/origin)
	if(origin.sector_always_visible_from_high_altitude())
		return TRUE
	var/list/z_stack = SSmapping.level_get_stack(origin.z)
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
