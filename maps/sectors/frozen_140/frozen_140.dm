/datum/map/sector/frozen_140
	id = "frozen_140"
	name = "Sector - Frozen World"
	width = 140
	height = 140
	levels = list(
		/datum/map_level/sector/frozen_140,
	)

/datum/map_level/sector/frozen_140
	id = "FrozenWorld140"
	name = "Sector - Frozen World"
	display_name = "Class-P Frozen World"
	absolute_path = "maps/sectors/frozen_140/levels/frozen_140.dmm"
	base_area = /area/class_p/ruins
	base_turf = /turf/simulated/floor/outdoors/ice/classp
	traits = list(
		ZTRAIT_GRAVITY,
	)
	planet_path = /datum/planet/classp

/datum/map_level/sector/frozen_140/on_loaded_immediate(z_index, list/datum/callback/additional_generation)
	. = ..()
	additional_generation?.Add(
		CALLBACK(
			GLOBAL_PROC,
			GLOBAL_PROC_REF(seed_submaps),
			list(z_index),
			125,
			/area/class_p/ruins,
			/datum/map_template/submap/level_specific/class_p,
		)
	)
