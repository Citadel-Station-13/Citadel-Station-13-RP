//Shuttle Path for Class D Worlds
/datum/shuttle_destination/excursion/class_d_orbit
	name = "Unknown Planet Orbit" //The name of the destination
	my_landmark = "triumph_excursion_space" //The area the shuttle goes when it's settled at this destination
	preferred_interim_tag = "triumph_excursion_transit_space" //The area the shuttle goes while it's moving there
	skip_me = TRUE //Must be TRUE on all away-mission destinations for reasons

	routes_to_make = list( //These are routes the shuttle connects to,
		/datum/shuttle_destination/excursion/bluespace = 30 SECONDS //This is a normal destination that's part of Triumph
	)

/datum/shuttle_destination/excursion/class_d_surface
	name = "Unknown Planet Surface"
	my_landmark = "triumph_excursion_poid"
	preferred_interim_tag = "tether_excursion_transit_sand"
	skip_me = TRUE

	routes_to_make = list(
		/datum/shuttle_destination/excursion/class_d_orbit = 15 SECONDS //This is the above one
	)

/obj/shuttle_connector/poi_d
	name = "shuttle connector - Class D"
	shuttle_name = "Excursion Shuttle"
	destinations = list(/datum/shuttle_destination/excursion/class_d_orbit, /datum/shuttle_destination/excursion/class_d_surface)

/obj/away_mission_init/poi_d/Initialize()


	return INITIALIZE_HINT_QDEL

//This is a special subtype of the thing that generates ores on a map
//It will generate more rich ores because of the lower numbers than the normal one
//Ore Generation for D Class Worlds
/*
/datum/random_map/noise/ore/poi_d
	descriptor = "Ore Spawn for D-Class Worlds"
	deep_val = 0.6 //Barren Rocks are not know for mineral richness.
	rare_val = 0.5

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
	if(surface_count < 50)
		admin_notice("<span class='danger'>Insufficient surface minerals. Rerolling...</span>", R_DEBUG)
		return 0
	else if(rare_count < 25)
		admin_notice("<span class='danger'>Insufficient rare minerals. Rerolling...</span>", R_DEBUG)
		return 0
	else if(deep_count < 10)
		admin_notice("<span class='danger'>Insufficient deep minerals. Rerolling...</span>", R_DEBUG)
		return 0
	else
		return 1

*/
//This object simply performs any map setup that needs to happen on our map if it loads.
//As with the above, you do need to place this object on the map somewhere.


//POI Init
/obj/away_mission_init/poi_d
	name = "away mission initializer -  Class D World"

/obj/away_mission_init/poi_d/Initialize()
	return INITIALIZE_HINT_QDEL

//Class D world areas
/area/shuttle/excursion/poi_d
	name = "Shuttle Landing Point"
	base_turf = /turf/simulated/mineral/floor/vacuum
	flags = RAD_SHIELDED
	dynamic_lighting = 0

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
