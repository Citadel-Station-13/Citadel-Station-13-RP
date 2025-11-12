/datum/map/sector/surt
	id = "surt"
	name = "Sector - Lavaland"
	width = 192
	height = 192
	levels = list(
		/datum/map_level/sector/surt/base,
		/datum/map_level/sector/surt/east,
	)

/datum/map_level/sector/surt
	base_turf = /turf/simulated/mineral/floor
	base_area = /area/sector/surt/central/unexplored
	traits = list(
		ZTRAIT_GRAVITY,
	)
	planet_path = /datum/planet/lavaland
	air_outdoors = /datum/atmosphere/planet/lavaland

/datum/map_level/sector/surt/base
	id = "LavalandBase192"
	name = "Sector - Lavaland West"
	display_name = "Surt - West"
	path = "maps/sectors/surt/levels/surt_west.dmm"
	struct_x = 0
	struct_y = 0
	struct_z = 0

/datum/map_level/sector/surt/base/on_loaded_immediate(z_index, list/datum/callback/out_generation_callbacks)
	. = ..()
	out_generation_callbacks?.Add(
		CALLBACK(
			GLOBAL_PROC,
			GLOBAL_PROC_REF(seed_submaps),
			list(z_index),
			80,
			/area/sector/surt/central/unexplored,
			/datum/map_template/submap/level_specific/lavaland,
		)
	)
	// todo: yielding generation
	new /datum/random_map/noise/ore/lavaland(null, 1, 1, z_index, 64, 64)         // Create the mining ore distribution map.
	new /datum/random_map/automata/cave_system/no_cracks(null, 1, 1, z_index, world.maxx - 4, world.maxy - 4) // Create the lavaland Z-level.

/datum/map_level/sector/surt/east
	id = "LavalandEast192"
	name = "Sector - Lavaland East"
	display_name = "Surt - East"
	path = "maps/sectors/surt/levels/surt_east.dmm"
	struct_x = 1
	struct_y = 0
	struct_z = 0

/datum/map_level/sector/surt/east/on_loaded_immediate(z_index, list/datum/callback/out_generation_callbacks)
	. = ..()
	out_generation_callbacks?.Add(
		CALLBACK(
			GLOBAL_PROC,
			GLOBAL_PROC_REF(seed_submaps),
			list(z_index),
			40,
			/area/sector/surt/east/unexplored,
			/datum/map_template/submap/level_specific/lavaland,
		)
	)
	// todo: yielding generation
	new /datum/random_map/noise/ore/lavaland(null, 1, 1, z_index, 64, 64)
	new /datum/random_map/automata/cave_system/no_cracks(null, 1, 1, z_index, world.maxx - 4, world.maxy - 4)
