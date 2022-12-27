/proc/vortex_burst

/**
 * the funny dance burst
 */
/datum/vortex_burst
	//! Intrinsics
	/// center
	var/turf/center
	/// dist between tiles
	var/ring_offset = 1
	/// speed between instantiations
	var/speed = 2
	/// current dist
	var/dist_current
	/// max dist
	var/dist_target = 3
	/// ticking
	var/active = FALSE

	//! Tile Blasts
	#warn instance vars

/datum/vortex_burst/Destroy()
	if(active)
		end()
	center = null
	return ..()

/datum/vortex_burst(turf/center, _trg, _spd, _ost)
	src.center = center
	if(_trg)
		src.dist_target = _trg
	if(_spd)
		src.speed = _spd
	src.dist_current = 0
	if(_ost)
		src.ring_offset = _ost
	start()

/datum/vortex_burst/proc/start()
	active = TRUE

/datum/vortex_burst/proc/end()
	active = FALSE
	if(!QDESTROYING(src))
		qdel(src)

#warn impl ticking

/datum/vortex_burst/proc/tick()
	var/computed = dist_current * ring_offset
	for(var/turf/T as anything in RING_TURF_FROM_CENTER(computed, center))
		blast(T)

/datum/vortex_burst/proc/blast(turf/T)
