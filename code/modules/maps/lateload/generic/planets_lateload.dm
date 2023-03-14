/**
 *! Overmap Planet Templates
 *? This is for planets that are accessible from the overmap.
 */

//////////////////////////////////////////////
/// Class G Mining Planet Exploration Zone ///
//////////////////////////////////////////////


/datum/map_template/lateload/planets/away_g_world
	name = "ExoPlanet - Z1 Planet"
	desc = "A mineral rich planet."
	mappath = "_maps/map_levels/192x192/Class_G.dmm"
	associated_map_datum = /datum/map_z_level/planets_lateload/away_g_world
	ztraits = list(ZTRAIT_AWAY = TRUE, ZTRAIT_GRAVITY = TRUE)

/datum/map_z_level/planets_lateload/away_g_world
	name = "Away Mission - Mining Planet"
	base_turf = /turf/simulated/mineral/floor/classg

/datum/map_template/lateload/planets/away_g_world/on_map_loaded(z)
	. = ..()
	new /datum/random_map/automata/cave_system/no_cracks(null, 1, 1, z, world.maxx - 4, world.maxy - 4) // Create the mining Z-level.
	new /datum/random_map/noise/ore/classg(null, 1, 1, z, 64, 64)         // Create the mining ore distribution map.

/////////////////////////////////////////////
/// Class D Rogue Planet Exploration Zone.///
/////////////////////////////////////////////

/datum/map_template/lateload/planets/away_d_world
	name = "ExoPlanet - Z2 Planet"
	desc = "The previously nuked planet Class D away mission"
	mappath = "_maps/map_levels/192x192/Class_D.dmm"
	associated_map_datum = /datum/map_z_level/planets_lateload/away_d_world
	ztraits = list(ZTRAIT_AWAY = TRUE, ZTRAIT_GRAVITY = TRUE)

/datum/map_template/lateload/planets/away_d_world/on_map_loaded(z)
	. = ..()
	seed_submaps(list(z), 150, /area/class_d/unexplored, /datum/map_template/submap/level_specific/class_d)

	//new /datum/random_map/automata/cave_system/no_cracks(null, 3, 3, Z_LEVEL_UNKNOWN_PLANET, world.maxx - 30, world.maxy - 30)
	//new /datum/random_map/noise/ore/poi_d(null, 1, 1, Z_LEVEL_UNKNOWN_PLANET, 64, 64)

/datum/map_z_level/planets_lateload/away_d_world
	name = "Away Mission - Rogue Planet"
	base_turf = /turf/simulated/mineral/floor/classd

//////////////////////////////////////////////
/// Class H Desert Planet Exploration Zone.///
//////////////////////////////////////////////

/datum/map_template/lateload/planets/away_h_world
	name = "ExoPlanet - Z3 Planet"
	desc = "A random unknown planet."
	mappath = "_maps/map_levels/192x192/Class_H.dmm"
	associated_map_datum = /datum/map_z_level/planets_lateload/away_h_world
	ztraits = list(ZTRAIT_AWAY = TRUE, ZTRAIT_GRAVITY = TRUE)

/datum/map_template/lateload/planets/away_h_world/on_map_loaded(z)
	. = ..()
	seed_submaps(list(z), 150, /area/class_h/unexplored, /datum/map_template/submap/level_specific/class_h)

	//new /datum/random_map/automata/cave_system/no_cracks(null, 3, 3, Z_LEVEL_UNKNOWN_PLANET, world.maxx - 30, world.maxy - 30)
	//new /datum/random_map/noise/ore/poi_d(null, 1, 1, Z_LEVEL_UNKNOWN_PLANET, 64, 64)

/datum/map_z_level/planets_lateload/away_h_world
	name = "Away Mission - Desert Planet"
	base_turf = /turf/simulated/floor/outdoors/beach/sand/lowdesert

/////////////////////////
/// Gaia Planet Zone. ///
/////////////////////////

/datum/map_template/lateload/planets/away_m_world
	name = "ExoPlanet - Z4 Planet"
	desc = "A lush Gaia Class Planet."
	mappath = "_maps/map_levels/192x192/Class_M.dmm"
	associated_map_datum = /datum/map_z_level/planets_lateload/away_m_world
	ztraits = list(ZTRAIT_AWAY = TRUE, ZTRAIT_GRAVITY = TRUE)

/datum/map_template/lateload/planets/away_m_world/on_map_loaded(z)
	. = ..()
//	seed_submaps(list(Z_LEVEL_DESERT_PLANET), 150, /area/poi_h/unexplored, /datum/map_template/submap/level_specific/class_h)

	//new /datum/random_map/automata/cave_system/no_cracks(null, 3, 3, Z_LEVEL_UNKNOWN_PLANET, world.maxx - 30, world.maxy - 30)
	//new /datum/random_map/noise/ore/poi_d(null, 1, 1, Z_LEVEL_UNKNOWN_PLANET, 64, 64)

/datum/map_z_level/planets_lateload/away_m_world
	name = "Away Mission - Gaia Planet"
	base_turf = /turf/simulated/floor/outdoors/dirt/classm

///////////////////////////
/// Frozen Planet Zone. ///
///////////////////////////

/datum/map_template/lateload/planets/away_p_world
	name = "ExoPlanet - Z5 Planet"
	desc = "A Cold Frozen Planet."
	mappath = "_maps/map_levels/192x192/Class_P.dmm"
	associated_map_datum = /datum/map_z_level/planets_lateload/away_p_world
	ztraits = list(ZTRAIT_AWAY = TRUE, ZTRAIT_GRAVITY = TRUE)

/datum/map_template/lateload/planets/away_p_world/on_map_loaded(z)
	. = ..()
	seed_submaps(list(z), 125, /area/class_p/ruins, /datum/map_template/submap/level_specific/class_p)


/datum/map_z_level/planets_lateload/away_p_world
	name = "Away Mission - Frozen Planet"
	base_turf = /turf/simulated/floor/outdoors/ice/classp

/////////////////////////////////
/// Miaphus'irra (Formerly V4) - Beach and caves ///
/////////////////////////////////

/datum/map_template/lateload/planets/away_beach
	name = "Desert Planet - Z1 Beach"
	desc = "The beach away mission."
	mappath = "_maps/map_levels/192x192/miaphus_beach.dmm"
	associated_map_datum = /datum/map_z_level/planets_lateload/away_beach

/datum/map_z_level/planets_lateload/away_beach
	name = "Away Mission - Desert Beach"
	base_turf = /turf/simulated/floor/outdoors/rocks/caves

/datum/map_template/lateload/planets/away_beach_cave
	name = "Desert Planet - Z2 Cave"
	desc = "The beach away mission's cave."
	mappath = "_maps/map_levels/192x192/miaphus_cave.dmm"
	associated_map_datum = /datum/map_z_level/planets_lateload/away_beach_cave

/datum/map_template/lateload/planets/away_beach_cave/on_map_loaded(z)
	. = ..()
	seed_submaps(list(z), 225, /area/tether_away/cave/unexplored/normal, /datum/map_template/submap/level_specific/mountains/normal)
	//seed_submaps(list(z), 70, /area/tether_away/cave/unexplored/normal, /datum/map_template/submap/level_specific/mountains/deep)

	// Now for the tunnels.
	new /datum/random_map/automata/cave_system/no_cracks(null, 3, 3, z, world.maxx - 4, world.maxy - 4)
	new /datum/random_map/noise/ore/beachmine(null, 1, 1, z, 64, 64)

/datum/map_z_level/planets_lateload/away_beach_cave
	name = "Away Mission - Desert Cave"
	base_turf = /turf/simulated/floor/outdoors/rocks/caves

/datum/map_template/lateload/planets/away_desert
	name = "Desert Planet - Z3 Desert"
	desc = "The inland desert of V-4."
	mappath = "_maps/map_levels/192x192/miaphus_desert.dmm"
	associated_map_datum = /datum/map_template/submap/level_specific/class_h

/datum/map_template/lateload/planets/away_desert/on_map_loaded(z)
	. = ..()
	seed_submaps(list(z), 225, /area/tether_away/beach/desert/unexplored, /datum/map_template/submap/level_specific/class_h)

/datum/map_z_level/planets_lateload/away_desert
	name = "Away Mission - Desert"
	base_turf = /turf/simulated/floor/outdoors/beach/sand/lowdesert


/obj/effect/step_trigger/zlevel_fall/beach
	var/static/target_z

///////////////
/// Virgo 2 ///
///////////////

/datum/map_template/lateload/planets/away_aerostat
	name = "Remmi Aerostat - Z1 Aerostat"
	desc = "The Virgo 2 Aerostat away mission."
	mappath = "_maps/map_levels/140x140/virgo2_aerostat.dmm"
	associated_map_datum = /datum/map_z_level/planets_lateload/away_aerostat

/datum/map_z_level/planets_lateload/away_aerostat
	name = "Away Mission - Aerostat"
	base_turf = /turf/simulated/floor/sky/virgo2_sky

/datum/map_template/lateload/planets/away_aerostat_surface
	name = "Remmi Aerostat - Z2 Surface"
	desc = "The surface from the Virgo 2 Aerostat."
	mappath = "_maps/map_levels/140x140/virgo2_surface.dmm"
	associated_map_datum = /datum/map_z_level/planets_lateload/away_aerostat_surface

/datum/map_template/lateload/planets/away_aerostat_surface/on_map_loaded(z)
	. = ..()
	seed_submaps(list(z), 150, /area/tether_away/aerostat/surface/unexplored, /datum/map_template/submap/level_specific/virgo2)
	new /datum/random_map/automata/cave_system/no_cracks(null, 3, 3, z, world.maxx - 4, world.maxy - 4)
	new /datum/random_map/noise/ore/virgo2(null, 1, 1, z, 64, 64)

/datum/map_z_level/planets_lateload/away_aerostat_surface
	name = "Away Mission - Aerostat Surface"
	base_turf = /turf/simulated/mineral/floor/ignore_mapgen/virgo2

