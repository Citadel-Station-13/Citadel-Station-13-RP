//pending tg change turf stuff

/turf/proc/empty(turf_type=/turf/space, baseturf_type, list/ignore_typecache, flags)
	// Remove all atoms except observers, landmarks, docking ports
	var/static/list/ignored_atoms = typecacheof(list(/mob/observer, /atom/movable/landmark, /atom/movable/lighting_object)) // typecacheof(list(/mob/dead, /atom/movable/landmark, /obj/docking_port, /atom/movable/lighting_object))
	var/list/allowed_contents = typecache_filter_list_reverse(GetAllContentsIgnoring(ignore_typecache), ignored_atoms)
	allowed_contents -= src
	for(var/i in 1 to allowed_contents.len)
		var/thing = allowed_contents[i]
		qdel(thing, force=TRUE)

	if(turf_type)
		ChangeTurf(turf_type)
//		var/turf/newT = ChangeTurf(turf_type)
/*
		SSair.remove_from_active(newT)
		CALCULATE_ADJACENT_TURFS(newT)
		SSair.add_to_active(newT,1)
*/

/turf/proc/ScrapeAway()
	return ChangeTurf(get_base_turf_by_area(loc))
