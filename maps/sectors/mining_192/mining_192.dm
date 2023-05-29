/datum/map/sector/mining_192
	id = "mining_192"
	name = "Sector - Mining World"
	width = 192
	height = 192
	levels = list(
		/datum/map_level/sector/mining_192,
	)

/datum/map_level/sector/mining_192
	id = "MiningWorld192"
	name = "Sector - Mining World"
	display_name = "Class-G Mineral Rich Planet"
	absolute_path = "maps/sectors/mining_192/levels/mining_192.dmm"
	traits = list(
		ZTRAIT_GRAVITY,
	)

/datum/map_level/sector/mining_192/on_loaded_immediate(z_index, list/datum/callback/additional_generation)
	. = ..()

	// todo: yield invoke generation
	new /datum/random_map/automata/cave_system/no_cracks(null, 1, 1, z_index, world.maxx - 4, world.maxy - 4) // Create the mining Z-level.
	new /datum/random_map/noise/ore/classg(null, 1, 1, z_index, 64, 64)         // Create the mining ore distribution map.

