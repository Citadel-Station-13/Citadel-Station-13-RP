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

/obj/away_mission_init/poi_d/Initialize()
	return INITIALIZE_HINT_QDEL

// Class D world areas
/area/triumph_away/poi_d
	name = "Class D World"
	icon_state = "away"
	base_turf = /turf/simulated/mineral/floor/vacuum
	dynamic_lighting = 0
	dynamic_lighting = FALSE

/area/triumph_away/poi_d/plains
	name = "Class D World Plains"
	base_turf = /turf/simulated/mineral/floor/vacuum
	dynamic_lighting = 0

/area/triumph_away/poi_d/crater
	name = "Class D World Crater"
	base_turf = /turf/simulated/mineral/floor/vacuum
	dynamic_lighting = 0

/area/triumph_away/poi_d/Mountain
	name = "Class D World Mountain"
	base_turf = /turf/simulated/mineral/floor/vacuum
	dynamic_lighting = 0

/area/triumph_away/poi_d/Crevices
	name = "Class D World Crevices"
	base_turf = /turf/simulated/mineral/floor/vacuum
	dynamic_lighting = 0

/area/triumph_away/poi_d/POIs/solar_farm
	name = "Prefab Solar Farm"
	base_turf = /turf/simulated/mineral/floor/vacuum

/area/triumph_away/poi_d/POIs/landing_pad
	name = "Prefab Homestead"
	base_turf = /turf/simulated/mineral/floor/vacuum
	requires_power = FALSE

/area/triumph_away/poi_d/POIs/reactor
	name = "Prefab Reactor"
	base_turf = /turf/simulated/mineral/floor/vacuum

/area/triumph_away/poi_d/POIs/ship
	name = "Crashed Ship Fragment"
	base_turf = /turf/simulated/mineral/floor/vacuum

/area/triumph_away/poi_d/explored
	name = "Class D World - Explored (E)"
	icon_state = "explored"

/area/triumph_away/poi_d/unexplored
	name = "Class D World - Unexplored (UE)"
	icon_state = "unexplored"

// This is a special subtype of the thing that generates ores on a map
// It will generate more rich ores because of the lower numbers than the normal one
/datum/random_map/noise/ore/poi_d
	descriptor = "Mining planet mine ore distribution map"
	deep_val = 0.5 //More riches, normal is 0.7 and 0.8
	rare_val = 0.2

// The check_map_sanity proc is sometimes unsatisfied with how AMAZING our ores are
/datum/random_map/noise/ore/poi_d/check_map_sanity()
	var/rare_count = 0
	var/surface_count = 0
	var/deep_count = 0

	// Increment map sanity counters.
	for(var/value in map)
		if(value < rare_val)
			surface_count++
		else if(value < deep_val)
			rare_count++
		else
			deep_count++
	// Sanity check.
	if(surface_count < 100)
		admin_notice("<span class='danger'>Insufficient surface minerals. Rerolling...</span>", R_DEBUG)
		return 0
	else if(rare_count < 50)
		admin_notice("<span class='danger'>Insufficient rare minerals. Rerolling...</span>", R_DEBUG)
		return 0
	else if(deep_count < 50)
		admin_notice("<span class='danger'>Insufficient deep minerals. Rerolling...</span>", R_DEBUG)
		return 0
	else
		return 1