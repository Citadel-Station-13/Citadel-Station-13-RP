///////////////
/// Virgo 2 ///
///////////////

/datum/map_template/lateload/planets/away_aerostat
	name = "Remmi Aerostat - Z1 Aerostat"
	desc = "The Virgo 2 Aerostat away mission."
	map_path = "maps/map_levels/140x140/virgo2_aerostat.dmm"
	associated_map_datum = /datum/map_level/planets_lateload/away_aerostat

/datum/map_level/planets_lateload/away_aerostat
	name = "Away Mission - Aerostat"
	base_turf = /turf/simulated/floor/sky/virgo2_sky

/datum/map_template/lateload/planets/away_aerostat_surface
	name = "Remmi Aerostat - Z2 Surface"
	desc = "The surface from the Virgo 2 Aerostat."
	map_path = "maps/map_levels/140x140/virgo2_surface.dmm"
	associated_map_datum = /datum/map_level/planets_lateload/away_aerostat_surface

/datum/map_template/lateload/planets/away_aerostat_surface/on_map_loaded(z)
	. = ..()
	seed_submaps(list(z), 150, /area/tether_away/aerostat/surface/unexplored, /datum/map_template/submap/level_specific/virgo2)
	new /datum/random_map/automata/cave_system/no_cracks(null, 3, 3, z, world.maxx - 4, world.maxy - 4)
	new /datum/random_map/noise/ore/virgo2(null, 1, 1, z, 64, 64)

/datum/map_level/planets_lateload/away_aerostat_surface
	name = "Away Mission - Aerostat Surface"
	base_turf = /turf/simulated/mineral/floor/ignore_mapgen/virgo2

