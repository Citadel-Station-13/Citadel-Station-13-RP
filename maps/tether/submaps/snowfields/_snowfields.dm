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
/*
	seed_submaps(list(z), 50, /area/tether_away/snowfields/unexplored/near, /datum/map_template/surface/snowfields/near)
	seed_submaps(list(z), 50, /area/tether_away/snowfields/unexplored/far, /datum/map_template/surface/snowfields/far)
*/
/obj/away_mission_init/snowfields/initialize()

	initialized = TRUE
	return INITIALIZE_HINT_QDEL

// They keep track of their mob, and when it's dead, spawn another depending on rng (only if nobody is looking)
/obj/tether_away_spawner/snowfields_easy
	name = "Snowfield Spawner Easy" //Just a name
	faction = "Snowfields" //Sets all the mobs to this faction so they don't infight.
	atmos_comp = TRUE //Sets up their atmos tolerances to work in this setting, even if they don't normally (20% up/down tolerance for each gas, and heat)
	prob_spawn = 75 //Chance of this spawner spawning a mob (once this is missed, the spawner is 'depleted' and won't spawn anymore)
	prob_fall = 25 //Chance goes down by this much each time it spawns one (not defining and prob_spawn 100 means they spawn as soon as one dies)
	guard = 40 //They'll stay within this range when wandering, but will chase past this distance. (not defining this disables them staying nearby and they will wander the map (and through step teleports))
	mobs_to_pick_from = list(
		/mob/living/simple_animal/hostile/giant_spider/frost = 2,
		/mob/living/simple_animal/hostile/giant_spider/lurker = 2,
		/mob/living/simple_animal/hostile/shantak = 1
	)

/obj/tether_away_spawner/snowfields_medium
	name = "Snowfield Spawner Medium"
	faction = "Snowfields"
	atmos_comp = TRUE
	prob_spawn = 80
	prob_fall = 40
	guard = 40
	mobs_to_pick_from = list(
		/mob/living/simple_animal/hostile/shantak = 2,
		/mob/living/simple_animal/hostile/tree = 1,
		/mob/living/simple_animal/hostile/creature = 2
	)

/obj/tether_away_spawner/snowfields_hard
	name = "Snowfield Spawner Hard"
	faction = "Snowfields"
	atmos_comp = TRUE
	prob_spawn = 60
	prob_fall = 20
	guard = 20
	mobs_to_pick_from = list(
		/mob/living/simple_animal/hostile/savik = 2,
		/mob/living/simple_animal/hostile/creature/strong = 1,
	)

/obj/tether_away_spawner/snowfields_boss
	name = "Snowfield Spawner Boss"
	faction = "Snowfields"
	atmos_comp = TRUE
	prob_spawn = 50
	prob_fall = 50
	guard = 50
	mobs_to_pick_from = list(
		/mob/living/simple_animal/hostile/wolf = 1
	)

/obj/tether_away_spawner/snowfields_diyaab
	name = "Snowfield Spawner Diyaab"
	faction = "Snowfields"
	atmos_comp = TRUE
	prob_spawn = 50
	prob_fall = 50
	guard = 10 //Hopefully this will keep the herd close to one another.
	mobs_to_pick_from = list(
		/mob/living/simple_animal/retaliate/diyaab = 1
	)

/obj/tether_away_spawner/snowfields_passive
	name = "Snowfield Spawner Passive"
	faction = "Passive" //This allows for them to be attacked by anything it wanders into, hopefully.
	atmos_comp = TRUE
	prob_spawn = 50
	prob_fall = 50 //Guard undefined to allow for wandering.
	mobs_to_pick_from = list(
		/mob/living/simple_animal/mouse/white = 1,
		/mob/living/simple_animal/penguin = 1,
		/mob/living/simple_animal/fox = 1
	)

// -- Areas -- //

//And some special areas, including our shuttle landing spot (must be unique)
/area/shuttle/excursion/away_snowfields
	name = "\improper Excursion Shuttle - Snowfields"
	dynamic_lighting = 0

/area/tether_away/snowfields
	name = "\improper Away Mission - Virgo 6 Snowfields"
	icon_state = "away"
	base_turf = /turf/simulated/floor/snow/snow2 //This is what the ground turns into if destroyed/bombed/etc
	//Not going to do sunlight/weather simulations here YET like on virgo3b.
	//Make the whole snowfield fullbright all the time for now, untill some kind of dynamic weather is added, giving random snowstorms and lighting shifts.
	dynamic_lighting = 0

//Some areas for the snowfields which are referenced by our init object to seed submaps.
/area/tether_away/snowfields
	flags = RAD_SHIELDED
	ambience = list('sound/ambience/ambimine.ogg', 'sound/ambience/song_game.ogg')

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

// -- Turfs -- //

//Atmosphere properties
#define O2SF 0.181
#define N2SF 0.819

#define MOLES_CELLSF 149.50978

#define MOLES_O2SF (MOLES_CELLSF * O2SF) // O2 value on Snowfields(18%)
#define MOLES_N2SF (MOLES_CELLSF * N2SF) // N2 value on Snowfields(82%)

#define TEMPERATURE_SF 230.15 // -43C / -45.4F
#define TEMPERATURE_ALTSF 205.15

/turf/unsimulated/wall/planetary/virgo6
	oxygen		= MOLES_O2SF
	nitrogen	= MOLES_N2SF
	temperature	= TEMPERATURE_SF

/turf/simulated/wall/virgo6
	oxygen		= MOLES_O2SF
	nitrogen	= MOLES_N2SF
	temperature	= TEMPERATURE_SF

/turf/simulated/wall/solidrock/virgo6
	oxygen		= MOLES_O2SF
	nitrogen	= MOLES_N2SF
	temperature	= TEMPERATURE_SF

/turf/simulated/floor/plating/virgo6
	oxygen		= MOLES_O2SF
	nitrogen	= MOLES_N2SF
	temperature	= TEMPERATURE_SF

/turf/simulated/floor/outdoors/snow/virgo6
	oxygen		= MOLES_O2SF
	nitrogen	= MOLES_N2SF
	temperature	= TEMPERATURE_SF

/turf/simulated/floor/reinforced/virgo6
	oxygen		= MOLES_O2SF
	nitrogen	= MOLES_N2SF
	temperature	= TEMPERATURE_SF

/turf/simulated/floor/outdoors/ice/virgo6
	oxygen		= MOLES_O2SF
	nitrogen	= MOLES_N2SF
	temperature	= TEMPERATURE_SF

/turf/simulated/floor/tiled/white/virgo6
	oxygen		= MOLES_O2SF
	nitrogen	= MOLES_N2SF
	temperature	= TEMPERATURE_SF

/turf/simulated/mineral/ignore_mapgen/virgo6
	oxygen		= MOLES_O2SF
	nitrogen	= MOLES_N2SF
	temperature	= TEMPERATURE_SF

/turf/simulated/mineral/floor/virgo6
	oxygen		= MOLES_O2SF
	nitrogen	= MOLES_N2SF
	temperature	= TEMPERATURE_SF

/turf/simulated/mineral/floor/ignore_mapgen/virgo6
	oxygen		= MOLES_O2SF
	nitrogen	= MOLES_N2SF
	temperature	= TEMPERATURE_SF
