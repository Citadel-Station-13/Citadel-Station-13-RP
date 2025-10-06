/datum/map/sector/gaia_192
	id = "gaia_192"
	name = "Sector - Gaia Station"
	width = 192
	height = 192
	levels = list(
		/datum/map_level/sector/gaia_192,
	)

/datum/map_level/sector/gaia_192
	id = "GaiaWorld192"
	name = "Sector - Gaia Station"
	display_name = "Gaia Station"
	path = "maps/sectors/gaia_192/levels/gaia_192.dmm"
	base_turf = /turf/simulated/floor
	base_area = /area/class_m/outside
	traits = list(
		ZTRAIT_GRAVITY,
	)
	planet_path = /datum/planet/classm
	air_outdoors = /datum/atmosphere/planet/classm
