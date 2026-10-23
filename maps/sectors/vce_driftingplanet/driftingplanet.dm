/datum/map/sector/drifting_planet
	id = "driftingplanet"
	name = "Sector - Drifting Planet"
	width = 192
	height = 192
	levels = list(
		/datum/map_level/sector/drifting_planet,
	)

/datum/map_level/sector/drifting_planet
	id = "driftingplanet"
	name = "Sector Crucis Expanse - Asteroid field Alpha"
	display_name = "Asteroid field Alpha"
	path = "maps/sectors/vce_driftingplanet/levels/driftingplanet.dmm"
	base_turf = /turf/simulated/floor/outdoors/beach/sand/desert
	base_area = /area/sector/driftingplanet/field

	planet_path = /datum/planet/driftingplanet
	air_outdoors = /datum/atmosphere/planet/driftingplanet
