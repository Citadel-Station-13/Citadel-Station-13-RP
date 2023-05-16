/proc/get_station_areas(list/area/excluded_areas)
	var/list/area/grand_list_of_areas = list()
	// Assemble areas that all exists (See DM reference if you are confused about loop labels)
	looping_station_areas:
		for(var/parentpath in global.the_station_areas)
			// Check its not excluded.
			for(var/excluded_path in excluded_areas)
				if(ispath(parentpath, excluded_path))
					continue looping_station_areas
			// Otherwise add it and all subtypes that exist on the map to our grand list.
			for(var/areapath in typesof(parentpath))
				// Check if it actually exists.
				var/area/A = locate(areapath)
				if(istype(A) && (A.z in GLOB.using_map.player_levels))
					grand_list_of_areas += A
	return grand_list_of_areas

/**
 * Checks if any living humans are in a given area!
 */
/proc/is_area_occupied(area/myarea)
	// Testing suggests looping over human_mob_list is quicker than looping over area contents
	for(var/mob/living/carbon/human/H in human_mob_list)
		// Conditions for exclusion here, like if disconnected people start blocking it.
		if(H.stat >= DEAD)
			continue
		var/area/A = get_area(H)
		// The loc of a turf is the area it is in.
		if(A == myarea)
			return TRUE
	return FALSE
