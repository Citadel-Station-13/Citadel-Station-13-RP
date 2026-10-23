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
	struct_x = 0
	struct_y = 0
	struct_z = 0

/datum/map_level/sector/miaphus/cave
	id = "MiaphusCaves192"
	name = "Sector - Miaphus: Caves"
	display_name = "Miaphus - Caves"
	path = "maps/sectors/miaphus/levels/miaphus_cave.dmm"
	base_turf = /turf/simulated/floor/outdoors/rocks/caves
	struct_x = 0
	struct_y = 1
	struct_z = 0

	injections = list(
		new /datum/map_injection/legacy_automata_caves/on_dmm,
		new /datum/map_injection/legacy_seed_submaps(
			225,
			/area/sector/miaphus/cave/unexplored/normal,
			/datum/map_template/submap/level_specific/mountains/normal,
		),
	)

/datum/map_level/sector/miaphus/desert
	id = "MiaphusDesert192"
	name = "Sector - Miaphus: Desert"
	display_name = "Miaphus - Desert"
	path = "maps/sectors/miaphus/levels/miaphus_desert.dmm"
	base_turf = /turf/simulated/floor/outdoors/beach/sand/lowdesert
	struct_x = -1
	struct_y = 1
	struct_z = 0

	injections = list(
		new /datum/map_injection/legacy_seed_submaps(
			225,
			/area/sector/miaphus/beach/desert/unexplored,
			/datum/map_template/submap/level_specific/class_h,
		),
	)
