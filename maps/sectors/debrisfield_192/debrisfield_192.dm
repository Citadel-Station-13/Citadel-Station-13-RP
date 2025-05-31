/datum/map/sector/debrisfield_192
	id = "debrisfield_192"
	name = "Sector - Debris Field"
	width = 192
	height = 192
	levels = list(
		/datum/map_level/sector/debrisfield_192,
	)

/datum/map_level/sector/debrisfield_192
	id = "Debrisfield192"
	name = "Sector - Debris Field"
	display_name = "Debris Field"
	path = "maps/sectors/debrisfield_192/levels/debrisfield.dmm"
	base_turf = /turf/space
	base_area = /area/space

/datum/map_level/sector/debrisfield_192/on_loaded_immediate(z_index, list/datum/callback/out_generation_callbacks)
	. = ..()
	out_generation_callbacks?.Add(
		CALLBACK(
			GLOBAL_PROC,
			GLOBAL_PROC_REF(seed_submaps),
			list(z_index),
			200,
			/area/space/debrisfield/unexplored,
			/datum/map_template/submap/level_specific/debrisfield_vr,
		)
	)
