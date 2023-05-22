/datum/map_template/lateload/planets/away_p_world
	name = "ExoPlanet - Z5 Planet"
	desc = "A Cold Frozen Planet."
	mappath = "maps/map_levels/192x192/Class_P.dmm"
	associated_map_datum = /datum/map_level/planets_lateload/away_p_world
	ztraits = list(ZTRAIT_AWAY = TRUE, ZTRAIT_GRAVITY = TRUE)

/datum/map_template/lateload/planets/away_p_world/on_map_loaded(z)
	. = ..()
	seed_submaps(list(z), 125, /area/class_p/ruins, /datum/map_template/submap/level_specific/class_p)


/datum/map_level/planets_lateload/away_p_world
	name = "Away Mission - Frozen Planet"
	base_turf = /turf/simulated/floor/outdoors/ice/classp

#warn translate
