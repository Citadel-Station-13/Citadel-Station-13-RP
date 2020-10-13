// POI Init
/obj/away_mission_init/gaia_planet
	name = "away mission initializer -  Gaia Planet"

/obj/away_mission_init/gaia_planet/Initialize()
	return INITIALIZE_HINT_QDEL

// Mining Planet world areas
/area/triumph_away/gaia_planet
	name = "Gaia Planet"
	icon_state = "away"
	base_turf = /turf/simulated/floor/outdoors/dirt
	requires_power = 0
	dynamic_lighting = 1

/area/triumph_away/gaia_planet/inside
	name = "Gaia Planet - Inside (E)"
	icon_state = "red"

/area/triumph_away/gaia_planet/outside
	name = "Gaia Planet - Outside (UE)"
	icon_state = "yellow"
