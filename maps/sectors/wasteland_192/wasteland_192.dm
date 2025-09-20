/datum/map/sector/wasteland_192
	id = "wasteland_192"
	name = "Sector - Moon Wastes (192x192)"
	width = 192
	height = 192
	levels = list(
		/datum/map_level/sector/wasteland_192,
	)

/datum/map_level/sector/wasteland_192
	id = "Wasteland192"
	name = "Sector - Moon Wastes (192x192)"
	display_name = "Class-D Moon Wastes"
	path = "maps/sectors/wasteland_192/levels/wasteland_192.dmm"
	base_turf = /turf/simulated/mineral/floor/classd
	planet_path = /datum/planet/classd

/datum/map_level/sector/wasteland_192/on_loaded_immediate(z_index, list/datum/callback/out_generation_callbacks)
	. = ..()
	out_generation_callbacks?.Add(
		CALLBACK(
			GLOBAL_PROC,
			GLOBAL_PROC_REF(seed_submaps),
			list(z_index),
			150,
			/area/class_d/unexplored,
			/datum/map_template/submap/level_specific/class_d,
		)
	)
