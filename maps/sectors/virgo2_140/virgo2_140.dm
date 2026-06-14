/datum/map/sector/virgo2_140
	id = "virgo2_140"
	name = "Sector - Virgo 2 (140x140)"
	width = 140
	height = 140
	levels = list(
		/datum/map_level/sector/virgo2_140/ground,
		/datum/map_level/sector/virgo2_140/aerostat,
	)

/datum/map_level/sector/virgo2_140
	air_outdoors = /datum/atmosphere/planet/virgo2

/datum/map_level/sector/virgo2_140/aerostat
	id = "Virgo2Aerostat140"
	name = "Sector - Virgo 2 Aerostat"
	display_name = "Remmi Aerostat"
	path = "maps/sectors/virgo2_140/levels/virgo2_140_aerostat.dmm"
	base_turf = /turf/simulated/sky/virgo2_sky

/datum/map_level/sector/virgo2_140/ground
	id = "Virgo2Ground140"
	name = "Sector - Virgo 2 Ground"
	display_name = "Remmi Ground Landing"
	path = "maps/sectors/virgo2_140/levels/virgo2_140_surface.dmm"
	base_turf = /turf/simulated/floor/outdoors/rocks

	injections = list(
		new /datum/map_injection/legacy_seed_submaps(
			150,
			/area/tether_away/aerostat/surface/unexplored,
			/datum/map_template/submap/level_specific/virgo2,
		),
	)
