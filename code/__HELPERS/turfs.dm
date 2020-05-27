/proc/turf_clear(turf/T)
	for(var/atom/A in T)
		if(A.simulated)
			return FALSE
	return TRUE

// Picks a turf without a mob from the given list of turfs, if one exists.
// If no such turf exists, picks any random turf from the given list of turfs.
/proc/pick_mobless_turf_if_exists(list/start_turfs)
	if(!start_turfs.len)
		return null

	var/list/available_turfs = list()
	for(var/start_turf in start_turfs)
		var/mob/M = locate() in start_turf
		if(!M)
			available_turfs += start_turf
	if(!available_turfs.len)
		available_turfs = start_turfs
	return pick(available_turfs)

/proc/is_below_sound_pressure(turf/T)
	var/datum/gas_mixture/environment = T ? T.return_air() : null
	var/pressure =  environment ? environment.return_pressure() : 0
	if(pressure < SOUND_MINIMUM_PRESSURE)
		return TRUE
	return FALSE