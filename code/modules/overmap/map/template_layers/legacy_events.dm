//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * legacy seeded events
 */
/datum/overmap_template_layer/legacy_events
	/// number of clouds
	var/number_of_clouds = 2

/datum/overmap_template_layer/legacy_events/New(number_of_clouds)
	if(!isnull(number_of_clouds))
		src.number_of_clouds = number_of_clouds
	return ..()

#warn impl

/datum/overmap_template_layer/legacy_events/apply_to(datum/overmap/map)
	. = ..()
	if(!.)
		return

	var/list/turf/overmap_turfs = map.reservation.inner_turfs.Copy()
	var/list/turf/candidate_turfs = list()

	for(var/turf/candidate as anything in overmap_turfs)
		if(length(candidate.contents))
			continue
		candidate_turfs += candidate

	for(var/i in 1 to number_of_clouds)
		if(!length(candidate_turfs))
			break
		var/event_type = pick(subtypesof(/datum/overmap_event))
		var/datum/overmap_event/datum_spawn = new event_type

		var/list/turf/event_turfs = get_cloud_turfs(datum_spawn.count, datum_spawn.radius, candidate_tu)

/datum/overmap_template_layer/legacy_events/proc/get_cloud_turfs(amount, radius, list/turf/candidates, continuous)
	// don't modify original list
	candidates = candidates.Copy()
 	// clamp
	amount = min(amount, length(candidates))


