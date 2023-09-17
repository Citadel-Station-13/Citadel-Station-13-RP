/datum/map/sector/gaia_192
	id = "gaia_192"
	name = "Sector - Gaia World"
	width = 192
	height = 192
	levels = list(
		/datum/map_level/sector/gaia_192,
	)

/datum/map_level/sector/gaia_192
	id = "GaiaWorld192"
	name = "Sector - Gaia World"
	display_name = "Class-M Gaia World"
	absolute_path = "maps/sectors/gaia_192/levels/gaia_192.dmm"
	base_turf = /turf/simulated/floor/outdoors/dirt/classm
	base_area = /area/class_m/outside
	traits = list(
		ZTRAIT_GRAVITY,
	)
	planet_path = /datum/planet/classm
