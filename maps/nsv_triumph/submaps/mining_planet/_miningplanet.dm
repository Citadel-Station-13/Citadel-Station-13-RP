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

// Mining Planet world areas
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

// This is a special subtype of the thing that generates ores on a map
// It will generate more rich ores because of the lower numbers than the normal one
/datum/random_map/noise/ore/mining_planet
	descriptor = "Mining planet mine ore distribution map"
	deep_val = 0.6 //More riches, normal is 0.7 and 0.8
	rare_val = 0.9

// The check_map_sanity proc is sometimes unsatisfied with how AMAZING our ores are
/datum/random_map/noise/ore/mining_planet/check_map_sanity()
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
	admin_notice("RARE COUNT [rare_count]", R_DEBUG)
	admin_notice("SURFACE COUNT [surface_count]", R_DEBUG)
	admin_notice("DEEP COUNT [deep_count]", R_DEBUG)