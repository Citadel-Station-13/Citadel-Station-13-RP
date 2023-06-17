
#warn impl
/datum/map/sector/lavaland_140
	id = "lavaland_140"
	name = "Sector - Lavaland"
	width = 140
	height = 140
	levels = list(
		/datum/map_level/sector/lavaland_140/base,
		/datum/map_level/sector/lavaland_140/east,
	)

/datum/map_level/sector/lavaland_140
	base_turf = /turf/simulated/mineral/floor/lavaland
	base_area = /area/lavaland/central/unexplored
	traits = list(
		ZTRAIT_GRAVITY,
	)
	planet_path = /datum/planet/lavaland

/datum/map_level/sector/lavaland_140/base
	id = "LavalandBase140"
	name = "Sector - Lavaland West"
	display_name = "Surt - West"
	absolute_path = "maps/sectors/lavaland_140/levels/lavaland_140.dmm"
	link_east = /datum/map_level/sector/lavaland_140/east

/datum/map_level/sector/lavaland_140/base/on_loaded_immediate(z_index, list/datum/callback/additional_generation)
	. = ..()
	additional_generation?.Add(
		CALLBACK(
			GLOBAL_PROC,
			GLOBAL_PROC_REF(seed_submaps),
			list(z_index),
			80,
			/area/lavaland/central/unexplored,
			/datum/map_template/submap/level_specific/lavaland,
		)
	)
	// todo: yielding generation
	new /datum/random_map/noise/ore/lavaland(null, 1, 1, z_index, 64, 64)         // Create the mining ore distribution map.
	new /datum/random_map/automata/cave_system/no_cracks(null, 1, 1, z_index, world.maxx - 4, world.maxy - 4) // Create the lavaland Z-level.

/datum/map_level/sector/lavaland_140/east
	id = "LavalandEast140"
	name = "Sector - Lavaland East"
	display_name = "Surt - East"
	absolute_path = "maps/sectors/lavaland_140/levels/lavaland_140_east.dmm"
	link_west = /datum/map_level/sector/lavaland_140/base

/datum/map_level/sector/lavaland_140/east/on_loaded_immediate(z_index, list/datum/callback/additional_generation)
	. = ..()
	additional_generation?.Add(
		CALLBACK(
			GLOBAL_PROC,
			GLOBAL_PROC_REF(seed_submaps),
			list(z_index),
			40,
			/area/lavaland/east/unexplored,
			/datum/map_template/submap/level_specific/lavaland,
		)
	)
	// todo: yielding generation
	new /datum/random_map/noise/ore/lavaland(null, 1, 1, z_index, 64, 64)
	new /datum/random_map/automata/cave_system/no_cracks(null, 1, 1, z_index, world.maxx - 4, world.maxy - 4)

/obj/landmark/map_data/lavaland_east
	height = 1
