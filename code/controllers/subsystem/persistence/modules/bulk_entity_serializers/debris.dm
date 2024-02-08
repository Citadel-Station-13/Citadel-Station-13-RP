//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * /obj/effect/debris
 */
/datum/bulk_entity_persistence/debris

/datum/bulk_entity_persistence/debris/gather_all()
	. = list()
	for(var/obj/effect/debris/debris in world)
		if(!isturf(debris.loc))
			continue
		. += debris

/datum/bulk_entity_persistence/debris/gather_level(z)
	. = list()
	for(var/obj/effect/debris/debris in world)
		if(debris.z != z)
			continue
		. += debris

/datum/bulk_entity_persistence/debris/serialize_entities_into_chunks(list/atom/movable/entities, datum/map_level/level)
	. = ..()
	#warn impl

/datum/bulk_entity_persistence/debris/load_chunks(list/datum/bulk_entity_chunk/chunks)
	var/loaded = 0
	var/dropped = 0
	for(var/datum/bulk_entity_chunk/chunk as anything in chunks)
		var/z_index = SSmapping.keyed_levels[chunk.level_id]?.z_index
		var/rounds_since = chunk.rounds_since_saved
		var/hours_since = chunk.hours_since_saved
		// drop if level not loaded
		if(isnull(z_index))
			dropped++
			continue
		var/area_type = text2path(chunk.data["area_lock"])
		var/turf_type = text2path(chunk.data["turf_lock"])
		// drop if area/turf types no longer exist
		if(!ispath(area_type))
			dropped++
			continue
		if(!ispath(turf_type))
			dropped++
			continue
		// entities = list(list("type" = type, "data" = list), ...)
		var/list/entities = chunk.data["entities"]
		for(var/list/struct as anything in entities)
			if(!islist(struct))
				continue
			var/entity_type = struct["type"]
			var/list/entity_data = struct["data"]
			// check for valid debris
			if(!ispath(entity_type, /obj/effect/debris))
				dropped++
				continue
			var/x = struct["x"]
			var/y = struct["y"]
			// locate spawn location
			var/turf/where = locate(x, y, z_index)
			if(isnull(where))
				dropped++
				continue
			// check area / turf constraint
			if(!istype(where, turf_type) || !istype(where.loc, area_type))
				dropped++
				continue
			var/obj/effect/debris/creating = new(where)
			creating.deserialize(entity_data)
			creating.decay_persisted(rounds_since, hours_since)
			loaded++
	return list(loaded, dropped, 0)


/**
 * forms debris into groups
 *
 * we assume all input debris are on turfs!!
 *
 * @return list(/datum/persistent_debris_group instance, ...)
 */
/datum/bulk_entity_persistence/debris/proc/calculate_groups(list/obj/effect/debris/debris)
	var/list/datum/persistent_debris_group/formed = list()

	// lol, lmao, this'll probably result in higgs bugson down the line but whatever
	// todo: maybe don't do this
	var/static/last_calculation_iteration
	var/calculation_iteration = rand(1, 9999)
	if(calculation_iteration == last_calculation_iteration)
		calculation_iteration += 1
	last_calculation_iteration = calculation_iteration

	for(var/obj/effect/debris/instance as anything in debris)
		// already formed
		if(instance.debris_serialization_temporary == calculation_iteration)
			continue
		// make group
		var/datum/persistent_debris_group/group = new
		formed += group
		// floodfill time
		var/list/turf/floodfilling = list(instance.loc = TRUE)
		var/total_center_x = 0
		var/total_center_y = 0
		var/list/turf/found_turfs = list()
		var/pos = 1
		while(pos <= length(floodfilling))
			pos++
			var/turf/scanning = floodfilling[pos]
			// do we have anything in us?
			var/found = FALSE
			for(var/obj/effect/debris/scanned in scanning)
				// don't rescan that
				scanned.debris_serialization_temporary = calculation_iteration
				// add to group
				group.contained += scanned
				// mark success
				found = TRUE
			// if nothing was found, this is a dead end
			if(!found)
				continue
			// add to found
			found_turfs += scanning
			// add overall center x / y
			total_center_x += scanning.x
			total_center_y += scanning.y
			// add adjacent turfs to floodfilling if they're not there already
			for(var/turf/enemy in RANGE_TURFS(1, scanning))
				// because we're using an assoc list, this won't add an entry if it's already there.
				floodfilling[enemy] = TRUE
		// count tiles
		group.tile_count = length(found_turfs)
		// get center
		group.center_x = total_center_x / group.tile_count
		group.center_y = total_center_y / group.tile_count

	#warn triangulation / voronoi

	return formed

/datum/persistent_debris_group
	/// debris in this group
	var/list/obj/effect/debris/contained = list()
	/// tile count in this group
	var/tile_count = 0
	/// center of x
	var/center_x
	/// center of y
	var/center_y

/**
 * get relative debris density
 */
/datum/persistent_debris_group/proc/estimate_density()
	return length(contained) / tile_count
