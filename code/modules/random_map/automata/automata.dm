/datum/random_map/automata
	descriptor = "generic caves"
	initial_wall_cell = 55
	var/generated_string
	var/iterations = 0               // Number of times to apply the automata rule.
	var/cell_live_value = WALL_CHAR  // Cell is alive if it has this value.
	var/cell_dead_value = FLOOR_CHAR // As above for death.
	var/cell_threshold = 4          // Cell becomes alive with this many live neighbors.

// Automata-specific procs and processing.
/datum/random_map/automata/generate_map()
	generated_string = rustg_cnoise_generate("[initial_wall_cell]", "[iterations]", "[cell_threshold]", "[cell_threshold - 1]", "[limit_x]", "[limit_y]")
	var/gen = generated_string
	var/_size = limit_x * limit_y
	var/list/apply[_size]
	for(var/i in 1 to _size)
		apply[i] = (gen[i] == "1")? cell_live_value : cell_dead_value
	map = apply

/datum/random_map/autoamta/seed_map()
	return	// nah

/datum/random_map/automata/get_additional_spawns(var/value, var/turf/T)
	return

// Check if a given tile counts as alive for the automata generations.
/datum/random_map/automata/proc/cell_is_alive(var/value)
	return (value == cell_live_value) && (value != cell_dead_value)
