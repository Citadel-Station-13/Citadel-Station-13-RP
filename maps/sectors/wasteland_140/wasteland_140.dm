/datum/map/sector/wasteland_140
	id = "wasteland_140"
	name = "Sector - Moon Wastes (140x140)"
	width = 140
	height = 140
	levels = list(
		/datum/map_level/sector/wasteland_140,
	)

/datum/map_level/sector/wasteland_140
	id = "Wasteland140"
	name = "Sector - Moon Wastes (140x140)"
	display_name = "Class-D Moon Wastes"
	absolute_path = "maps/sectors/wasteland_140/levels/wasteland_140.dmm"
	base_turf = /turf/simulated/mineral/floor/classd
	planet_path = /datum/planet/classd

/datum/map_level/sector/wasteland_140/on_loaded_immediate(z_index, list/datum/callback/additional_generation)
	. = ..()
	additional_generation?.Add(
		CALLBACK(
			GLOBAL_PROC,
			GLOBAL_PROC_REF(seed_submaps),
			list(z_index),
			150,
			/area/class_d/unexplored,
			/datum/map_template/submap/level_specific/class_d,
		)
	)
