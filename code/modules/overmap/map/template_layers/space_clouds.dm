///Overmap generation layer for space clouds
/datum/overmap_template_layer/space_clouds
	///Seed for randomized clouds
	var/seed

/datum/overmap_template_layer/space_clouds/New(seed)
	if(!isnull(seed))
		src.seed = seed
	else
		src.seed = world.realtime

	rand_seed(seed)
	return ..()

///TODO: Make this function
/datum/overmap_template_layer/space_clouds/apply_to(datum/overmap/map)

	/* LEGACY_EVENTS COPY
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
	*/
