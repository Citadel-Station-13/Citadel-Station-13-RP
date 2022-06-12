//Normal map defs
#define Z_LEVEL_UNDERGROUND_FLOOR		2
#define Z_LEVEL_UNDERGROUND_DEEP		3
#define Z_LEVEL_UNDERGROUND				4
#define Z_LEVEL_SURFACE_LOW				5
#define Z_LEVEL_SURFACE_MID				6
#define Z_LEVEL_SURFACE_HIGH			7

#define Z_LEVEL_WEST_BASE				8
#define Z_LEVEL_WEST_CAVERN				9
#define Z_LEVEL_WEST_DEEP				10
#define Z_LEVEL_WEST_PLAIN				11

#define Z_LEVEL_MISC					12

#define Z_LEVEL_DEBRISFIELD				13
#define Z_LEVEL_PIRATEBASE				14
#define Z_LEVEL_MININGPLANET			15 // CLASS G
#define Z_LEVEL_UNKNOWN_PLANET			16 // CLASS D
#define Z_LEVEL_DESERT_PLANET			17 // CLASS H
#define Z_LEVEL_GAIA_PLANET				18 // CLASS M
#define Z_LEVEL_FROZEN_PLANET			19 // CLASS P
#define Z_LEVEL_TRADEPORT				20

#define Z_LEVEL_LAVALAND				21
#define Z_LEVEL_LAVALAND_EAST			22

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

	lobby_icon = 'icons/misc/title_vr.dmi'
	lobby_screens = list("title1", "title2", "title3", "title4", "title5", "title6")

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
		Z_LEVEL_WEST_PLAIN)
	player_levels = list(Z_LEVEL_UNDERGROUND_FLOOR,
		Z_LEVEL_UNDERGROUND_DEEP,
		Z_LEVEL_UNDERGROUND,
		Z_LEVEL_SURFACE_LOW,
		Z_LEVEL_SURFACE_MID,
		Z_LEVEL_SURFACE_HIGH,
		Z_LEVEL_WEST_BASE,
		Z_LEVEL_WEST_PLAIN,
		Z_LEVEL_WEST_CAVERN)

	holomap_smoosh = list(list(
		Z_LEVEL_UNDERGROUND_DEEP,
		Z_LEVEL_UNDERGROUND,
		Z_LEVEL_SURFACE_LOW,
		Z_LEVEL_SURFACE_MID,
		Z_LEVEL_SURFACE_HIGH))

	station_name  = "NSB Atlas"
	station_short = "Atlas"
	dock_name     = "NSS Demeter"
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
							NETWORK_LYTHIOS
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
		list("Debris Field - Z1 Space"), // Debris Field
		list("Away Mission - Pirate Base"), // Vox Pirate Base & Mining Planet
		list("ExoPlanet - Z1 Planet"),//Mining planet
		list("ExoPlanet - Z2 Planet"), // Rogue Exoplanet
		list("ExoPlanet - Z3 Planet"), // Desert Exoplanet
		list("ExoPlanet - Z4 Planet"), // Gaia Planet
		list("ExoPlanet - Z5 Planet"), // Frozen Planet
//		list("Asteroid Belt 1","Asteroid Belt 2","Asteroid Belt 3","Asteroid Belt 4"),
		list("Away Mission - Trade Port"), // Trading Post
		list("Away Mission - Lava Land", "Away Mission - Lava Land (East)")
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

	lateload_single_pick = null //Nothing right now.

	planet_datums_to_make = list(/datum/planet/lythios43c,
		/datum/planet/lavaland,
		/datum/planet/classg,
		/datum/planet/classd,
		/datum/planet/classh,
		/datum/planet/classp,
		/datum/planet/classm)

/datum/map/rift/perform_map_generation()
	new /datum/random_map/automata/cave_system/no_cracks(null, 1, 1, Z_LEVEL_WEST_CAVERN, world.maxx - 4, world.maxy - 4)         // Create the mining ore distribution map.
	new /datum/random_map/automata/cave_system/no_cracks(null, 1, 1, Z_LEVEL_WEST_DEEP, world.maxx - 4, world.maxy - 4)         // Create the mining ore distribution map.
	new /datum/random_map/automata/cave_system/no_cracks(null, 1, 1, Z_LEVEL_WEST_BASE, world.maxx - 4, world.maxy - 4)         // Create the mining ore distribution map.
	new /datum/random_map/automata/cave_system/no_cracks(null, 1, 1, Z_LEVEL_UNDERGROUND_FLOOR, world.maxx - 4, world.maxy - 4)         // Create the mining ore distribution map.

	return 1

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
	base_turf = /turf/simulated/floor/outdoors/safeice/lythios43c/indoors

/datum/map_z_level/rift/deep
	z = Z_LEVEL_WEST_DEEP
	name = "Western Deep Caves"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_PLAYER
	base_turf = /turf/simulated/open

/datum/map_z_level/rift/caves
	z = Z_LEVEL_WEST_CAVERN
	name = "Western Caves"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_PLAYER
	base_turf = /turf/simulated/floor/outdoors/safeice/lythios43c/indoors

/datum/map_z_level/rift/plains
	z = Z_LEVEL_WEST_PLAIN
	name = "Western Plains"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER
	base_turf = /turf/simulated/open

/datum/map_z_level/rift/colony
	z = Z_LEVEL_MISC
	name = "Orbital Relay"
	flags = MAP_LEVEL_ADMIN|MAP_LEVEL_CONTACT|MAP_LEVEL_XENOARCH_EXEMPT
