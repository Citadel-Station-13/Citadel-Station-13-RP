/datum/random_map/automata/cave_system
	iterations = 5
	descriptor = "moon caves"
	var/list/ore_turfs = list()
	var/make_cracked_turfs = TRUE

/datum/random_map/automata/cave_system/generate_map()
	. = ..()
	for(var/i in 1 to map.len)
		if(map[i] == WALL_CHAR)
			ore_turfs += i

/datum/random_map/automata/cave_system/no_cracks
	make_cracked_turfs = FALSE

/datum/random_map/automata/cave_system/get_appropriate_path(var/value)
	return

/datum/random_map/automata/cave_system/get_map_char(var/value)
	switch(value)
		if(DOOR_CHAR)
			return "x"
		if(EMPTY_CHAR)
			return "X"
	return ..(value)

// Create ore turfs.
/datum/random_map/automata/cave_system/cleanup()
	var/ore_count = round(map.len/20)
	while((ore_count>0) && (ore_turfs.len>0))
		if(!priority_process)
			CHECK_TICK
		var/check_cell = pick(ore_turfs)
		ore_turfs -= check_cell
		if(prob(75))
			map[check_cell] = DOOR_CHAR  // Mineral block
		else
			map[check_cell] = EMPTY_CHAR // Rare mineral block.
		ore_count--
	return 1

/datum/random_map/automata/cave_system/apply_to_turf(var/x,var/y)
	var/current_cell = get_map_cell(x,y)
	if(!current_cell)
		return 0
	var/turf/simulated/mineral/T = locate((origin_x-1)+x,(origin_y-1)+y,origin_z)
	if(istype(T) && !T.ignore_mapgen && !T.ignore_cavegen)
		if(map[current_cell] == FLOOR_CHAR)
			T.make_floor()
		else
			T.make_wall()
			if(map[current_cell] == DOOR_CHAR)
				T.make_ore()
			else if(map[current_cell] == EMPTY_CHAR)
				T.make_ore(1)
		get_additional_spawns(map[current_cell],T,get_spawn_dir(x, y))
	return T
