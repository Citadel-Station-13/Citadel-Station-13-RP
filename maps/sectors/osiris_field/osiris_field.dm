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

	injections = list(
		new /datum/map_injection/legacy_seed_submaps(
			200,
			/area/space/osirisdebrisfield/unexplored,
			/datum/map_template/submap/level_specific/osirisfield,
		),
	)
