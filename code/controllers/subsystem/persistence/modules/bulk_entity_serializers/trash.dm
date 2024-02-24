//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * /obj/item's that fit a filter
 */
/datum/bulk_entity_persistence/trash
	id = "trash"

/datum/bulk_entity_persistence/trash/is_enabled()
	return CONFIG_GET(flag/persistent_trash)

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

/datum/bulk_entity_persistence/trash/perform_global_filter(list/atom/movable/entities)
	entities = SSpersistence.entity_filter_out_non_persisting_objs(entities)
	entities = SSpersistence.entity_filter_out_eroding_turfs(entities)
	return entities

/datum/bulk_entity_persistence/trash/perform_level_filter(list/atom/movable/entities, datum/map_level/level)
	// yeah the voronoi algorithm doesn't work if there's nothing to compute tbh
	// we need atleast 1 for proper triangulation, but let's be safe and break if not 3+.
	if(length(entities) <= 3)
		return entities
	// perform entity filtering based on level and configuraiton
	var/mesh_heuristic = level.persistent_trash_mesh_heuristic + round(length(entities) * 0.001 * level.persistent_trash_mesh_heuristic_escalate_per_thousand)
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
	// collate filtered back into entities
	var/list/collating = singles.Copy()
	for(var/datum/persistent_trash_group/mesh as anything in meshes)
		collating += mesh.trash
	return collating

/datum/bulk_entity_persistence/trash/serialize_entities_into_chunks(list/atom/movable/entities, datum/map_level/level, datum/map_level_persistence/persistence)
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
			var/entity_type = text2path(struct["type"])
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
			var/obj/item/creating = new entity_type(where)
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
	for(var/type in specific_inclusions)
		specific_inclusions[type] = TRUE
	return typecacheof(umbrella_inclusions) | specific_inclusions

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
/datum/bulk_entity_persistence/trash/proc/heuristics(list/obj/item/items, mesh_heuristic_threshold)
	// we need a way to dedupe, so...
	// this is the 'real' graph vertices list; only one is made for a coordinate.
	// this is associated to the list of items in it.
	var/list/datum/vec2/vertices = list()
	// lockstepped list of vec2's
	var/list/datum/vec2/lockstepped_points = list()
	// 16 MB at 1000x1000, dropped right after
	var/list/buffer = new /list(world.maxx * world.maxy)
	for(var/i in 1 to length(items))
		var/obj/item/item = items[i]
		var/index = (item.y - 1) * world.maxx + (item.x)
		if(isnull(buffer[index]))
			var/datum/vec2/created_point = new /datum/vec2(item.x, item.y)
			buffer[index] = created_point
			vertices[created_point] = list()
		vertices[buffer[index]] += item
		lockstepped_points += buffer[index]
	// drop buffer now
	buffer = null
	// enough?
	if(length(vertices) < 3)
		// if less than 3 vertices they're all singles
		// todo: we should try to mesh anything on the same tile..
		return list(list(), items)
	// construct graph
	var/datum/graph/constructed_graph = vec2_dual_delaunay_voronoi_graph(vertices)

	// prepare
	var/list/datum/persistent_trash_group/meshes = list()
	var/list/obj/item/singles = list()
	var/list/datum/vec2/vertices_processing = vertices.Copy()
	var/list/datum/vec2/processed = list()

	// go through vertices and create meshes
	while(length(vertices_processing))
		var/datum/vec2/vertex = vertices_processing[length(vertices_processing)]
		vertices_processing.len--
		var/list/items_on_vertex = vertices[vertex]

		var/list/datum/vec2/expanding = list(vertex)
		var/list/obj/item/items_within_group = list()
		items_within_group += items_on_vertex
		var/maximum_density_over_expansion = 0
		var/expanding_index = 1
		while(expanding_index <= length(expanding))
			var/datum/vec2/source = expanding[expanding_index]
			expanding_index++
			if(processed[source])
				continue
			processed[source] = TRUE
			maximum_density_over_expansion = max(maximum_density_over_expansion, 1 / source.voronoi_area)
			for(var/datum/vec2/dest in constructed_graph.vertices[source])
				if(source.chebyshev_distance_to(dest) > mesh_heuristic_threshold)
					continue
				expanding |= dest
				items_within_group += vertices[source]
				vertices_processing -= dest

		if(length(items_within_group) > 1)
			var/datum/persistent_trash_group/constructed_mesh = new
			constructed_mesh.trash = items_within_group
			constructed_mesh.highest_marked_density = maximum_density_over_expansion
			// todo: configurable?
			var/density_escalation_heuristic = length(items_within_group) / 20
			constructed_mesh.highest_marked_density *= density_escalation_heuristic
			meshes += constructed_mesh
		else
			ASSERT(items_within_group[1])
			singles += items_within_group[1]

	return list(meshes, singles)

/datum/persistent_trash_group
	/// trash in this group
	var/list/obj/item/trash
	/// highest marked density in this group
	var/highest_marked_density = 0

/proc/cmp_persistent_trash_group_density_dsc(datum/persistent_trash_group/A, datum/persistent_trash_group/B)
	return B.highest_marked_density - A.highest_marked_density
