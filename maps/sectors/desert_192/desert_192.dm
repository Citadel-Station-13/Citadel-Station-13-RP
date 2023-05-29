/datum/map/sector/desert_192
	id = "desert_192"
	name = "Sector - Desert World"
	width = 192
	height = 192
	levels = list(
		/datum/map_level/sector/desert_192
	)

/datum/map_level/sector/desert_192
	id = "DesertWorld192"
	name = "Sector - Desert World"
	display_name = "Class-H Desert World"
	absolute_path = "maps/sectors/desert_192/levels/desert_192.dmm"
	base_turf = /turf/simulated/floor/outdoors/beach/sand/lowdesert
	base_area = /area/class_h/unexplored
	traits = list(
		ZTRAIT_GRAVITY,
	)

/datum/map_level/sector/desert_192/on_loaded_immediate(z_index, list/datum/callback/additional_generation)
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
