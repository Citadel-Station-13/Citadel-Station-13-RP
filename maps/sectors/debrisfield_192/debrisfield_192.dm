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

	injections = list(
		new /datum/map_injection/legacy_seed_submaps(
			200,
			/area/space/debrisfield/unexplored,
			/datum/map_template/submap/level_specific/debrisfield_vr,
		),
	)
