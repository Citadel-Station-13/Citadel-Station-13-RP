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

/datum/fluid_group/New()
	last_motion = world.time
	SSfluids.groups |= src

/datum/fluid_group/Destroy()
	breakdown()
	SSfluids.groups -= src
	return ..()

/datum/fluid_group/proc/breakdown()
	var/total_height = 0
	var/
	#warn take into account height
	#warn noreact this holy shit
	#warn use fast procs instead of normal transfer, or just flat out directly edit values



/datum/fluid_group/proc/disturb()
	last_motion = world.time

/datum/fluid_group/proc/add(turf/T)
	turfs |= T

/datum/fluid_group/proc/remove(turf/T)
	turfs -= T
