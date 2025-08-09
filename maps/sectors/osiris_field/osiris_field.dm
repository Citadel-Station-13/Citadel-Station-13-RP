/datum/map/sector/osiris_field
	id = "osirisfield"
	name = "Sector - Osiris Debris Field"
	width = 192
	height = 192
	levels = list(
		/datum/map_level/sector/osiris_field,
	)

/datum/map_level/sector/osiris_field
	id = "Osirisfield1"
	name = "Sector - Osiris Debris field"
	display_name = "Osiris Debris Field"
	path = "maps/sectors/osiris_field/levels/osiris_field.dmm"
	base_turf = /turf/space
	base_area = /area/space

/datum/map_level/sector/osiris_field/on_loaded_immediate(z_index, list/datum/callback/additional_generation)
	. = ..()
	additional_generation?.Add(
		CALLBACK(
			GLOBAL_PROC,
			GLOBAL_PROC_REF(seed_submaps),
			list(z_index),
			200,
			/area/space/osirisdebrisfield/unexplored,
			/datum/map_template/submap/level_specific/osirisfield,
		)
	)


