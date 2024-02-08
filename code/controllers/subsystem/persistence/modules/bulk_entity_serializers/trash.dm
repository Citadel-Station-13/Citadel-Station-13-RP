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
	for(var/obj/effect/trash/item in world)
		if(item.z != z)
			continue
		. += item
	return filter_items(.)

/datum/bulk_entity_persistence/trash/serialize_entities_into_chunks(list/atom/movable/entity, perform_filtering)
	#warn impl

/datum/bulk_entity_persistence/trash/load_chunks(datum/bulk_entity_chunk/chunks)
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
 * returns a lockstepped list
 *
 * all items should be on the same zlevel.
 *
 * @return list(list(items), list(densities))
 */
/datum/bulk_entity_persistence/trash/proc/density_computation(list/obj/item/items)
	// lockstepped list of vec2's
	var/list/datum/vec2/points = list()
	for(var/i in 1 to length(items))
		var/obj/item/item = items[i]
		points += new /datum/vec2(item.x, item.y)

	#warn triangulation / voronoi

#warn impl all
