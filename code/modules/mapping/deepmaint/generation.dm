/// mutex to prevent more than one from generating at once
GLOBAL_VAR(deepmaint_generating)

/atom/movable/landmark/deepmaint_root/proc/_lock_for_generation()
	while(GLOB.deepmaint_generating != src)
		if(QDELETED(src))
			return FALSE
		stoplag(1)
	GLOB.deepmaint_generating = src
	GLOB.deepmaint_current_exterior_floor = exterior_floor_type
	GLOB.deepmaint_current_exterior_wall = exterior_wall_type
	GLOB.deepmaint_current_interior_floor = interior_floor_type
	GLOB.deepmaint_current_interior_plating = interior_plating_type
	GLOB.deepmaint_current_interior_wall = interior_wall_type
	return TRUE

/atom/movable/landmark/deepmaint_root/proc/_unlock_from_generation()
	if(GLOB.deepmaint_generating != src)
		CRASH("wasn't even our turn")
	GLOB.deepmaint_generating = null
	GLOB.deepmaint_current_exterior_floor = null
	GLOB.deepmaint_current_exterior_wall = null
	GLOB.deepmaint_current_interior_floor = null
	GLOB.deepmaint_current_interior_plating = null
	GLOB.deepmaint_current_interior_wall = null
	return TRUE

/atom/movable/landmark/deepmaint_root/proc/generate()
	_lock_for_generation()
	var/datum/deepmaint_algorithm/algorithm_instance
	switch(algorithm)
		if(DEEPMAINT_ALGORITHM_DUNGEON_SPREAD)
			algorithm_instance = new /datum/deepmaint_algorithm/dungeon
	if(algorithm_instance)
		algorithm_instance.generate(src, get_turf(src), gather_markers(), gather_templates())
	else
		stack_trace("Couldn't find algorithm instance for algorithm [algorithm]")
	_unlock_from_generation()

/atom/movable/landmark/deepmaint_root/proc/generate_async()
	set waitfor = FALSE
	generate()

/atom/movable/landmark/deepmaint_root/proc/gather_markers()
	return SSmapping.get_deepmaint_markers(id)

/atom/movable/landmark/deepmaint_root/proc/gather_templates()
	. = list()
	for(var/datum/map_template/submap/deepmaint/T in SSmapping.deepmaint_templates)
		if(!(T.deepmaint_type & deepmaint_type))
			continue
		if(!(T.deepmaint_theme & deepmaint_theme))
			continue
		. += T

