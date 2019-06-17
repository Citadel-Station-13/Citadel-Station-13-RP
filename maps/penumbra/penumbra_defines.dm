//Atmosphere properties
#define NERADA8_ONE_ATMOSPHERE	126.8 //kPa
#define NERADA8_AVG_TEMP	234 //kelvin

#define NERADA8_PER_N2		0.75 //percent
#define NERADA8_PER_O2		0.22
#define NERADA8_PER_N2O		0.00 //Currently no capacity to 'start' a turf with this. See turf.dm
#define NERADA8_PER_CO2		0.03
#define NERADA8_PER_PHORON	0.00

//Math only beyond this point
#define NERADA8_MOL_PER_TURF	(NERADA8_ONE_ATMOSPHERE*CELL_VOLUME/(NERADA8_AVG_TEMP*R_IDEAL_GAS_EQUATION))
#define NERADA8_MOL_N2			(NERADA8_MOL_PER_TURF * NERADA8_PER_N2)
#define NERADA8_MOL_O2			(NERADA8_MOL_PER_TURF * NERADA8_PER_O2)
#define NERADA8_MOL_N2O			(NERADA8_MOL_PER_TURF * NERADA8_PER_N2O)
#define NERADA8_MOL_CO2			(NERADA8_MOL_PER_TURF * NERADA8_PER_CO2)
#define NERADA8_MOL_PHORON		(NERADA8_MOL_PER_TURF * NERADA8_PER_PHORON)

//Turfmakers
#define NERADA8_SET_ATMOS	nitrogen=NERADA8_MOL_N2;oxygen=NERADA8_MOL_O2;carbon_dioxide=NERADA8_MOL_CO2;phoron=NERADA8_MOL_PHORON;temperature=NERADA8_AVG_TEMP
#define NERADA8_TURF_CREATE(x)	x/nerada8/nitrogen=NERADA8_MOL_N2;x/nerada8/oxygen=NERADA8_MOL_O2;x/nerada8/carbon_dioxide=NERADA8_MOL_CO2;x/nerada8/phoron=NERADA8_MOL_PHORON;x/nerada8/temperature=NERADA8_AVG_TEMP;x/nerada8/outdoors=TRUE;x/nerada8/update_graphic(list/graphic_add = null, list/graphic_remove = null) return 0
#define NERADA8_TURF_CREATE_UN(x)	x/nerada8/nitrogen=NERADA8_MOL_N2;x/nerada8/oxygen=NERADA8_MOL_O2;x/nerada8/carbon_dioxide=NERADA8_MOL_CO2;x/nerada8/phoron=NERADA8_MOL_PHORON;x/nerada8/temperature=NERADA8_AVG_TEMP

//Normal map defs
#define Z_LEVEL_SURFACE_MAIN				1
#define Z_LEVEL_TRANSIT						2 //for now
#define Z_LEVEL_CENTCOM						3

/datum/map/penumbra
	name = "Penumbra"
	full_name = "NSB Adephagia"
	path = "penumbra"

	zlevel_datum_type = /datum/map_z_level/penumbra

	lobby_icon = 'icons/misc/title_vr.dmi'
	lobby_screens = list("title1", "title2", "title3", "title4", "title5", "title6")
	id_hud_icons = 'icons/mob/hud_jobs_vr.dmi' //CITADEL CHANGE: Ignore this line because it's going to be overriden in modular_citadel\maps\tether\tether_defines.dm

	/*holomap_smoosh = list(list(
		Z_LEVEL_SURFACE_LOW,
		Z_LEVEL_SURFACE_MID,
		Z_LEVEL_SURFACE_HIGH,
		Z_LEVEL_SPACE_LOW,
		Z_LEVEL_SPACE_MID,
		Z_LEVEL_SPACE_HIGH))*/

	station_name  = "NSB Adephagia"
	station_short = "Tether"
	dock_name     = "Virgo-3B Colony"
	boss_name     = "Central Command"
	boss_short    = "CentCom"
	company_name  = "NanoTrasen"
	company_short = "NT"
	starsys_name  = "Virgo-Erigone"

	shuttle_docked_message = "The scheduled Orange Line tram to the %dock_name% has arrived. It will depart in approximately %ETD%."
	shuttle_leaving_dock = "The Orange Line tram has left the station. Estimate %ETA% until the tram arrives at %dock_name%."
	shuttle_called_message = "A scheduled crew transfer to the %dock_name% is occuring. The tram will be arriving shortly. Those departing should proceed to the Orange Line tram station within %ETA%."
	shuttle_recall_message = "The scheduled crew transfer has been cancelled."
	emergency_shuttle_docked_message = "The evacuation tram has arrived at the tram station. You have approximately %ETD% to board the tram."
	emergency_shuttle_leaving_dock = "The emergency tram has left the station. Estimate %ETA% until the shuttle arrives at %dock_name%."
	emergency_shuttle_called_message = "An emergency evacuation has begun, and an off-schedule tram has been called. It will arrive at the tram station in approximately %ETA%."
	emergency_shuttle_recall_message = "The evacuation tram has been recalled."

	station_networks = list(
							NETWORK_CARGO,
							NETWORK_CIVILIAN,
							NETWORK_COMMAND,
							NETWORK_ENGINE,
							NETWORK_ENGINEERING,
							NETWORK_DEFAULT,
							NETWORK_MEDICAL,
							NETWORK_MINE,
							NETWORK_RESEARCH,
							NETWORK_ROBOTS,
							NETWORK_PRISON,
							NETWORK_SECURITY,
							NETWORK_INTERROGATION
							)

	allowed_spawns = list("Arrivals Shuttle","Gateway","Cryogenic Storage","Cyborg Storage")
	spawnpoint_died = /datum/spawnpoint/arrivals
	spawnpoint_left = /datum/spawnpoint/arrivals
	spawnpoint_stayed = /datum/spawnpoint/cryo

	//meteor_strike_areas = list(/area/tether/surfacebase/outside/outside3)

	/*unit_test_exempt_areas = list(
		/area/tether/surfacebase/outside/outside1,
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
		/area/tether/surfacebase/emergency_storage/atrium)*/

	/*lateload_z_levels = list(
		list("Tether - Misc","Tether - Ships","Tether - Underdark"), //Stock Tether lateload maps
		list("Alien Ship - Z1 Ship"),
		list("Desert Planet - Z1 Beach","Desert Planet - Z2 Cave"),
		list("Remmi Aerostat - Z1 Aerostat","Remmi Aerostat - Z2 Surface")
		)*/

	lateload_single_pick = null //Nothing right now.

/*/datum/map/tether/perform_map_generation()

	new /datum/random_map/automata/cave_system/no_cracks(null, 1, 1, Z_LEVEL_SURFACE_MINE, world.maxx, world.maxy) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, Z_LEVEL_SURFACE_MINE, 64, 64)         // Create the mining ore distribution map.

	new /datum/random_map/automata/cave_system/no_cracks(null, 1, 1, Z_LEVEL_SOLARS, world.maxx, world.maxy) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, Z_LEVEL_SOLARS, 64, 64)         // Create the mining ore distribution map.

	return 1*/

// Short range computers see only the six main levels, others can see the surrounding surface levels.
/*/datum/map/penumbra/get_map_levels(var/srcz, var/long_range = TRUE)
	if (long_range && (srcz in map_levels))
		return map_levels
	else if (srcz >= Z_LEVEL_SURFACE_LOW && srcz <= Z_LEVEL_SPACE_HIGH)
		return list(
			Z_LEVEL_SURFACE_MAIN,
			Z_LEVEL_SURFACE_MID,
			Z_LEVEL_SURFACE_HIGH,
			Z_LEVEL_SPACE_LOW,
			Z_LEVEL_SPACE_MID,
			Z_LEVEL_SPACE_HIGH)
	else
		return ..()
*/

/datum/map_z_level/penumbra/surface_main
	z = Z_LEVEL_SURFACE_MAIN
	name = "Surface"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_SEALED|MAP_LEVEL_XENOARCH_EXEMPT
	base_turf = /turf/simulated/floor/outdoors/rocks

/* 													No maps yet, obviously
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

/datum/map_z_level/tether/station/surface_low
	z = Z_LEVEL_SURFACE_LOW
	name = "Surface 1"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_SEALED|MAP_LEVEL_XENOARCH_EXEMPT
	base_turf = /turf/simulated/floor/outdoors/rocks/virgo3b
	holomap_offset_x = TETHER_HOLOMAP_MARGIN_X
	holomap_offset_y = TETHER_HOLOMAP_MARGIN_Y + TETHER_MAP_SIZE*0

/datum/map_z_level/tether/station/surface_mid
	z = Z_LEVEL_SURFACE_MID
	name = "Surface 2"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_SEALED|MAP_LEVEL_XENOARCH_EXEMPT
	base_turf = /turf/simulated/open
	holomap_offset_x = TETHER_HOLOMAP_MARGIN_X
	holomap_offset_y = TETHER_HOLOMAP_MARGIN_Y + TETHER_MAP_SIZE*1

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