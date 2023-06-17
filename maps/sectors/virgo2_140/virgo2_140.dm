/datum/map/sector/virgo2
	id = "virgo2_140"
	name = "Sector - Virgo 2 (140x140)"
	width = 140
	height = 140
	levels = list(
		/datum/map_level/sector/virgo2/ground,
		/datum/map_level/sector/virgo2/aerostat,
	)

/datum/map_level/sector/virgo2
	planet_path = /datum/planet/virgo2
	air_outdoors = /datum/atmosphere/planet/virgo2

/datum/map_level/sector/virgo2/aerostat
	id = "Virgo2Aerostat140"
	name = "Sector - Virgo 2 Aerostat"
	display_name = "Remmi Aerostat"
	absolute_path = "maps/sectors/virgo2_140/levels/virgo2_140_aerostat.dmm"
	base_turf = /turf/simulated/floor/sky/virgo2_sky

/datum/map_level/sector/virgo2/ground
	id = "Virgo2Ground140"
	name = "Sector - Virgo 2 Ground"
	display_name = "Remmi Ground Landing"
	absolute_path = "maps/sectors/virgo2_140/levels/virgo2_140_ground.dmm"
	base_turf = /turf/simulated/floor/outdoors/rocks

/datum/map_level/sector/virgo2/ground/on_loaded_immediate(z_index, list/datum/callback/additional_generation)
	. = ..()
	additional_generation?.Add(
		CALLBACK(
			GLOBAL_PROC,
			GLOBAL_PROC_REF(seed_submaps),
			list(z_index),
			150,
			/area/tether_away/aerostat/surface/unexplored,
			/datum/map_template/submap/level_specific/virgo2,
		)
	)
