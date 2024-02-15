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

/datum/bulk_entity_persistence/debris/perform_level_filter(list/atom/movable/entities, datum/map_level/level)
	// perform entity filtering based on level and configuraiton
	// var/datum/map_level/level
	// var/mesh_heuristic = level.persistent_debris_drop_n_largest
	// var/drop_n_largest_meshes = level.persistent_trash_drop_n_largest
	// var/drop_n_smallest_meshes = level.persistent_trash_drop_n_smallest
	// var/drop_n_most_isolated = level.persistent_trash_drop_n_most_isolated
	// var/drop_n_least_isolated = level.persistent_trash_drop_n_least_isolated
	// // run heuristics
	// var/list/results = heuristics(entities, mesh_heuristic)
	// var/list/meshes = results[1]
	// var/list/singles = results[2]
	// // sort results by descending density
	// tim_sort(meshes, GLOBAL_PROC_REF(cmp_persistent_trash_group_density_dsc))
	// tim_sort(singles, GLOBAL_PROC_REF(cmp_numeric_dsc), associative = TRUE)
	// // drop results as needed
	// meshes.Cut(1, min(length(meshes) + 1, drop_n_largest_meshes + 1))
	// meshes.len -= drop_n_smallest_meshes
	// singles.Cut(1, min(length(singles) + 1, drop_n_least_isolated + 1))
	// singles.len -= drop_n_most_isolated
	// collate filtered back into z_entities
	// var/list/collating = singles.Copy()
	// for(var/datum/persistent_trash_group/mesh as anything in meshes)
	// 	collating += mesh.trash
	// return collating
	#warn impl - voronoi

/datum/bulk_entity_persistence/debris/serialize_entities_into_chunks(list/atom/movable/entities, datum/map_level/level, datum/map_level_persistence/persistence)
	var/list/datum/bulk_entity_chunk/chunks = list()
	// split by zlevel
	var/list/z_index_split = SSpersistence.entity_group_by_zlevel(entities)
	// iterate
	for(var/z_index in 1 to world.maxz)
		var/list/atom/movable/z_entities = z_index_split[z_index]
		var/level_id = SSpersistence.level_id_of_z(z_index)
		if(isnull(level_id) || !length(z_entities))
			continue
		// split by area/turf
		var/list/area_turf_tuples = SSpersistence.entity_group_by_area_and_turf(z_entities)
		for(var/list/area_turf_tuple as anything in area_turf_tuples)
			var/area_type = area_turf_tuple[1]
			var/turf_type = area_turf_tuple[2]
			var/list/area_turf_entities = area_turf_tuples[area_turf_tuple]
			// limit to 500 entities per chunk
			for(var/list/atom/movable/chunk_entities as anything in SSpersistence.entity_split_by_amount(area_turf_entities, 500))
				// create chunk
				var/datum/bulk_entity_chunk/chunk = new
				chunk.level_id = level_id
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
