/datum/atmos_zone
	var/list/turf/simulated/floor/turfs

/datum/atmos_zone/New(turf/initial, auto_propogate)
	turfs = list()
	if(auto_propogate)
		auto_propogate(initial)

/datum/atmos_zone/proc/auto_propogate(turf/from)
	if(from)
		turfs += from

