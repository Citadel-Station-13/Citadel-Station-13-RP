/datum/map/sector/miaphus_192
	id = "miaphus_192"
	name = "Sector - Miaphus"
	width = 192
	height = 192
	levels = list(
		/datum/map_level/sector/miaphus_192/beach,
		/datum/map_level/sector/miaphus_192/cave,
		/datum/map_level/sector/miaphus_192/desert,
	)

/datum/map_level/sector/miaphus_192
	base_turf = /turf/simulated/floor/outdoors/beach/sand/desert
	traits = list(
		ZTRAIT_GRAVITY,
	)
	planet_path = /datum/planet/miaphus

/datum/map_level/sector/miaphus_192/beach
	id = "MiaphusBeach192"
	name = "Sector - Miaphus: Beach"
	display_name = "Miaphus - Beach"
	absolute_path = "maps/sectors/miaphus_192/levels/miaphus_192_beach.dmm"
	base_turf = /turf/simulated/floor/outdoors/beach/sand
	link_north = /datum/map_level/sector/miaphus_192/cave

/datum/map_level/sector/miaphus_192/cave
	id = "MiaphusCaves192"
	name = "Sector - Miaphus: Caves"
	display_name = "Miaphus - Caves"
	absolute_path = "maps/sectors/miaphus_192/levels/miaphus_192_cave.dmm"
	base_turf = /turf/simulated/floor/outdoors/rocks/caves
	link_south = /datum/map_level/sector/miaphus_192/beach
	link_west = /datum/map_level/sector/miaphus_192/desert

/datum/map_level/sector/miaphus_192/cave/on_loaded_immediate(z_index, list/datum/callback/additional_generation)
	. = ..()
	additional_generation?.Add(
		CALLBACK(
			GLOBAL_PROC,
			GLOBAL_PROC_REF(seed_submaps),
			list(z_index),
			225,
			/area/tether_away/cave/unexplored/normal,
			/datum/map_template/submap/level_specific/mountains/normal,
		)
	)
	// todo: yield invoke generation
	new /datum/random_map/automata/cave_system/no_cracks(null, 3, 3, z_index, world.maxx - 4, world.maxy - 4)

/datum/map_level/sector/miaphus_192/desert
	id = "MiaphusDesert192"
	name = "Sector - Miaphus: Desert"
	display_name = "Miaphus - Desert"
	absolute_path = "maps/sectors/miaphus_192/levels/miaphus_192_desert.dmm"
	base_turf = /turf/simulated/floor/outdoors/beach/sand/lowdesert
	link_east = /datum/map_level/sector/miaphus_192/cave

/datum/map_level/sector/miaphus_192/desert/on_loaded_immediate(z_index, list/datum/callback/additional_generation)
	. = ..()
	additional_generation?.Add(
		CALLBACK(
			GLOBAL_PROC,
			GLOBAL_PROC_REF(seed_submaps),
			list(z_index),
			225,
			/area/tether_away/beach/desert/unexplored,
			/datum/map_template/submap/level_specific/class_h,
		)
	)

/obj/effect/step_trigger/zlevel_fall/beach
	var/static/target_z
