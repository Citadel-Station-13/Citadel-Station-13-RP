/datum/map_template/lateload/planets/away_g_world
	name = "ExoPlanet - Z1 Planet"
	desc = "A mineral rich planet."
	mappath = "maps/map_levels/192x192/Class_G.dmm"
	associated_map_datum = /datum/map_level/planets_lateload/away_g_world
	ztraits = list(ZTRAIT_AWAY = TRUE, ZTRAIT_GRAVITY = TRUE)

/datum/map_level/planets_lateload/away_g_world
	name = "Away Mission - Mining Planet"
	base_turf = /turf/simulated/mineral/floor/classg

/datum/map_template/lateload/planets/away_g_world/on_map_loaded(z)
	. = ..()
	new /datum/random_map/automata/cave_system/no_cracks(null, 1, 1, z, world.maxx - 4, world.maxy - 4) // Create the mining Z-level.
	new /datum/random_map/noise/ore/classg(null, 1, 1, z, 64, 64)         // Create the mining ore distribution map.

#warn translate

