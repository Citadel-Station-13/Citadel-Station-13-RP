/datum/map/sector/debrisfield_140
	id = "debrisfield_140"
	name = "Sector - Debris Field"
	width = 140
	height = 140
	levels = list(
		/datum/map_level/sector/debrisfield_140,
	)

/datum/map_level/sector/debrisfield_140
	id = "Debrisfield140"
	name = "Sector - Debris Field"
	display_name = "Debris Field"
	absolute_path = "maps/sectors/debrisfield_140/levels/debrisfield.dmm"
	base_turf = /turf/space
	base_area = /area/space

/datum/map_level/sector/debrisfield_140/on_loaded_immediate(z_index, list/datum/callback/additional_generation)
	. = ..()
	additional_generation?.Add(
		CALLBACK(
			GLOBAL_PROC,
			GLOBAL_PROC_REF(seed_submaps),
			list(z_index),
			20,
			/area/space/debrisfield/unexplored,
			/datum/map_template/submap/level_specific/debrisfield,
		)
	)
