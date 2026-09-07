/datum/map/sector/asteroid_field2
	id = "asteroidfield2"
	name = "Sector - Asteroid Field Delta"
	width = 192
	height = 192
	levels = list(
		/datum/map_level/sector/asteroid_field2,
	)

/datum/map_level/sector/asteroid_field2
	id = "asteroidfield2"
	name = "Sector Crucis Expanse - Asteroid field Delta"
	display_name = "Asteroid field Delta"
	path = "maps/sectors/asteroid_field2/levels/asteroid_field2.dmm"
	base_turf = /turf/space
	base_area = /area/space

/datum/map_level/sector/asteroid_field2/on_loaded_immediate(z_index, list/datum/callback/additional_generation)
	. = ..()
	additional_generation?.Add(
		CALLBACK(
			GLOBAL_PROC,
			GLOBAL_PROC_REF(seed_submaps),
			list(z_index),
			200,
			/area/space,
			/datum/map_template/submap/level_specific/asteroidfield2,
		)
	)
