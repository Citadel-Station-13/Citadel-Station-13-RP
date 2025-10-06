/datum/map/sector/miaphus
	id = "miaphus"
	name = "Sector - Miaphus"
	width = 192
	height = 192
	levels = list(
		/datum/map_level/sector/miaphus/beach,
		/datum/map_level/sector/miaphus/cave,
		/datum/map_level/sector/miaphus/desert,
	)

	legacy_assert_shuttle_datums = list(
		/datum/shuttle/autodock/overmap/miaphus/sdf,)

/datum/map_level/sector/miaphus
	base_turf = /turf/simulated/floor/outdoors/beach/sand/desert
	traits = list(
		ZTRAIT_GRAVITY,
	)
	planet_path = /datum/planet/miaphus
	air_outdoors = /datum/atmosphere/planet/classh

/datum/map_level/sector/miaphus/beach
	id = "MiaphusBeach192"
	name = "Sector - Miaphus: Beach"
	display_name = "Miaphus - Beach"
	path = "maps/sectors/miaphus/levels/miaphus_beach.dmm"
	base_turf = /turf/simulated/floor/outdoors/beach/sand
	link_north = /datum/map_level/sector/miaphus/cave

/datum/map_level/sector/miaphus/cave
	id = "MiaphusCaves192"
	name = "Sector - Miaphus: Caves"
	display_name = "Miaphus - Caves"
	path = "maps/sectors/miaphus/levels/miaphus_cave.dmm"
	base_turf = /turf/simulated/floor/outdoors/rocks/caves
	link_south = /datum/map_level/sector/miaphus/beach
	link_west = /datum/map_level/sector/miaphus/desert

/datum/map_level/sector/miaphus/cave/on_loaded_immediate(z_index, list/datum/callback/additional_generation)
	. = ..()
	additional_generation?.Add(
		CALLBACK(
			GLOBAL_PROC,
			GLOBAL_PROC_REF(seed_submaps),
			list(z_index),
			225,
			/area/sector/miaphus/cave/unexplored/normal,
			/datum/map_template/submap/level_specific/mountains/normal,
		)
	)
	// todo: yield invoke generation
	new /datum/random_map/automata/cave_system/no_cracks(null, 3, 3, z_index, world.maxx - 4, world.maxy - 4)

/datum/map_level/sector/miaphus/desert
	id = "MiaphusDesert192"
	name = "Sector - Miaphus: Desert"
	display_name = "Miaphus - Desert"
	path = "maps/sectors/miaphus/levels/miaphus_desert.dmm"
	base_turf = /turf/simulated/floor/outdoors/beach/sand/lowdesert
	link_east = /datum/map_level/sector/miaphus/cave

/datum/map_level/sector/miaphus/desert/on_loaded_immediate(z_index, list/datum/callback/additional_generation)
	. = ..()
	additional_generation?.Add(
		CALLBACK(
			GLOBAL_PROC,
			GLOBAL_PROC_REF(seed_submaps),
			list(z_index),
			225,
			/area/sector/miaphus/beach/desert/unexplored,
			/datum/map_template/submap/level_specific/class_h,
		)
	)
