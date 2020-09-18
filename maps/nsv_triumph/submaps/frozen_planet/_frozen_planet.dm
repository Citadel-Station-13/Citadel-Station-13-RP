// POI Init
/obj/away_mission_init/frozen_planet
	name = "away mission initializer -  Gaia Planet"

/obj/away_mission_init/frozen_planet/Initialize()
	return INITIALIZE_HINT_QDEL

// Mining Planet world areas
/area/triumph_away/frozen_planet
	name = "Frozen Planet"
	icon_state = "away"
	base_turf = /turf/simulated/floor/outdoors/dirt
	requires_power = 0
	dynamic_lighting = 1

/area/triumph_away/frozen_planet/facility
	name = "Gaia Planet - Facility"
	requires_power = 1
	icon_state = "red"

/area/triumph_away/frozen_planet/ruins
	name = "Gaia Planet - Ruins"
	icon_state = "green"

/area/triumph_away/frozen_planet/outside
	name = "Gaia Planet - Outside (UE)"
	icon_state = "yellow"
