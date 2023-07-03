/datum/map/sector/mining_140
	id = "mining_140"
	name = "Sector - Mining World"
	width = 140
	height = 140
	levels = list(
		/datum/map_level/sector/mining_140,
	)

/datum/map_level/sector/mining_140
	id = "MiningWorld140"
	name = "Sector - Mining World"
	display_name = "Class-G Mineral Rich Planet"
	absolute_path = "maps/sectors/mining_140/levels/mining_140.dmm"
	traits = list(
		ZTRAIT_GRAVITY,
	)
	planet_path = /datum/planet/classg

/datum/map_level/sector/mining_140/on_loaded_immediate(z_index, list/datum/callback/additional_generation)
	. = ..()

	// todo: yield invoke generation
	new /datum/random_map/automata/cave_system/no_cracks(null, 1, 1, z_index, world.maxx - 4, world.maxy - 4) // Create the mining Z-level.
	new /datum/random_map/noise/ore/classg(null, 1, 1, z_index, 64, 64)         // Create the mining ore distribution map.

