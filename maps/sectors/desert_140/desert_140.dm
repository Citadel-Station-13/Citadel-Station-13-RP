/datum/map/sector/desert_140
	id = "desert_140"
	name = "Sector - Desert World"
	width = 140
	height = 140
	levels = list(
		/datum/map_level/sector/desert_140
	)

/datum/map_level/sector/desert_140
	id = "DesertWorld140"
	name = "Sector - Desert World"
	display_name = "Class-H Desert World"
	absolute_path = "maps/sectors/desert_140/levels/desert_140.dmm"
	base_turf = /turf/simulated/floor/outdoors/beach/sand/lowdesert
	base_area = /area/class_h/unexplored
	traits = list(
		ZTRAIT_GRAVITY,
	)
	planet_path = /datum/planet/classh

/datum/map_level/sector/desert_140/on_loaded_immediate(z_index, list/datum/callback/additional_generation)
	. = ..()
	additional_generation?.Add(
		CALLBACK(
			GLOBAL_PROC,
			GLOBAL_PROC_REF(seed_submaps),
			list(z_index),
			150,
			/area/class_h/unexplored,
			/datum/map_template/submap/level_specific/class_h,
		)
	)
