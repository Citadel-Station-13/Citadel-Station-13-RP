//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * /obj/item's that fit a filter
 */
/datum/bulk_entity_persistence/trash

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
