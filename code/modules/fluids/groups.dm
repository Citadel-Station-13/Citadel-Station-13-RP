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
	var/total_volume = 0
	var/list/turf_heights = list()
	var/list/reagents = list()
	var/list/L
	var/height
	var/ratio
	// collect everything
	for(var/turf/T as anything in turfs)
		total_height += T.fluid_depth
		turf_heights[T] = T.fluid_depth
		L = T.reagents.reagent_list
		total_volume += T.reagents.total_volume
		for(var/datum/reagent/R as anything in L)
			reagents[R.id] += R.volume
	var/base_volume = (total_volume - total_height) / turfs.len
	// apply
	for(var/turf/T as anything in turfs)
		height = turf_heights[T]
		ratio = (base_volume - height) / total_volume
		QDEL_NULL(T.reagents)
		T.reagents = new /datum/reagents
		// inefficient but sue me
		for(var/id in reagents)
			var/datum/reagent/R = new SSchemistry.chemical_reagents[id]
			T.reagents += R
			R.volume = reagents[id] * ratio
		T.reagents.FastUpdateVolume()
	turfs.len = 0

/datum/fluid_group/proc/disturb()
	last_motion = world.time

/datum/fluid_group/proc/add(turf/T)
	turfs |= T

/datum/fluid_group/proc/remove(turf/T)
	turfs -= T
