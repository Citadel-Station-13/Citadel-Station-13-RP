// -- Datums -- //

//Including two new shuttle destinations. One is in orbit above the snow planet.
/datum/shuttle_destination/excursion/virgo6orbit //Must be a unique path
	name = "Virgo 6 Orbit" //The name of the destination
	my_area = /area/shuttle/excursion/space //The area the shuttle goes when it's settled at this destination
	preferred_interim_area = /area/shuttle/excursion/space_moving //The area the shuttle goes while it's moving there
	skip_me = TRUE //Must be TRUE on all away-mission destinations for reasons

	routes_to_make = list( //These are routes the shuttle connects to,
		/datum/shuttle_destination/excursion/bluespace = 30 SECONDS //This is a normal destination that's part of Tether
	)

//The other destination is landed on the surface.
/datum/shuttle_destination/excursion/snowfields
	name = "Snowfields"
	my_area = /area/shuttle/excursion/away_snowfields
	preferred_interim_area = /area/shuttle/excursion/snow_moving
	skip_me = TRUE

	routes_to_make = list(
		/datum/shuttle_destination/excursion/virgo6orbit = 30 SECONDS //This is the above one
	)

// -- Objs -- //

//This is a special type of object which will build our shuttle paths, only if this map loads
//You do need to place this object on the map somewhere.
/obj/shuttle_connector/snowfields
	name = "shuttle connector - snowfields"
	shuttle_name = "Excursion Shuttle"
	//This list needs to be in the correct order, and start with the one that connects to the rest of the shuttle 'network'
	destinations = list(/datum/shuttle_destination/excursion/virgo6orbit, /datum/shuttle_destination/excursion/snowfields)

//This object simply performs any map setup that needs to happen on our map if it loads.
//As with the above, you do need to place this object on the map somewhere.
/obj/away_mission_init/snowfieldsinit
	name = "away mission initializer - snowfields"

/obj/away_mission_init/snowfieldsinit/initialize()
	seed_submaps(list(z), 50, /area/tether_away/snowfields/unexplored/normal, /datum/map_template/surface/snowfields/near)
	seed_submaps(list(z), 50, /area/tether_away/snowfields/unexplored/deep, /datum/map_template/surface/snowfields/far)

/obj/away_mission_init/snowfields/initialize()

	initialized = TRUE
	return INITIALIZE_HINT_QDEL

// Two mob spawners that are placed on the map that spawn some mobs!
// They keep track of their mob, and when it's dead, spawn another (only if nobody is looking)
// Note that if your map has step teleports, mobs may wander through them accidentally and not know how to get back
/obj/tether_away_spawner/snowfields_easy
	name = "Snowfield Spawner Easy" //Just a name
	faction = "beach_out" //Sets all the mobs to this faction so they don't infight
	atmos_comp = TRUE //Sets up their atmos tolerances to work in this setting, even if they don't normally (20% up/down tolerance for each gas, and heat)
	prob_spawn = 75 //Chance of this spawner spawning a mob (once this is missed, the spawner is 'depleted' and won't spawn anymore)
	prob_fall = 25 //Chance goes down by this much each time it spawns one (not defining and prob_spawn 100 means they spawn as soon as one dies)
	guard = //They'll stay within this range (not defining this disables them staying nearby and they will wander the map (and through step teleports))
	mobs_to_pick_from = list(
		/mob/living/simple_animal/snake
	)

/obj/tether_away_spawner/snowfields_medium
	name = "Snowfield Spawner Medium"
	faction = "beach_cave"
	atmos_comp = TRUE
	prob_spawn = 100
	prob_fall = 40
	guard = 20
	mobs_to_pick_from = list(
		/mob/living/simple_animal/hostile/frog = 3, //Frogs are 3x more likely to spawn than,
		/mob/living/simple_animal/hostile/deathclaw = 1, //these deathclaws are, with these values,
		/mob/living/simple_animal/hostile/giant_spider = 3,
		/mob/living/simple_animal/hostile/giant_snake = 1,
		/mob/living/simple_animal/hostile/giant_spider/ion = 2
	)

// -- Areas -- //

//And some special areas, including our shuttle landing spot (must be unique)
/area/shuttle/excursion/away_snowfields
	name = "\improper Excursion Shuttle - Snowfields"
	dynamic_lighting = 0

/area/tether_away/snowfields
	name = "\improper Away Mission - Virgo 6 Snowfields"
	icon_state = "away"
	base_turf = /turf/simulated/floor/beach/sand //This is what the ground turns into if destroyed/bombed/etc
	//Not going to do sunlight simulations here like virgo3b
	//So we just make the whole snowfield fullbright all the time for now.
	dynamic_lighting = 0

//Some areas for the snowfields which are referenced by our init object to seed submaps.
/area/tether_away/cave
	flags = RAD_SHIELDED
	ambience = list('sound/ambience/ambimine.ogg', 'sound/ambience/song_game.ogg')
	base_turf = /turf/simulated/mineral/floor/ignore_mapgen/cave

/area/tether_away/snowfields/explored/near
	name = "\improper Away Mission - Virgo 6 snowfields (E)"
	icon_state = "explored"

/area/tether_away/snowfields/unexplored/near
	name = "\improper Away Mission - Virgo 6 snowfields (UE)"
	icon_state = "unexplored"

/area/tether_away/snowfields/explored/far
	name = "\improper Away Mission - Virgo 6 snowfields far (E)"
	icon_state = "explored_deep"

/area/tether_away/snowfields/unexplored/far
	name = "\improper Away Mission - Virgo 6 snowfields far (UE)"
	icon_state = "unexplored_deep"
