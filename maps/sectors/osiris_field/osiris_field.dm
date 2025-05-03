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
	name = "Sector - Osiris Debris Field West"
	display_name = "Osiris Debris Field West"
	path = "maps/sectors/osiris_field/levels/osiris_field_1.dmm"
	base_turf = /turf/space
	base_area = /area/space
	link_east = /datum/map_level/sector/osiris_field2

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

	/datum/map_level/sector/osiris_field2
	id = "Osirisfield2"
	name = "Sector - Osiris Debris Field East"
	display_name = "Osiris Debris Field East"
	path = "maps/sectors/osiris_field/levels/osiris_field_2.dmm"
	base_turf = /turf/space
	base_area = /area/space
	link_west = /datum/map_level/sector/osiris_field

/datum/map_level/sector/osiris_field2/on_loaded_immediate(z_index, list/datum/callback/additional_generation)
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
