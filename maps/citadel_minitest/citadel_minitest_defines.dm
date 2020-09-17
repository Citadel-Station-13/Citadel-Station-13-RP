
#define Z_LEVEL_MAIN_CITADEL_TESTING					1

/datum/map/citadel_minitest
	name = "Virgo_minitest"
	full_name = "NSS Citadel Testing Facility"
	path = "citadel_minitest"

	lobby_icon = 'icons/misc/title_vr.dmi'
	lobby_screens = list("title1", "title2", "title3", "title4", "title5", "title6", "title7")
	id_hud_icons = 'icons/mob/hud_jobs_vr.dmi' //CITADEL CHANGE: Ignore this line because it's going to be overriden in modular_citadel\maps\tether\tether_defines.dm	//TODO Remove/Fix these unneccessary Override Overrides everywhere ffs - Zandario

	admin_levels = list()
	sealed_levels = list()
	empty_levels = list()
	station_levels = list(Z_LEVEL_MAIN_CITADEL_TESTING)
	contact_levels = list(Z_LEVEL_MAIN_CITADEL_TESTING)
	player_levels = list(Z_LEVEL_MAIN_CITADEL_TESTING)

	accessible_z_levels = list("1" = 100)	// The defines can't be used here sadly.	// For now.
	base_turf_by_z = list("1" = /turf/space)

	use_overmap = TRUE
	/var/overmap_size = 20			// Dimensions of overmap zlevel if overmap is used.
	/var/overmap_z = 0				// If 0 will generate overmap zlevel on init. Otherwise will populate the zlevel provided.
	/var/overmap_event_areas = 15	// How many event "clouds" will be generated

	station_name	= "NSS Citadel Testing Facility"
	station_short	= "NSS-CTF"
	dock_name		= "NSS-CTF CC"
	dock_type		= "surface"
	boss_name		= "Central Command-Testing"
	boss_short		= "CentCom-Testing"
	company_name	= "NanoTrasen-Testing"
	company_short	= "NT-Testing"
	starsys_name	= "Virgo-Erigone-Testing"

	shuttle_name			= "NAS |Hawking|"
	shuttle_docked_message	= "Test Shuttle Docked"
	shuttle_leaving_dock	= "Test Shuttle Leaving"
	shuttle_called_message	= "Test Shuttle Coming"
	shuttle_recall_message	= "Test Shuttle Cancelled"

	emergency_shuttle_docked_message	= "Test E-Shuttle Docked"
	emergency_shuttle_leaving_dock		= "Test E-Shuttle Left"
	emergency_shuttle_called_message	= "Test E-Shuttle Coming"
	emergency_shuttle_recall_message	= "Test E-Shuttle Cancelled"

	station_networks = list(
							NETWORK_CARGO,
							NETWORK_CIVILIAN,
							NETWORK_COMMAND,
							NETWORK_ENGINE,
							NETWORK_ENGINEERING,
							NETWORK_ENGINEERING_OUTPOST,
							NETWORK_DEFAULT,
							NETWORK_MEDICAL,
							NETWORK_MINE,
							NETWORK_NORTHERN_STAR,
							NETWORK_RESEARCH,
							NETWORK_RESEARCH_OUTPOST,
							NETWORK_ROBOTS,
							NETWORK_PRISON,
							NETWORK_SECURITY,
							NETWORK_INTERROGATION
							)

	allowed_spawns = list("Arrivals Shuttle")


/datum/map/citadel_minitest/perform_map_generation()
/*
	new /datum/random_map/automata/cave_system(null, 1, 1, Z_LEVEL_MAIN_CITADEL_TESTING, world.maxx, world.maxy)
	new /datum/random_map/noise/ore(null, 1, 1, Z_LEVEL_MAIN_CITADEL_TESTING, 64, 64)
*/
	return 1
