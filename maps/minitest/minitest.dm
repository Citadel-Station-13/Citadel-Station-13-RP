/datum/map/station/minitest
	id = "minitest"
	name = "World - Minitest (DEBUG)"
	levels = list(
		/datum/map_level/minitest/station,
		/datum/map_level/minitest/sector1,
		/datum/map_level/minitest/sector2,
	)
	width = 100
	height = 100

	//* LEGACY BELOW *//

	legacy_assert_shuttle_datums = list(
		/datum/shuttle/autodock/overmap/overmapdemo,
		/datum/shuttle/autodock/ferry/ferrydemo,
		/datum/shuttle/autodock/multi/multidemo,
		/datum/shuttle/autodock/web_shuttle/webdemo,
	)

	full_name = "NSS Citadel Testing Facility"

	lobby_icon = 'icons/misc/title_vr.dmi'
	lobby_screens = list("minitest1", "minitest2")
	id_hud_icons = 'icons/mob/hud_jobs_vr.dmi' //CITADEL CHANGE: Ignore this line because it's going to be overriden in modular_citadel\maps\tether\tether_defines.dm	//TODO Remove/Fix these unneccessary Override Overrides everywhere ffs - Zandario

	use_overmap = TRUE
	overmap_size = 20
	overmap_event_areas = 15

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

/datum/map_level/minitest/station
	id = "MinitestStation"
	name = "Minitest - Station"
	display_id = "!debug-station"
	display_name = "Minitest Debugging Map - Station"
	absolute_path = "maps/minitest/levels/minitest.dmm"
	traits = list(
		ZTRAIT_STATION,
		ZTRAIT_FACILITY_SAFETY,
	)
	base_turf = /turf/space
	flags = LEGACY_LEVEL_STATION | LEGACY_LEVEL_CONTACT | LEGACY_LEVEL_PLAYER | LEGACY_LEVEL_CONSOLES

/datum/map_level/minitest/sector1
	id = "MinitestSector1"
	name = "Minitest - Sector 1"
	display_id = "!debug-sector-1"
	display_name = "Minitest Debugging Map - Sector 1"
	absolute_path = "maps/minitest/levels/sector1.dmm"
	base_turf = /turf/simulated/floor/plating
	flags = LEGACY_LEVEL_STATION | LEGACY_LEVEL_CONTACT | LEGACY_LEVEL_PLAYER | LEGACY_LEVEL_CONSOLES

/datum/map_level/minitest/sector2
	id = "MinitestSector2"
	name = "Minitest - Sector 2"
	display_id = "!debug-sector-2"
	display_name = "Minitest Debugging Map - Sector 2"
	absolute_path = "maps/minitest/levels/sector2.dmm"
	base_turf = /turf/simulated/floor/plating
	flags = LEGACY_LEVEL_STATION | LEGACY_LEVEL_CONTACT | LEGACY_LEVEL_PLAYER | LEGACY_LEVEL_CONSOLES
