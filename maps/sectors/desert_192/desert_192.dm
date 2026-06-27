/datum/map/sector/desert_192
	id = "desert_192"
	name = "Sector - Desert World"
	width = 192
	height = 192
	levels = list(
		/datum/map_level/sector/desert_192
	)

/datum/map_level/sector/desert_192
	id = "DesertWorld192"
	name = "Sector - Desert World"
	display_name = "Class-H Desert World"
	path = "maps/sectors/desert_192/levels/desert_192.dmm"
	base_turf = /turf/simulated/floor/outdoors/beach/sand/lowdesert
	base_area = /area/sector/class_h/unexplored
	traits = list(
		ZTRAIT_GRAVITY,
	)
	planet_path = /datum/planet/classh
	air_outdoors = /datum/atmosphere/planet/classh

	injections = list(
		new /datum/map_injection/legacy_seed_submaps(
			150,
			/area/sector/class_h/unexplored,
			/datum/map_template/submap/level_specific/class_h,
		),
	)
