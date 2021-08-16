/**
 * Remember LINDA excited groups?
 *
 * This is very similar in concept.
 */
/datum/fluid_group
	/// turfs in this group
	var/list/turf/turfs = list()
	/// last world.time a major movement happened
	var/last_motion = 0

/datum/fluid_group/Destroy()
	breakdown()
	return ..()

/datum/fluid_group/proc/breakdown()
	var/datum/reagents/R = new(INFINITY)
	#warn noreact this holy shit
	for(var/turf/T as anything in turfs)
		if(T.fluid_group != src)
			CRASH("Wrong fluid group found")
		T.reagents.trans_to(R, T.reagents.total_volume)
	var/volume_per_turf = R.total_volume / turfs.len
	for(var/turf/T as anything in turfs)
		R.trans_to(T.reagents, volume_per_turf)
		T.fluid_group = null
	turfs.len = 0

/datum/fluid_group/proc/disturb()
	last_motion = world.time

/datum/fluid_group/proc/add(turf/T)
	turfs |= T

/datum/fluid_group/proc/remove(turf/T)
	turfs -= T
