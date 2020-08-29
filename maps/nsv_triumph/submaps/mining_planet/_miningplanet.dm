// Shuttle Path for Mining Planet

// -- Datums -- //
/*/obj/effect/overmap/visitable/sector/mining_planet
	name = "Mineral Rich Planet"			// The name of the destination
	desc = "Sensors indicate that this is a world filled with minerals.  There seems to be a thin atmosphere on the planet."
	icon_state = "globe"
	color = "#4e4e4e"	// Bright yellow
	initial_generic_waypoints = list("poid_main")
*/
// POI Init
/obj/away_mission_init/mining_planet
	name = "away mission initializer -  Mining Planet"

/obj/away_mission_init/mining_planet/Initialize()
	return INITIALIZE_HINT_QDEL

// Class D world areas
/area/triumph_away/mining_planet
	name = "Mining Planet"
	icon_state = "away"
	base_turf = /turf/simulated/mineral/floor/
	dynamic_lighting = 1
	dynamic_lighting = TRUE

/area/triumph_away/mining_planet/explored
	name = "Mining Planet - Explored (E)"
	icon_state = "red"
	forced_ambience = list('sound/ambience/tension/tension.ogg', 'sound/ambience/tension/horror.ogg')

/area/triumph_away/mining_planet/unexplored
	name = "Mining Planet - Unexplored (UE)"
	icon_state = "yellow"
