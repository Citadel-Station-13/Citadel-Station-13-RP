

/atom/var/pressure_resistance = ONE_ATMOSPHERE

//Convenience function for atoms to update turfs they occupy
/atom/movable/proc/update_nearby_tiles(need_rebuild)
	if(!air_master)
		return 0

	for(var/turf/simulated/turf in locs)
		air_master.mark_for_update(turf)

	return 1

//Basically another way of calling CanPass(null, other, 0, 0) and CanPass(null, other, 1.5, 1).
//Returns:
// 0 - Not blocked
// AIR_BLOCKED - Blocked
// ZONE_BLOCKED - Not blocked, but zone boundaries will not cross.
// BLOCKED - Blocked, zone boundaries will not cross even if opened.
atom/proc/c_airblock(turf/other)
	#ifdef ZASDBG
	ASSERT(isturf(other))
	#endif
	return (AIR_BLOCKED*!CanPass(null, other, 0, 0))|(ZONE_BLOCKED*!CanPass(null, other, 1.5, 1))


turf/c_airblock(turf/other)
	#ifdef ZASDBG
	ASSERT(isturf(other))
	#endif
	if(((blocks_air & AIR_BLOCKED) || (other.blocks_air & AIR_BLOCKED)))
		return BLOCKED

	//Z-level handling code. Always block if there isn't an open space.
	#ifdef MULTIZAS
	if(other.z != src.z)
		if(other.z < src.z)
			if(!istype(src, /turf/simulated/open)) return BLOCKED
		else
			if(!istype(other, /turf/simulated/open)) return BLOCKED
	#endif

	if(((blocks_air & ZONE_BLOCKED) || (other.blocks_air & ZONE_BLOCKED)))
		if(z == other.z)
			return ZONE_BLOCKED
		else
			return AIR_BLOCKED

	var/result = 0
	for(var/mm in contents)
		var/atom/movable/M = mm
		result |= M.c_airblock(other)
		if(result == BLOCKED) return BLOCKED
	return result
