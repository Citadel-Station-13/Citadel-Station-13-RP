//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * /obj/effect/debris
 */
/datum/bulk_entity_persistence/debris
	id = "debris"

/datum/bulk_entity_persistence/debris/is_enabled()
	return CONFIG_GET(flag/persistent_debris)

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

/datum/bulk_entity_persistence/debris/perform_global_filter(list/atom/movable/entities)
	entities = SSpersistence.entity_filter_out_non_persisting_objs(entities)
	entities = SSpersistence.entity_filter_out_eroding_turfs(entities)
	return entities

/datum/bulk_entity_persistence/debris/perform_level_filter(list/atom/movable/entities, datum/map_level/level)
	var/list/datum/persistent_debris_group/groups = calculate_groups(entities)
	// do we have any
	if(!length(groups))
		return
	// sort descending densities
	tim_sort(groups, GLOBAL_PROC_REF(cmp_persistent_debris_group_unimportant_density_dsc))

	// firstly, drop important groups as needed
	var/important_zone_drop_chance = level.persistent_debris_important_drop_chance
	var/important_total_found = 0
	var/important_demotion_zone_threshold = level.persistent_debris_important_demotion_zone_threshold
	for(var/datum/persistent_debris_group/group as anything in groups)
		if(!length(group.important))
			continue
		if(important_demotion_zone_threshold && length(group.important) > important_demotion_zone_threshold)
			group.contained += group.important
			group.important.len = 0
			continue
		important_total_found += length(group.important)
		if(prob(important_zone_drop_chance))
			group.important.len = 0
	// if too many
	if(important_total_found > level.persistent_debris_important_demotion_level_threshold)
		// drop literally everything
		for(var/datum/persistent_debris_group/group as anything in groups)
			group.contained += group.important
			group.important.len = 0

	// single dropping does not use any graph ops
	var/to_drop_single = level.persistent_debris_drop_n_single
	var/drop_index
	for(drop_index in length(groups) to 1 step -1)
		if(to_drop_single <= 0)
			break
		var/datum/persistent_debris_group/group = groups[drop_index]
		switch(length(group.contained))
			if(0)
				continue
			if(1)
			else
				break
		group.contained.len = 0
		to_drop_single--

	// todo: proper graph ops
	// byondapi when?
	// we need proper support for mesh operations, the current way is too jank

	// drop n smallest
	var/to_drop_smallest = level.persistent_debris_drop_n_smallest
	for(drop_index in drop_index to 1 step -1)
		if(to_drop_smallest <= 0)
			break
		var/datum/persistent_debris_group/group = groups[drop_index]
		if(!length(group.contained))
			continue
		group.contained.len = 0
		--to_drop_smallest

	// drop n largest
	var/to_drop_largest = level.persistent_debris_drop_n_largest
	for(drop_index in 1 to drop_index)
		if(to_drop_largest <= 0)
			break
		var/datum/persistent_debris_group/group = groups[drop_index]
		if(!length(group.contained))
			break
		group.contained.len = 0
		--to_drop_largest

	var/list/atom/movable/collated = list()
	for(var/datum/persistent_debris_group/group as anything in groups)
		collated += group.important
		collated += group.contained

	return collated

/datum/bulk_entity_persistence/debris/serialize_entities_into_chunks(list/atom/movable/entities, datum/map_level/level, datum/map_level_persistence/persistence)
	var/list/datum/bulk_entity_chunk/chunks = list()
	if(!length(entities))
		return
	// split by area/turf
	var/list/area_turf_tuples = SSpersistence.entity_group_by_area_and_turf(entities)
	for(var/list/area_turf_tuple as anything in area_turf_tuples)
		var/area_type = area_turf_tuple[1]
		var/turf_type = area_turf_tuple[2]
		var/list/area_turf_entities = area_turf_tuples[area_turf_tuple]
		// limit to 500 entities per chunk
		for(var/list/atom/movable/chunk_entities as anything in SSpersistence.entity_split_by_amount(area_turf_entities, 500))
			// create chunk
			var/datum/bulk_entity_chunk/chunk = new
			chunk.level_id = persistence.level_id
			var/list/entities_constructed = list()
			for(var/atom/movable/entity as anything in chunk_entities)
				entities_constructed[++entities_constructed.len] = list(
					"x" = entity.x,
					"y" = entity.y,
					"type" = entity.type,
					"data" = entity.serialize(),
				)
			chunk.data = list(
				"area_lock" = area_type,
				"turf_lock" = turf_type,
				"entities" = entities_constructed,
			)
			chunks += chunk
	return chunks

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
			var/entity_type = text2path(struct["type"])
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
			var/obj/effect/debris/creating = new entity_type(where)
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
			var/turf/scanning = floodfilling[pos]
			pos++
			// do we have anything in us?
			var/found = FALSE
			for(var/obj/effect/debris/scanned in scanning)
				// don't rescan that
				scanned.debris_serialization_temporary = calculation_iteration
				// add to group
				if(scanned.relatively_important)
					group.important += scanned
				else
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
		// count tiles and objects
		group.tile_count = length(found_turfs)
		group.object_count = length(group.contained) + length(group.important)
		// get relative density
		group.self_naive_density = (length(group.contained) + length(group.important)) / group.tile_count
		// get center
		group.center_x = total_center_x / group.tile_count
		group.center_y = total_center_y / group.tile_count

	return formed

/datum/persistent_debris_group
	/// debris in this group
	var/list/obj/effect/debris/contained = list()
	/// important debris in this group
	var/list/obj/effect/debris/important = list()
	/// tile count in this group
	var/tile_count = 0
	/// total object count
	var/object_count = 0
	/// center of x
	var/center_x
	/// center of y
	var/center_y
	/// self naive density calc
	var/self_naive_density

/**
 * get relative debris density
 */
/datum/persistent_debris_group/proc/estimate_density()
	return (length(contained) + length(important)) / tile_count

/proc/cmp_persistent_debris_group_density_dsc(datum/persistent_debris_group/A, datum/persistent_debris_group/B)
	return B.self_naive_density - A.self_naive_density

/proc/cmp_persistent_debris_group_unimportant_density_dsc(datum/persistent_debris_group/A, datum/persistent_debris_group/B)
	return length(B.contained) - length(A.contained)
