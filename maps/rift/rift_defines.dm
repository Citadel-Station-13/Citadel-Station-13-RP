//Atmosphere properties
#define LYTHIOS43C_SET_ATMOS	initial_gas_mix = ATMOSPHERE_ID_LYTHIOS43C
#define LYTHIOS43C_TURF_CREATE(x)	x/lythios43c/initial_gas_mix = ATMOSPHERE_ID_LYTHIOS43C;x/lythios43c/outdoors=TRUE;x/lythios43c/allow_gas_overlays = FALSE
#define LYTHIOS43C_TURF_CREATE_UN(x)	x/lythios43c/initial_gas_mix=ATMOSPHERE_ID_LYTHIOS43C

//Normal map defs
#define Z_LEVEL_UNDERGROUND_DEEP			1
#define Z_LEVEL_UNDERGROUND					2
#define Z_LEVEL_SURFACE_LOW					3
#define Z_LEVEL_SURFACE_MID					4
#define Z_LEVEL_SURFACE_HIGH				5
#define Z_LEVEL_TRANSIT						6

/datum/map/rift
	name = "Rift"
	full_name = "NSB Atlas"
	path = "rift"

	zlevel_datum_type = /datum/map_z_level/rift

	lobby_icon = 'icons/misc/title_vr.dmi'
	lobby_screens = list("title1", "title2", "title3", "title4", "title5", "title6")
	id_hud_icons = 'icons/mob/hud_jobs_vr.dmi' //CITADEL CHANGE: Ignore this line because it's going to be overriden in modular_citadel\maps\tether\tether_defines.dm
/*
	holomap_smoosh = list(list(
		Z_LEVEL_SURFACE_LOW,
		Z_LEVEL_SURFACE_MID,
		Z_LEVEL_SURFACE_HIGH,
		Z_LEVEL_SPACE_LOW,
		Z_LEVEL_SPACE_MID,
		Z_LEVEL_SPACE_HIGH))
*/
	station_name  = "NSB Atlas"
	station_short = "Raytheon"
	dock_name     = "NSC Raytheon Orbital Relay"
	boss_name     = "Central Command"
	boss_short    = "CentCom"
	company_name  = "NanoTrasen"
	company_short = "NT"
	starsys_name  = "Lythios-43"

	shuttle_docked_message = "The scheduled NSV Herra spaceplane flight to the %dock_name% has arrived. It will depart in approximately %ETD%."
	shuttle_leaving_dock = "The NSV Herra has left the station. Estimate %ETA% until the spaceplane arrives at the %dock_name%."
	shuttle_called_message = "A scheduled crew transfer to the %dock_name% is occuring. The NSV Herra will be arriving shortly. Those departing should proceed to departures within %ETA%."
	shuttle_recall_message = "The scheduled crew transfer flight has been cancelled."
	emergency_shuttle_docked_message = "The evacuation flight has landed at the landing pad. You have approximately %ETD% to board the vessel."
	emergency_shuttle_leaving_dock = "The emergency flight has left the station. Estimate %ETA% until the vessel arrives at %dock_name%."
	emergency_shuttle_called_message = "An emergency evacuation has begun, and an emergency response flight has been called. It will arrive at the landing pad in approximately %ETA%."
	emergency_shuttle_recall_message = "The evacuation flight has been cancelled."

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
							NETWORK_RESEARCH,
							NETWORK_RESEARCH_OUTPOST,
							NETWORK_ROBOTS,
							NETWORK_PRISON,
							NETWORK_SECURITY,
							NETWORK_INTERROGATION
							)

	allowed_spawns = list("Docking Pad","Gateway","Cryogenic Storage","Cyborg Storage")
	spawnpoint_died = /datum/spawnpoint/tram
	spawnpoint_left = /datum/spawnpoint/tram
	spawnpoint_stayed = /datum/spawnpoint/cryo

	meteor_strike_areas = list(/area/rift/surfacebase/outside/outside3)
/*
	unit_test_exempt_areas = list(
		/area/rift/surfacebase/outside/outside1,
		/area/vacant/vacant_site,
		/area/vacant/vacant_site/east,
		/area/crew_quarters/sleep/Dorm_1/holo,
		/area/crew_quarters/sleep/Dorm_3/holo,
		/area/crew_quarters/sleep/Dorm_5/holo,
		/area/crew_quarters/sleep/Dorm_7/holo)
	unit_test_exempt_from_atmos = list(
		/area/engineering/atmos/intake, // Outside,
		/area/rnd/external, //  Outside,
		/area/tether/surfacebase/mining_main/external, // Outside,
		/area/tether/surfacebase/mining_main/airlock, //  Its an airlock,
		/area/tether/surfacebase/emergency_storage/rnd,
		/area/tether/surfacebase/emergency_storage/atrium)
*/
/*
	lateload_z_levels = list(
		list("Tether - Misc","Tether - Ships","Tether - Underdark"), //Stock Tether lateload maps
		list("Alien Ship - Z1 Ship"),
		list("Desert Planet - Z1 Beach","Desert Planet - Z2 Cave"),
		list("Remmi Aerostat - Z1 Aerostat","Remmi Aerostat - Z2 Surface")
		)

	lateload_single_pick = null //Nothing right now.
*/
/*
/datum/map/tether/perform_map_generation()

	new /datum/random_map/automata/cave_system/no_cracks(null, 1, 1, Z_LEVEL_SURFACE_MINE, world.maxx, world.maxy) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, Z_LEVEL_SURFACE_MINE, 64, 64)         // Create the mining ore distribution map.

	new /datum/random_map/automata/cave_system/no_cracks(null, 1, 1, Z_LEVEL_SOLARS, world.maxx, world.maxy) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, Z_LEVEL_SOLARS, 64, 64)         // Create the mining ore distribution map.

	return 1
*/
// Short range computers see only the six main levels, others can see the surrounding surface levels.
/datum/map/rift/get_map_levels(var/srcz, var/long_range = TRUE)
	if (long_range && (srcz in map_levels))
		return map_levels
	else if (srcz == Z_LEVEL_TRANSIT)
		return list() // Nothing on transit!
	else if (srcz >= Z_LEVEL_UNDERGROUND_DEEP && srcz <= Z_LEVEL_SURFACE_MID)
		return list(
			Z_LEVEL_UNDERGROUND_DEEP,
			Z_LEVEL_UNDERGROUND,
			Z_LEVEL_SURFACE_LOW,
			Z_LEVEL_SURFACE_MID)
	else
		return list(srcz)
/*
/datum/map/southern_cross/get_map_levels(var/srcz, var/long_range = TRUE)
	if (long_range && (srcz in map_levels))
		return map_levels
	else if (srcz == Z_LEVEL_TRANSIT)
		return list() // Nothing on transit!
	else if (srcz >= Z_LEVEL_STATION_ONE && srcz <= Z_LEVEL_STATION_THREE) // Station can see other decks.
		return list(
			Z_LEVEL_STATION_ONE,
			Z_LEVEL_STATION_TWO,
			Z_LEVEL_STATION_THREE)
	else if(srcz in list(Z_LEVEL_SURFACE, Z_LEVEL_SURFACE_MINE, Z_LEVEL_SURFACE_WILD)) // Being on the surface lets you see other surface Zs.
		return list(
			Z_LEVEL_SURFACE,
			Z_LEVEL_SURFACE_MINE,
			Z_LEVEL_SURFACE_WILD)
	else
		return ..()
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
	base_turf = /turf/simulated/floor/outdoors/ice/lythios43c
//	holomap_offset_x = TETHER_HOLOMAP_MARGIN_X
//	holomap_offset_y = TETHER_HOLOMAP_MARGIN_Y + TETHER_MAP_SIZE*0

/datum/map_z_level/tether/station/surface_mid
	z = Z_LEVEL_SURFACE_MID
	name = "Surface 2"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_SEALED|MAP_LEVEL_XENOARCH_EXEMPT
	base_turf = /turf/simulated/open
//	holomap_offset_x = TETHER_HOLOMAP_MARGIN_X
//	holomap_offset_y = TETHER_HOLOMAP_MARGIN_Y + TETHER_MAP_SIZE*1
/*
/datum/map_z_level/tether/station/surface_high
	z = Z_LEVEL_SURFACE_HIGH
	name = "Surface 3"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_SEALED|MAP_LEVEL_XENOARCH_EXEMPT
	base_turf = /turf/simulated/open
	holomap_offset_x = TETHER_HOLOMAP_MARGIN_X
	holomap_offset_y = TETHER_HOLOMAP_MARGIN_Y + TETHER_MAP_SIZE*2

/datum/map_z_level/tether/transit
	z = Z_LEVEL_TRANSIT
	name = "Transit"
	flags = MAP_LEVEL_SEALED|MAP_LEVEL_PLAYER|MAP_LEVEL_CONTACT|MAP_LEVEL_XENOARCH_EXEMPT

/datum/map_z_level/tether/station/space_low
	z = Z_LEVEL_SPACE_LOW
	name = "Asteroid 1"
	base_turf = /turf/space
	transit_chance = 33
	holomap_offset_x = HOLOMAP_ICON_SIZE - TETHER_HOLOMAP_MARGIN_X - TETHER_MAP_SIZE
	holomap_offset_y = TETHER_HOLOMAP_MARGIN_Y + TETHER_MAP_SIZE*0

/datum/map_z_level/tether/station/space_mid
	z = Z_LEVEL_SPACE_MID
	name = "Asteroid 2"
	base_turf = /turf/simulated/open
	transit_chance = 33
	holomap_offset_x = HOLOMAP_ICON_SIZE - TETHER_HOLOMAP_MARGIN_X - TETHER_MAP_SIZE
	holomap_offset_y = TETHER_HOLOMAP_MARGIN_Y + TETHER_MAP_SIZE*1

/datum/map_z_level/tether/station/space_high
	z = Z_LEVEL_SPACE_HIGH
	name = "Asteroid 3"
	base_turf = /turf/simulated/open
	transit_chance = 33
	holomap_offset_x = HOLOMAP_ICON_SIZE - TETHER_HOLOMAP_MARGIN_X - TETHER_MAP_SIZE
	holomap_offset_y = TETHER_HOLOMAP_MARGIN_Y + TETHER_MAP_SIZE*2

/datum/map_z_level/tether/mine
	z = Z_LEVEL_SURFACE_MINE
	name = "Mining Outpost"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER
	base_turf = /turf/simulated/floor/outdoors/rocks/virgo3b

/datum/map_z_level/tether/solars
	z = Z_LEVEL_SOLARS
	name = "Solar Field"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER
	base_turf = /turf/simulated/floor/outdoors/rocks/virgo3b

/datum/map_z_level/tether/colony
	z = Z_LEVEL_CENTCOM
	name = "Colony"
	flags = MAP_LEVEL_ADMIN|MAP_LEVEL_CONTACT|MAP_LEVEL_XENOARCH_EXEMPT

/datum/map_z_level/tether/misc
	z = Z_LEVEL_MISC
	name = "Misc"
	flags = MAP_LEVEL_ADMIN|MAP_LEVEL_XENOARCH_EXEMPT
*/
/*
/datum/map_z_level/tether/wilderness
	name = "Wilderness"
	flags = MAP_LEVEL_PLAYER
	var/activated = 0
	var/list/frozen_mobs = list()

/datum/map_z_level/tether/wilderness/proc/activate_mobs()
	if(activated && isemptylist(frozen_mobs))
		return
	activated = 1
	for(var/mob/living/simple_animal/M in frozen_mobs)
		M.life_disabled = 0
		frozen_mobs -= M
	frozen_mobs.Cut()

/datum/map_z_level/tether/wilderness/wild_1
	z = Z_LEVEL_SURFACE_WILDERNESS_1

/datum/map_z_level/tether/wilderness/wild_2
	z = Z_LEVEL_SURFACE_WILDERNESS_2

/datum/map_z_level/tether/wilderness/wild_3
	z = Z_LEVEL_SURFACE_WILDERNESS_3

/datum/map_z_level/tether/wilderness/wild_4
	z = Z_LEVEL_SURFACE_WILDERNESS_4

/datum/map_z_level/tether/wilderness/wild_5
	z = Z_LEVEL_SURFACE_WILDERNESS_5

/datum/map_z_level/tether/wilderness/wild_6
	z = Z_LEVEL_SURFACE_WILDERNESS_6

/datum/map_z_level/tether/wilderness/wild_crash
	z = Z_LEVEL_SURFACE_WILDERNESS_CRASH

/datum/map_z_level/tether/wilderness/wild_ruins
	z = Z_LEVEL_SURFACE_WILDERNESS_RUINS
*/
