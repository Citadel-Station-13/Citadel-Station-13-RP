/datum/map/sector/virgo4_140
	id = "virgo4_140"
	name = "Sector - Virgo 4"
	width = 140
	height = 140
	levels = list(
		/datum/map_level/sector/virgo4_140/beach,
		/datum/map_level/sector/virgo4_140/cave,
		/datum/map_level/sector/virgo4_140/desert,
	)

/datum/map_level/sector/virgo4_140
	base_turf = /turf/simulated/floor/outdoors/beach/sand/desert
	traits = list(
		ZTRAIT_GRAVITY,
	)
	planet_path = /datum/planet/virgo4

/datum/map_level/sector/virgo4_140/beach
	id = "Virgo4Beach140"
	name = "Sector - Virgo 4: Beach"
	display_name = "Virgo 4 - Beach"
	absolute_path = "maps/sectors/virgo4_140/levels/virgo4_140_beach.dmm"
	base_turf = /turf/simulated/floor/outdoors/beach/sand
	link_north = /datum/map_level/sector/virgo4_140/cave

/datum/map_level/sector/virgo4_140/cave
	id = "Virgo4Caves140"
	name = "Sector - Virgo 4: Caves"
	display_name = "Virgo 4 - Caves"
	absolute_path = "maps/sectors/virgo4_140/levels/virgo4_140_cave.dmm"
	base_turf = /turf/simulated/floor/outdoors/rocks/caves
	link_south = /datum/map_level/sector/virgo4_140/beach
	link_west = /datum/map_level/sector/virgo4_140/desert

/datum/map_level/sector/virgo4_140/cave/on_loaded_immediate(z_index, list/datum/callback/additional_generation)
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
	new /datum/random_map/noise/ore/beachmine(null, 1, 1, z_index, 64, 64)

/datum/map_level/sector/virgo4_140/desert
	id = "Virgo4Desert140"
	name = "Sector - Virgo 4: Desert"
	display_name = "Virgo 4 - Desert"
	absolute_path = "maps/sectors/virgo4_140/levels/virgo4_140_desert.dmm"
	base_turf = /turf/simulated/floor/outdoors/beach/sand/lowdesert
	link_east = /datum/map_level/sector/virgo4_140/cave

/datum/map_level/sector/virgo4_140/desert/on_loaded_immediate(z_index, list/datum/callback/additional_generation)
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
