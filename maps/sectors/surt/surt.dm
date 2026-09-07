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

	injections = list(
		new /datum/map_injection/legacy_automata_caves/on_dmm,
		new /datum/map_injection/legacy_seed_submaps(
			80,
			/area/sector/surt/central/unexplored,
			/datum/map_template/submap/level_specific/lavaland,
		),
		new /datum/map_injection/legacy_noise_ores(
			null,
			0.6,
			0.4,
		),
	)

/datum/map_level/sector/surt/east
	id = "LavalandEast192"
	name = "Sector - Lavaland East"
	display_name = "Surt - East"
	path = "maps/sectors/surt/levels/surt_east.dmm"
	struct_x = 1
	struct_y = 0
	struct_z = 0

	injections = list(
		new /datum/map_injection/legacy_automata_caves/on_dmm,
		new /datum/map_injection/legacy_seed_submaps(
			40,
			/area/sector/surt/east/unexplored,
			/datum/map_template/submap/level_specific/lavaland,
		),
		new /datum/map_injection/legacy_noise_ores(
			null,
			0.6,
			0.4,
		),
	)
