/datum/radiation_wave
	/// source turf
	var/turf/source
	/// turfs, associated to power
	var/list/turf
	/// dirs of spread
	var/list/dir

	/// current cycles
	var/cycles
	
	/// turfs next, associated to power
	var/list/turf_next
	/// dirs of spread next
	var/list/dir_next
	
/datum/radiation_wave/New(turf/source)
	src.source = source

/datum/radiation_wave/proc/start()
	cycles = 0
	turf = list(source, source, source, source)
	dir = list(NORTH, SOUTH, EAST, WEST)
	turf_next = list()
	dir_next = list()

/**
 * returns TRUE / FALSE based on if we're completed.
 */
/datum/radiation_wave/proc/iterate(ticklimit)
	var/i
	
	for(i in 1 to length(turf))
		#warn impl
		if(TICK_USAGE > ticklimit)	
			break
	
	turf.Cut(1, i + 1)
	dir.Cut(1, i + 1)
	return !length(turf)

/datum/radiation_wave/proc/next()
	turf = turf_next
	dir = dir_next
	turf_next = list()
	dir_next = list()


/datum/radiation_wave/contaminating
	/// remaining contamination
	var/contamination
