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

/datum/overmap_template_layer/legacy_events/apply_to(datum/overmap/map)
	. = ..()
	if(!.)
		return

	var/list/turf/overmap_turfs = map.reservation.unordered_inner_turfs()
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

		var/list/turf/event_turfs = get_cloud_turfs(datum_spawn.count, datum_spawn.radius, candidate_turfs, datum_spawn.continuous)
		candidate_turfs -= event_turfs

		for(var/turf/event_turf as anything in event_turfs)
			var/event_spawn_type = pick(datum_spawn.hazards)
			new event_spawn_type(event_turf)

		qdel(datum_spawn)

/datum/overmap_template_layer/legacy_events/proc/get_cloud_turfs(amount, radius, list/turf/candidates, continuous)
	// don't modify original list
	candidates = candidates.Copy()
 	// clamp
	amount = min(amount, length(candidates))

	var/turf/origin = pick(candidates)
	var/list/turf/selected = list(origin)
	var/list/turf/expanding = list(origin)

	candidates -= origin

	while(length(expanding) && length(selected) < amount)
		var/turf/checking = pick(expanding)
		var/turf/neighbor = get_random_neighbor(checking, candidates, continuous, radius)

		if(neighbor)
			candidates -= neighbor
			selected += neighbor
			if(get_dist(origin, neighbor) < radius)
				expanding += neighbor
		else
			expanding -= expanding

	return selected

/datum/overmap_template_layer/legacy_events/proc/get_random_neighbor(turf/origin, list/turf/candidates, continuous, range)
	var/list/turf/potential
	if(continuous)
		potential = origin.CardinalTurfs(FALSE)
	else
		potential = trange(range, origin)
	for(var/turf/checking in potential)
		if(checking in candidates)
			return checking
