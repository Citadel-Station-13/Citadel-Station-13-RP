/datum/map/sector/gaia_140
	id = "gaia_140"
	name = "Sector - Gaia World"
	width = 140
	height = 140
	levels = list(
		/datum/map_level/sector/gaia_140,
	)

/datum/map_level/sector/gaia_140
	id = "GaiaWorld140"
	name = "Sector - Gaia World"
	display_name = "Class-M Gaia World"
	absolute_path = "maps/sectors/gaia_140/levels/gaia_140.dmm"
	base_turf = /turf/simulated/floor/outdoors/dirt/classm
	base_area = /area/class_m/outside
	traits = list(
		ZTRAIT_GRAVITY,
	)
	planet_path = /datum/planet/classm
