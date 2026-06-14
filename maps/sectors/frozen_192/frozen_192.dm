/datum/map/sector/frozen_192
	id = "frozen_192"
	name = "Sector - Frozen World"
	width = 192
	height = 192
	levels = list(
		/datum/map_level/sector/frozen_192,
	)

/datum/map_level/sector/frozen_192
	id = "FrozenWorld192"
	name = "Sector - Frozen World"
	display_name = "Class-P Frozen World"
	path = "maps/sectors/frozen_192/levels/frozen_192.dmm"
	base_area = /area/class_p/ruins
	base_turf = /turf/simulated/floor/outdoors/ice
	traits = list(
		ZTRAIT_GRAVITY,
	)
	planet_path = /datum/planet/classp
	air_outdoors = /datum/atmosphere/planet/classp

	injections = list(
		new /datum/map_injection/legacy_seed_submaps(
			125,
			/area/class_p/ruins/unexplored,
			/datum/map_template/submap/level_specific/class_p,
		),
	)

