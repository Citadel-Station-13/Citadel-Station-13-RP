// Shuttle Path for lava land

// -- Datums -- //
/*/obj/effect/overmap/visitable/sector/lavaland
	name = "Mineral Rich Planet"			// The name of the destination
	desc = "Sensors indicate that this is a world filled with minerals.  There seems to be a thin atmosphere on the planet."
	icon_state = "globe"
	color = "#4e4e4e"	// Bright yellow
	initial_generic_waypoints = list("poid_main")
*/
// POI Init
/obj/away_mission_init/lavaland
	name = "away mission initializer -  lava land"

/obj/away_mission_init/lavaland/Initialize()
	return INITIALIZE_HINT_QDEL

// lava land world areas
/area/triumph_away/lavaland
	name = "lava land"
	icon_state = "away"
	base_turf = /turf/simulated/mineral/floor/
	dynamic_lighting = 1

/area/triumph_away/lavaland/explored
	name = "lava land - Explored (E)"
	icon_state = "red"
	forced_ambience = list('sound/ambience/tension/tension.ogg', 'sound/ambience/tension/horror.ogg')

/area/triumph_away/lavaland/unexplored
	name = "lava land - Unexplored (UE)"
	icon_state = "yellow"

// This is a special subtype of the thing that generates ores on a map
// It will generate more rich ores because of the lower numbers than the normal one
/datum/random_map/noise/ore/lavaland
	descriptor = "lava land mine ore distribution map"
	deep_val = 0.6 //More riches, normal is 0.7 and 0.8
	rare_val = 0.4

// The check_map_sanity proc is sometimes unsatisfied with how AMAZING our ores are
/datum/random_map/noise/ore/lavaland/check_map_sanity()
	var/rare_count = 0
	var/surface_count = 0
	var/deep_count = 0

//// Something is causing the ore spawn to error out, but still spawn ores for us so we'll need to keep tabs on why this is.
//// Hopefully the increased rarity val will cause the error to vanish, but we'll see. - Enzo 9/8/2020

	// Increment map sanity counters.
	for(var/value in map)
		if(value < rare_val)
			surface_count++
		else if(value < deep_val)
			rare_count++
		else
			deep_count++
	admin_notice("RARE COUNT [rare_count]", R_DEBUG)
	admin_notice("SURFACE COUNT [surface_count]", R_DEBUG)
	admin_notice("DEEP COUNT [deep_count]", R_DEBUG)
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
