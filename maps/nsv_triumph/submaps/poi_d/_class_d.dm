// Shuttle Path for Class D Worlds

// -- Datums -- //
/*/obj/effect/overmap/visitable/sector/class_d
	name = "Unknown Planet"			// The name of the destination
	desc = "Sensors indicate that this is a Class-D World.  Those of which are largely barren planets or moons that lack any form of atmosphere and are among the most common types of planets."
	icon_state = "globe"
	color = "#4e4e4e"	// Bright yellow
	initial_generic_waypoints = list("poid_main")
*/
// POI Init
/obj/away_mission_init/poi_d
	name = "away mission initializer -  Class D World"

/obj/away_mission_init/poi_d/Initialize(mapload)
	return INITIALIZE_HINT_QDEL
