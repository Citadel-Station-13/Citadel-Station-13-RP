//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * /obj/item's that fit a filter
 */
/datum/bulk_entity_persistence/trash

/datum/bulk_entity_persistence/trash/gather_all()
	. = list()
	for(var/obj/item/item in world)
		if(!isturf(item.loc))
			continue
		. += item
	return filter_items(.)

/datum/bulk_entity_persistence/trash/gather_level(z)
	. = list()
	for(var/obj/item/item in world)
		if(item.z != z)
			continue
		. += item
	return filter_items(.)

/datum/bulk_entity_persistence/trash/perform_level_filter(list/atom/movable/entities, datum/map_level/level)
	// perform entity filtering based on level and configuraiton
	var/mesh_heuristic = level.persistent_trash_mesh_heuristic
	var/drop_n_largest_meshes = level.persistent_trash_drop_n_largest
	var/drop_n_smallest_meshes = level.persistent_trash_drop_n_smallest
	var/drop_n_most_isolated = level.persistent_trash_drop_n_most_isolated
	var/drop_n_least_isolated = level.persistent_trash_drop_n_least_isolated
	// run heuristics
	var/list/results = heuristics(entities, mesh_heuristic)
	var/list/meshes = results[1]
	var/list/singles = results[2]
	// sort results by descending density
	tim_sort(meshes, GLOBAL_PROC_REF(cmp_persistent_trash_group_density_dsc))
	tim_sort(singles, GLOBAL_PROC_REF(cmp_numeric_dsc), associative = TRUE)
	// drop results as needed
	meshes.Cut(1, min(length(meshes) + 1, drop_n_largest_meshes + 1))
	meshes.len -= drop_n_smallest_meshes
	singles.Cut(1, min(length(singles) + 1, drop_n_least_isolated + 1))
	singles.len -= drop_n_most_isolated
	// collate filtered back into z_entities
	var/list/collating = singles.Copy()
	for(var/datum/persistent_trash_group/mesh as anything in meshes)
		collating += mesh.trash
	return collating

/datum/bulk_entity_persistence/trash/serialize_entities_into_chunks(list/atom/movable/entities, datum/map_level/level)
	var/list/datum/bulk_entity_chunk/chunks = list()
	// split by zlevel
	var/list/z_index_split = SSpersistence.bulk_entity_group_by_zlevel(entities)
	// iterate
	for(var/z_index in 1 to world.maxz)
		var/list/atom/movable/z_entities = z_index_split[z_index]
		var/datum/map_level/level_instance = SSmapping.ordered_levels[z_index]
		var/level_id = SSpersistence.level_id_of_z(z_index)
		if(isnull(level_id) || !length(z_entities))
			continue
		// split by area/turf
		var/list/area_turf_tuples = SSpersistence.bulk_entity_group_by_area_and_turf(z_entities)
		for(var/list/area_turf_tuple as anything in area_turf_tuples)
			var/area_type = area_turf_tuple[1]
			var/turf_type = area_turf_tuple[2]
			var/list/area_turf_entities = area_turf_tuples[area_turf_tuple]
			// limit to 500 entities per chunk
			for(var/list/atom/movable/chunk_entities as anything in SSpersistence.bulk_entity_split_by_amount(area_turf_entities, 500))
				// create chunk
				var/datum/bulk_entity_chunk/chunk = new
				chunk.level_id = level_id
				chunk.amount = length(chunk_entities)
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

/datum/bulk_entity_persistence/trash/load_chunks(list/datum/bulk_entity_chunk/chunks)
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
			// check for valid item
			if(!ispath(entity_type, /obj/item))
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
			var/obj/item/creating = new(where)
			creating.deserialize(entity_data)
			creating.decay_persisted(rounds_since, hours_since)
			loaded++
	return list(loaded, dropped, 0)

/datum/bulk_entity_persistence/trash/proc/trash_typecache()
	var/list/umbrella_inclusions = list(
		/obj/item/trash,
	)
	var/list/specific_inclusions = list(
		/obj/item/cigbutt,
		/obj/item/paper/crumpled,
	)
	#warn impl
	for(var/type in specific_inclusions)
		specific_inclusions[type] = TRUE
	return typecacheof(umbrella_inclusions) + specific_inclusions

/datum/bulk_entity_persistence/trash/proc/filter_items(list/obj/item/items)
	// append, not remove; save the vector resizing/etc
	// we could swap with end instead but eh.
	var/list/filtered = list()
	var/list/typecache = trash_typecache()
	for(var/obj/item/item as anything in items)
		// first, check typecache
		if(!typecache[item.type])
			continue
		filtered += item
	return filtered

/**
 * all items should be on the same zlevel.
 *
 * returns a list with indices:
 *
 * 1: meshes with densities
 * 2: list of single items associated to density
 *
 * @return list(list(/datum/persistent_trash_group instance, ..), list(item instance = density, ...))
 */
/datum/bulk_entity_persistence/trash/proc/heuristics(list/obj/item/items)
	// lockstepped list of vec2's
	var/list/datum/vec2/points = list()
	for(var/i in 1 to length(items))
		var/obj/item/item = items[i]
		points += new /datum/vec2(item.x, item.y)


	#warn triangulation / voronoi

#warn impl all

/datum/persistent_trash_group
	/// trash in this group
	var/list/obj/item/trash = list()
	/// highest marked density in this group
	var/highest_marked_density = 0

/proc/cmp_persistent_trash_group_density_dsc(datum/persistent_trash_group/A, datum/persistent_trash_group/B)
	return B.highest_marked_density - A.highest_marked_density
