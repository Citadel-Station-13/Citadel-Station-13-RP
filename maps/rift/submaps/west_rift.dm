//This object simply performs any map setup that needs to happen on our map if it loads.
//As with the above, you do need to place this object on the map somewhere.
/obj/away_mission_init/west_rift
	name = "away mission initializer - west_rift"

//In our case, it initializes the ores and random submaps in the beach's cave, then deletes itself
/obj/away_mission_init/west_rift/Initialize(mapload)
	flags |= INITIALIZED
	// Cave submaps are first.
	seed_submaps(list(z), 50, /area/rift/surfacebase/outside/west_caves/submap_seedzone, /datum/map_template/submap/level_specific/rift/west_caves)
//	seed_submaps(list(z), 50, /area/tether_away/cave/unexplored/deep, /datum/map_template/surface/mountains/deep)


	return INITIALIZE_HINT_QDEL

/obj/away_mission_init/west_rift
