/atom/var/pressure_resistance = ONE_ATMOSPHERE

//Convenience function for atoms to update turfs they occupy
/atom/movable/proc/update_nearby_tiles(need_rebuild)
	if(!air_master)
		return 0

	for(var/turf/simulated/turf in locs)
		air_master.mark_for_update(turf)

	return 1

