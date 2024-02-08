//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * /obj/effect/debris
 */
/datum/bulk_entity_persistence/debris

#warn impl all

/**
 * forms debris into groups
 *
 * we assume all input debris are on turfs!!
 *
 * @return list(/datum/debris_group instance, ...)
 */
/datum/bulk_entity_persistence/debris/proc/calculate_groups(list/obj/effect/debris/debris)
	var/list/datum/debris_group/formed = list()

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
		var/datum/debris_group/group = new
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

/datum/debris_group
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
/datum/debris_group/proc/estimate_density()
	return length(contained) / tile_count
