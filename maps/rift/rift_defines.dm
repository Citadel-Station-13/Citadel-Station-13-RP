//Normal map defs
#define Z_LEVEL_UNDERGROUND_DEEP		2
#define Z_LEVEL_UNDERGROUND				3
#define Z_LEVEL_SURFACE_LOW				4
#define Z_LEVEL_SURFACE_MID				5
#define Z_LEVEL_SURFACE_HIGH			6

#define Z_LEVEL_CENTCOM					7
#define Z_LEVEL_MISC					8
#define Z_LEVEL_SHIPS					9

#define Z_LEVEL_WEST_PLAIN				10
#define Z_LEVEL_WEST_CAVERN				11

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
	id_hud_icons = 'icons/mob/hud_jobs_vr.dmi' //CITADEL CHANGE: Ignore this line because it's going to be overriden in modular_citadel\maps\tether\tether_defines.dm

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
		Z_LEVEL_SURFACE_HIGH)
	player_levels = list(Z_LEVEL_UNDERGROUND_DEEP,
		Z_LEVEL_UNDERGROUND,
		Z_LEVEL_SURFACE_LOW,
		Z_LEVEL_SURFACE_MID,
		Z_LEVEL_SURFACE_HIGH)

	holomap_smoosh = list(list(
		Z_LEVEL_UNDERGROUND_DEEP,
		Z_LEVEL_UNDERGROUND,
		Z_LEVEL_SURFACE_LOW,
		Z_LEVEL_SURFACE_MID,
		Z_LEVEL_SURFACE_HIGH))

	station_name  = "NSB Atlas"
	station_short = "Atlas"
	dock_name     = "NSS Raytheon"
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

	allowed_spawns = list("Shuttle Station","Gateway","Cryogenic Storage","Cyborg Storage"/*,"Beruang Trading Corp Cryo"*/)
	spawnpoint_died = /datum/spawnpoint/shuttle
	spawnpoint_left = /datum/spawnpoint/shuttle
	spawnpoint_stayed = /datum/spawnpoint/cryo

	meteor_strike_areas = null

	default_skybox = /datum/skybox_settings/lythios

	unit_test_exempt_areas = list(
		/area/tether/surfacebase/outside/outside1,
		/area/tether/elevator,
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
		/area/rnd/external, //  Outside,
		/area/tether/surfacebase/emergency_storage/rnd,
		/area/tether/surfacebase/emergency_storage/atrium,
		/area/tether/surfacebase/lowernortheva, // it airlock
		/area/tether/surfacebase/lowernortheva/external, //it outside
		/area/tether/surfacebase/security/gasstorage) //it maint

/* Finish this when you have a ship and the locations for it to access
	belter_docked_z = 		list(Z_LEVEL_DECK_TWO)
	belter_transit_z =	 	list(Z_LEVEL_SHIPS)
	belter_belt_z = 		list(Z_LEVEL_ROGUEMINE_1,
						 		 Z_LEVEL_ROGUEMINE_2,
						 	 	 Z_LEVEL_ROGUEMINE_3,
								 Z_LEVEL_ROGUEMINE_4)
*/
	lateload_z_levels = list(
		list("Rift - Misc","Rift - Ships","Rift - Western Plains","Rift - Western Caverns") // Stock Rift lateload maps
	)

	ai_shell_restricted = TRUE
	ai_shell_allowed_levels = list(
	Z_LEVEL_UNDERGROUND_DEEP,
		Z_LEVEL_UNDERGROUND,
		Z_LEVEL_SURFACE_LOW,
		Z_LEVEL_SURFACE_MID,
		Z_LEVEL_SURFACE_HIGH)

/*	belter_docked_z = 		list(Z_LEVEL_SPACE_HIGH)
	belter_transit_z =	 	list(Z_LEVEL_MISC)
	belter_belt_z = 		list(Z_LEVEL_ROGUEMINE_1,
						 		 Z_LEVEL_ROGUEMINE_2)

	mining_station_z =		list(Z_LEVEL_SPACE_HIGH)
	mining_outpost_z =		list(Z_LEVEL_SURFACE_MINE)
*/
	lateload_single_pick = null //Nothing right now.

	planet_datums_to_make = list(/datum/planet/lythios43c)

/datum/map/lythios/perform_map_generation()
	return 1

/datum/skybox_settings/lythios/New()
	icon_state = "space1" // This is set again to a static state until a proper RNG of a static backdrop for every new round is set-up.
	return icon_state

/* ERRORS - Lacks Z_LEVEL_SURFACE_MINE etc..
/datum/map/lythios/perform_map_generation()

	new /datum/random_map/automata/cave_system/no_cracks(null, 1, 1, Z_LEVEL_SURFACE_MINE, world.maxx, world.maxy) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, Z_LEVEL_SURFACE_MINE, 64, 64)         // Create the mining ore distribution map.

	new /datum/random_map/automata/cave_system/no_cracks(null, 1, 1, Z_LEVEL_SOLARS, world.maxx, world.maxy) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, Z_LEVEL_SOLARS, 64, 64)         // Create the mining ore distribution map.

	return 1
*/
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
/datum/map_z_level/rift/station/underground_deep
	z = Z_LEVEL_UNDERGROUND_DEEP
	name = "Underground 2"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_SEALED|MAP_LEVEL_XENOARCH_EXEMPT
	base_turf = /turf/simulated/floor/outdoors/ice/lythios43c

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

/datum/map_z_level/rift/colony
	z = Z_LEVEL_CENTCOM
	name = "Orbital Relay"
	flags = MAP_LEVEL_ADMIN|MAP_LEVEL_CONTACT|MAP_LEVEL_XENOARCH_EXEMPT

/datum/map_z_level/rift/west_plains
	z = Z_LEVEL_WEST_PLAIN
	name = "Western Plains"
