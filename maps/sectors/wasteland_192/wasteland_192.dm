/datum/map_template/lateload/planets/away_d_world
	name = "ExoPlanet - Z2 Planet"
	desc = "The previously nuked planet Class D away mission"
	mappath = "maps/map_levels/192x192/Class_D.dmm"
	associated_map_datum = /datum/map_level/planets_lateload/away_d_world
	ztraits = list(ZTRAIT_AWAY = TRUE, ZTRAIT_GRAVITY = TRUE)

/datum/map_template/lateload/planets/away_d_world/on_map_loaded(z)
	. = ..()
	seed_submaps(list(z), 150, /area/class_d/unexplored, /datum/map_template/submap/level_specific/class_d)

	//new /datum/random_map/automata/cave_system/no_cracks(null, 3, 3, Z_LEVEL_UNKNOWN_PLANET, world.maxx - 30, world.maxy - 30)
	//new /datum/random_map/noise/ore/poi_d(null, 1, 1, Z_LEVEL_UNKNOWN_PLANET, 64, 64)

/datum/map_level/planets_lateload/away_d_world
	name = "Away Mission - Rogue Planet"
	base_turf = /turf/simulated/mineral/floor/classd

#warn translate
