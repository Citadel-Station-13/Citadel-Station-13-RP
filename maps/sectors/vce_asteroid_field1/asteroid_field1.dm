/datum/map/sector/asteroid_field1
	id = "asteroidfield1"
	name = "Sector - Osiris Debris Field"
	width = 192
	height = 192
	levels = list(
		/datum/map_level/sector/asteroid_field1,
	)

/datum/map_level/sector/asteroid_field1
	id = "asteroidfield1"
	name = "Sector Crucis Expanse - Asteroid field Alpha"
	display_name = "Asteroid field Alpha"
	path = "maps/sectors/asteroid_field1/levels/asteroid_field1.dmm"
	base_turf = /turf/space
	base_area = /area/space

/datum/map_level/sector/asteroid_field1/on_loaded_immediate(z_index, list/datum/callback/additional_generation)
	. = ..()
	additional_generation?.Add(
		CALLBACK(
			GLOBAL_PROC,
			GLOBAL_PROC_REF(seed_submaps),
			list(z_index),
			200,
			/area/space,
			/datum/map_template/submap/level_specific/asteroidfield1,
		)
	)
