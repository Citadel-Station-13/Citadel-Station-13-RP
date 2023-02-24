//Normal map defs
#define Z_LEVEL_UNDERGROUND_FLOOR		2
#define Z_LEVEL_UNDERGROUND_DEEP		3
#define Z_LEVEL_UNDERGROUND				4
#define Z_LEVEL_SURFACE_LOW				5
#define Z_LEVEL_SURFACE_MID				6
#define Z_LEVEL_SURFACE_HIGH			7

#define Z_LEVEL_WEST_BASE				8
#define Z_LEVEL_WEST_DEEP				9
#define Z_LEVEL_WEST_CAVERN				10
#define Z_LEVEL_WEST_PLAIN				11

#define Z_LEVEL_MISC					12

#define Z_LEVEL_DEBRISFIELD				13
#define Z_LEVEL_PIRATEBASE				14
#define Z_LEVEL_MININGPLANET			15 // CLASS G
#define Z_LEVEL_CLASS_D					16 // CLASS D
#define Z_LEVEL_DESERT_PLANET			17 // CLASS H
#define Z_LEVEL_GAIA_PLANET				18 // CLASS M
#define Z_LEVEL_FROZEN_PLANET			19 // CLASS P
#define Z_LEVEL_TRADEPORT				20

#define Z_LEVEL_LAVALAND				21
#define Z_LEVEL_LAVALAND_EAST			22

#define Z_LEVEL_ROGUEMINE_1				23
#define Z_LEVEL_ROGUEMINE_2				24
#define Z_LEVEL_ROGUEMINE_3				25
#define Z_LEVEL_ROGUEMINE_4				26

#define Z_LEVEL_BEACH					27
#define Z_LEVEL_BEACH_CAVE				28
#define Z_LEVEL_DESERT					29

//#define Z_LEVEL_AEROSTAT				30
//#define Z_LEVEL_AEROSTAT_SURFACE		31

/datum/map/rift
	name = "Rift"
	full_name = "NSB Atlas"
	path = "rift"

	use_overmap = TRUE
	overmap_z = Z_LEVEL_MISC
	overmap_size = 60
	overmap_event_areas = 50
	usable_email_tlds = list("lythios.nt")

	zlevel_datum_type = /datum/map_z_level/rift
	base_turf_by_z = list(Z_LEVEL_WEST_BASE,
		Z_LEVEL_WEST_DEEP,
		Z_LEVEL_WEST_CAVERN)

	lobby_icon = 'icons/misc/title_vr.dmi'
	lobby_screens = list("title1", "title2", "title3", "title4", "title5", "title6", "title7", "title8", "bnny")

	admin_levels = list()
	sealed_levels = list()
	empty_levels = null
	station_levels = list(Z_LEVEL_UNDERGROUND_DEEP,
		Z_LEVEL_UNDERGROUND,
		Z_LEVEL_SURFACE_LOW,
		Z_LEVEL_SURFACE_MID,
		Z_LEVEL_SURFACE_HIGH)
	contact_levels = list(Z_LEVEL_UNDERGROUND_DEEP,
		Z_LEVEL_UNDERGROUND,
		Z_LEVEL_SURFACE_LOW,
		Z_LEVEL_SURFACE_MID,
		Z_LEVEL_SURFACE_HIGH,
		Z_LEVEL_WEST_BASE,
		Z_LEVEL_WEST_DEEP,
		Z_LEVEL_WEST_CAVERN,
		Z_LEVEL_WEST_PLAIN)
	player_levels = list(Z_LEVEL_UNDERGROUND_FLOOR,
		Z_LEVEL_UNDERGROUND_DEEP,
		Z_LEVEL_UNDERGROUND,
		Z_LEVEL_SURFACE_LOW,
		Z_LEVEL_SURFACE_MID,
		Z_LEVEL_SURFACE_HIGH,
		Z_LEVEL_WEST_BASE,
		Z_LEVEL_WEST_PLAIN,
		Z_LEVEL_WEST_DEEP,
		Z_LEVEL_WEST_CAVERN)

	holomap_smoosh = list(list(
		Z_LEVEL_UNDERGROUND_DEEP,
		Z_LEVEL_UNDERGROUND,
		Z_LEVEL_SURFACE_LOW,
		Z_LEVEL_SURFACE_MID,
		Z_LEVEL_SURFACE_HIGH))

	station_name  = "NSB Atlas"
	station_short = "Atlas"
	dock_name     = "NTS Demeter"
	dock_type     = "surface"
	boss_name     = "Central Command"
	boss_short    = "CentCom"
	company_name  = "NanoTrasen"
	company_short = "NT"
	starsys_name  = "Lythios-43"

	shuttle_docked_message = "The scheduled NSV Herrera shuttle flight to the %dock_name% orbital relay has arrived. It will depart in approximately %ETD%."
	shuttle_leaving_dock = "The NSV Herrera has left the station. Estimate %ETA% until the shuttle arrives at the %dock_name% orbital relay."
	shuttle_called_message = "A scheduled crew transfer to the %dock_name% orbital relay is occuring. The NSV Herrera will be arriving shortly. Those departing should proceed to departures within %ETA%."
	shuttle_name = "NSV Herrera"
	shuttle_recall_message = "The scheduled crew transfer flight has been cancelled."
	emergency_shuttle_docked_message = "The evacuation flight has landed at the landing pad. You have approximately %ETD% to board the vessel."
	emergency_shuttle_leaving_dock = "The emergency flight has left the station. Estimate %ETA% until the vessel arrives at %dock_name% orbital relay."
	emergency_shuttle_called_message = "An emergency evacuation has begun, and an emergency response flight has been called. It will arrive at the landing pad in approximately %ETA%."
	emergency_shuttle_recall_message = "The evacuation flight has been cancelled."

	station_networks = list(
							NETWORK_CARGO,
							NETWORK_CIRCUITS,
							NETWORK_CIVILIAN,
							NETWORK_COMMAND,
							NETWORK_ENGINE,
							NETWORK_ENGINEERING,
							NETWORK_EXPLORATION,
							//NETWORK_DEFAULT,  //Is this even used for anything? Robots show up here, but they show up in ROBOTS network too,
							NETWORK_MEDICAL,
							NETWORK_MINE,
							NETWORK_OUTSIDE,
							NETWORK_RESEARCH,
							NETWORK_RESEARCH_OUTPOST,
							NETWORK_ROBOTS,
							NETWORK_SECURITY,
							NETWORK_TCOMMS,
							NETWORK_LYTHIOS,
							NETWORK_EXPLO_HELMETS
							)
	secondary_networks = list(
							NETWORK_ERT,
							NETWORK_MERCENARY,
							NETWORK_THUNDER,
							NETWORK_COMMUNICATORS,
							NETWORK_ALARM_ATMOS,
							NETWORK_ALARM_POWER,
							NETWORK_ALARM_FIRE,
							NETWORK_TALON_HELMETS,
							NETWORK_TALON_SHIP
							)

	bot_patrolling = FALSE

	allowed_spawns = list("Shuttle Bay","Beruang Trading Corp Cryo","Cryogenic Storage")
	spawnpoint_died = /datum/spawnpoint/shuttle
	spawnpoint_left = /datum/spawnpoint/shuttle
	spawnpoint_stayed = /datum/spawnpoint/cryo

	meteor_strike_areas = null

	unit_test_exempt_areas = list(
		/area/rift/surfacebase/outside/outside1,
		/area/rift/turbolift,
		/area/vacant/vacant_site,
		/area/vacant/vacant_site/east,
		/area/crew_quarters/sleep/Dorm_1/holo,
		/area/crew_quarters/sleep/Dorm_3/holo,
		/area/crew_quarters/sleep/Dorm_5/holo,
		/area/crew_quarters/sleep/Dorm_7/holo,
		/area/looking_glass/lg_1,
		/area/rnd/miscellaneous_lab)

	unit_test_exempt_from_atmos = list(
		/area/engineering/atmos_intake, // Outside,
		/area/rnd/external) //  Outside,

/* Finish this when you have a ship and the locations for it to access
	belter_docked_z = 		list(Z_LEVEL_DECK_TWO)
	belter_transit_z =	 	list(Z_LEVEL_SHIPS)
	belter_belt_z = 		list(Z_LEVEL_ROGUEMINE_1,
						 		 Z_LEVEL_ROGUEMINE_2,
						 	 	 Z_LEVEL_ROGUEMINE_3,
								 Z_LEVEL_ROGUEMINE_4)
*/

	lavaland_levels =		list(Z_LEVEL_LAVALAND,
								 Z_LEVEL_LAVALAND_EAST)

	lateload_z_levels = list(
//		list("Rift - Misc"), // Stock Rift lateload maps || Currently not in use, takes too long to load, breaks shuttles.
//		list("Western Canyon","Western Deep Caves","Western Caves","Western Plains"),	///Integration Test says these arent valid maps but everything works, will leave in for now but this prolly isnt needed -Bloop
		list("Debris Field - Z1 Space"), // Debris Field
		list("Away Mission - Pirate Base"), // Pirate Base & Mining Planet
		list("ExoPlanet - Z1 Planet"),//Mining planet
		list("ExoPlanet - Z2 Planet"), // Rogue Exoplanet
		list("ExoPlanet - Z3 Planet"), // Desert Exoplanet
		list("ExoPlanet - Z4 Planet"), // Gaia Planet
		list("ExoPlanet - Z5 Planet"), // Frozen Planet
		list("Away Mission - Trade Port"), // Trading Post
		list("Away Mission - Lava Land", "Away Mission - Lava Land (East)"),
		list("Asteroid Belt 1","Asteroid Belt 2","Asteroid Belt 3","Asteroid Belt 4"),
		list("Desert Planet - Z1 Beach","Desert Planet - Z2 Cave","Desert Planet - Z3 Desert")
	//	list("Remmi Aerostat - Z1 Aerostat","Remmi Aerostat - Z2 Surface")
	)

	ai_shell_restricted = TRUE
	ai_shell_allowed_levels = list(
	Z_LEVEL_UNDERGROUND_DEEP,
		Z_LEVEL_UNDERGROUND,
		Z_LEVEL_SURFACE_LOW,
		Z_LEVEL_SURFACE_MID,
		Z_LEVEL_SURFACE_HIGH,
		Z_LEVEL_MISC)

	mining_station_z =		list(Z_LEVEL_UNDERGROUND_DEEP)
	mining_outpost_z =		list(Z_LEVEL_WEST_PLAIN)

	belter_docked_z = 		list(Z_LEVEL_WEST_DEEP)
	belter_transit_z =	 	list(Z_LEVEL_MISC)
	belter_belt_z = 		list(Z_LEVEL_ROGUEMINE_1,
						 		 Z_LEVEL_ROGUEMINE_2)

	lateload_single_pick = null //Nothing right now.

	planet_datums_to_make = list(/datum/planet/lythios43c,
		/datum/planet/lavaland,
		/datum/planet/classg,
		/datum/planet/classd,
		/datum/planet/classh,
		/datum/planet/classp,
		/datum/planet/classm,
		/datum/planet/miaphus
		)

// Overmap stuff. Main file is under code/modules/maps/overmap/_lythios43c.dm
// Todo, find a way to populate this list automatically without having to do this
/obj/effect/overmap/visitable/sector/lythios43c
	extra_z_levels = list(
		Z_LEVEL_WEST_PLAIN,
		Z_LEVEL_WEST_CAVERN,
		Z_LEVEL_WEST_DEEP,
		Z_LEVEL_WEST_BASE
	)
	levels_for_distress = list(
		Z_LEVEL_DEBRISFIELD,
		Z_LEVEL_MININGPLANET,
		Z_LEVEL_CLASS_D,
		Z_LEVEL_DESERT_PLANET,
		Z_LEVEL_GAIA_PLANET,
		Z_LEVEL_FROZEN_PLANET
		)


/*
// For making the 6-in-1 holomap, we calculate some offsets
#define TETHER_MAP_SIZE 140 // Width and height of compiled in tether z levels.
#define TETHER_HOLOMAP_CENTER_GUTTER 40 // 40px central gutter between columns
#define TETHER_HOLOMAP_MARGIN_X ((HOLOMAP_ICON_SIZE - (2*TETHER_MAP_SIZE) - TETHER_HOLOMAP_CENTER_GUTTER) / 2) // 100
#define TETHER_HOLOMAP_MARGIN_Y ((HOLOMAP_ICON_SIZE - (3*TETHER_MAP_SIZE)) / 2) // 60

// We have a bunch of stuff common to the station z levels
/datum/map_z_level/tether/station
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_XENOARCH_EXEMPT
	holomap_legend_x = 220
	holomap_legend_y = 160
*/
/datum/map_z_level/rift/station/underground_floor
	z = Z_LEVEL_UNDERGROUND_FLOOR
	name = "Eastern Canyon"
	flags = MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_SEALED|MAP_LEVEL_XENOARCH_EXEMPT
	base_turf = /turf/simulated/floor/outdoors/safeice/lythios43c

/datum/map_z_level/rift/station/underground_deep
	z = Z_LEVEL_UNDERGROUND_DEEP
	name = "Underground 2"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_SEALED|MAP_LEVEL_XENOARCH_EXEMPT
	base_turf = /turf/simulated/floor/outdoors/safeice/lythios43c

/datum/map_z_level/rift/station/underground_shallow
	z = Z_LEVEL_UNDERGROUND
	name = "Underground 1"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_SEALED|MAP_LEVEL_XENOARCH_EXEMPT
	base_turf = /turf/simulated/open

/datum/map_z_level/rift/station/surface_low
	z = Z_LEVEL_SURFACE_LOW
	name = "Surface 1"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_XENOARCH_EXEMPT
	transit_chance = 100
	base_turf = /turf/simulated/open
//	holomap_offset_x = TETHER_HOLOMAP_MARGIN_X
//	holomap_offset_y = TETHER_HOLOMAP_MARGIN_Y + TETHER_MAP_SIZE*0

/datum/map_z_level/rift/station/surface_mid
	z = Z_LEVEL_SURFACE_MID
	name = "Surface 2"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_XENOARCH_EXEMPT
	base_turf = /turf/simulated/open
//	holomap_offset_x = TETHER_HOLOMAP_MARGIN_X
//	holomap_offset_y = TETHER_HOLOMAP_MARGIN_Y + TETHER_MAP_SIZE*1

/datum/map_z_level/rift/station/surface_high
	z = Z_LEVEL_SURFACE_HIGH
	name = "Surface 3"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_XENOARCH_EXEMPT
	base_turf = /turf/simulated/open
//	holomap_offset_x = TETHER_HOLOMAP_MARGIN_X
//	holomap_offset_y = TETHER_HOLOMAP_MARGIN_Y + TETHER_MAP_SIZE*2

/datum/map_z_level/rift/base
	z = Z_LEVEL_WEST_BASE
	name = "Western Canyon"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER
	base_turf = /turf/simulated/mineral/floor/icerock/lythios43c/indoors

/datum/map_z_level/rift/deep
	z = Z_LEVEL_WEST_DEEP
	name = "Western Deep Caves"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_PLAYER
	base_turf = /turf/simulated/mineral/floor/icerock/lythios43c/indoors


/datum/map_z_level/rift/caves
	z = Z_LEVEL_WEST_CAVERN
	name = "Western Caves"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_PLAYER
	base_turf = /turf/simulated/mineral/floor/icerock/lythios43c/indoors


/datum/map_z_level/rift/plains
	z = Z_LEVEL_WEST_PLAIN
	name = "Western Plains"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER
	base_turf = /turf/simulated/floor/outdoors/safeice/lythios43c



/// Cave Generation
/datum/map/rift/perform_map_generation()
	. = ..()
	seed_submaps(list(Z_LEVEL_WEST_CAVERN), 50, /area/rift/surfacebase/outside/west_caves/submap_seedzone, /datum/map_template/submap/level_specific/rift/west_caves)
	seed_submaps(list(Z_LEVEL_WEST_DEEP), 50, /area/rift/surfacebase/outside/west_deep/submap_seedzone, /datum/map_template/submap/level_specific/rift/west_deep)
	seed_submaps(list(Z_LEVEL_WEST_BASE), 50, /area/rift/surfacebase/outside/west_base/submap_seedzone, /datum/map_template/submap/level_specific/rift/west_base)
	new /datum/random_map/automata/cave_system/no_cracks/rift(null, 3, 3, Z_LEVEL_WEST_CAVERN, world.maxx - 3, world.maxy - 3)         // Create the mining ore distribution map.
	new /datum/random_map/automata/cave_system/no_cracks/rift(null, 3, 3, Z_LEVEL_WEST_DEEP, world.maxx - 3, world.maxy - 3)         // Create the mining ore distribution map.
	new /datum/random_map/automata/cave_system/no_cracks/rift(null, 3, 3, Z_LEVEL_WEST_BASE, world.maxx - 3, world.maxy - 3)         // Create the mining ore distribution map.
	new /datum/random_map/automata/cave_system/no_cracks/rift(null, 3, 3, Z_LEVEL_UNDERGROUND_FLOOR, world.maxx - 3, world.maxy - 3)         // Create the mining ore distribution map.
	new /datum/random_map/automata/cave_system/no_cracks/rift_nocaves(null, 3, 3, Z_LEVEL_SURFACE_HIGH, world.maxx - 3, world.maxy - 3)
	new /datum/random_map/automata/cave_system/no_cracks/rift_nocaves(null, 3, 3, Z_LEVEL_SURFACE_MID, world.maxx - 3, world.maxy - 3)
	new /datum/random_map/automata/cave_system/no_cracks/rift_nocaves(null, 3, 3, Z_LEVEL_SURFACE_LOW, world.maxx - 3, world.maxy - 3)
	new /datum/random_map/automata/cave_system/no_cracks/rift_nocaves(null, 3, 3, Z_LEVEL_UNDERGROUND, world.maxx - 3, world.maxy - 3)
	new /datum/random_map/automata/cave_system/no_cracks/rift_nocaves(null, 3, 3, Z_LEVEL_UNDERGROUND_DEEP, world.maxx - 3, world.maxy - 3)

	return 1


/datum/map_z_level/rift/colony
	z = Z_LEVEL_MISC
	name = "Orbital Relay"
	flags = MAP_LEVEL_ADMIN|MAP_LEVEL_CONTACT|MAP_LEVEL_XENOARCH_EXEMPT

/// This is the effect that slams people into the ground upon dropping out of the sky //

/obj/effect/step_trigger/teleporter/planetary_fall/lythios43c/find_planet()
	planet = planet_lythios43c

/// Temporary place for this
// Spawner for lythios animals
/obj/tether_away_spawner/lythios_animals
	name = "Lythios Animal Spawner"
	faction = "lythios"
	atmos_comp = TRUE
	prob_spawn = 100
	mobs_to_pick_from = list(
		/mob/living/simple_mob/animal/icegoat = 2,
		/mob/living/simple_mob/animal/passive/woolie = 3,
		/mob/living/simple_mob/animal/passive/furnacegrub,
		/mob/living/simple_mob/animal/horing = 2
	)


/// Z level dropper. Todo, make something generic so we dont have to copy pasta this
/obj/effect/step_trigger/zlevel_fall //Don't ever use this, only use subtypes.Define a new var/static/target_z on each
	affect_ghosts = 1

/obj/effect/step_trigger/zlevel_fall/Initialize(mapload)
	. = ..()

	if(istype(get_turf(src), /turf/simulated/floor))
		src:target_z = z
		return INITIALIZE_HINT_QDEL

/obj/effect/step_trigger/zlevel_fall/Trigger(var/atom/movable/A) //mostly from /obj/effect/step_trigger/teleporter/planetary_fall, step_triggers.dm L160
	if(!src:target_z)
		return

	if(isobserver(A) || A.anchored)
		return
	if(A.throwing)
		return
	if(!A.can_fall())
		return
	if(isliving(A))
		var/mob/living/L = A
		if(L.is_floating || L.flying)
			return //Flyers/nograv can ignore it

	var/attempts = 100
	var/turf/simulated/T
	while(attempts && !T)
		var/turf/simulated/candidate = locate(rand(5,world.maxx-5),rand(5,world.maxy-5),src:target_z)
		if(candidate.density)
			attempts--
			continue

		T = candidate
		break

	if(!T)
		return

	if(isobserver(A))
		A.forceMove(T) // Harmlessly move ghosts.
		return

	A.forceMove(T)
	if(isliving(A)) // Someday, implement parachutes.  For now, just turbomurder whoever falls.
		message_admins("\The [A] fell out of the sky.")
		var/mob/living/L = A
		L.fall_impact(T, 42, 90, FALSE, TRUE)	//You will not be defibbed from this.

/obj/effect/step_trigger/zlevel_fall/cavernfall
	var/static/target_z = Z_LEVEL_WEST_CAVERN
