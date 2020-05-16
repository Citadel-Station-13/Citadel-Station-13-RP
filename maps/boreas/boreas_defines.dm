//Atmosphere properties
#define BOREAS_ONE_ATMOSPHERE	82.4 //kPa
#define BOREAS_AVG_TEMP	234 //kelvin

#define BOREAS_PER_N2		0.74 //percent
#define BOREAS_PER_O2		0.18
#define BOREAS_PER_N2O		0.00 //Currently no capacity to 'start' a turf with this. See turf.dm
#define BOREAS_PER_CO2		0.07
#define BOREAS_PER_PHORON	0.01

//Math only beyond this point
#define BOREAS_MOL_PER_TURF	(BOREAS_ONE_ATMOSPHERE*CELL_VOLUME/(BOREAS_AVG_TEMP*R_IDEAL_GAS_EQUATION))
#define BOREAS_MOL_N2			(BOREAS_MOL_PER_TURF * BOREAS_PER_N2)
#define BOREAS_MOL_O2			(BOREAS_MOL_PER_TURF * BOREAS_PER_O2)
#define BOREAS_MOL_N2O			(BOREAS_MOL_PER_TURF * BOREAS_PER_N2O)
#define BOREAS_MOL_CO2			(BOREAS_MOL_PER_TURF * BOREAS_PER_CO2)
#define BOREAS_MOL_PHORON		(BOREAS_MOL_PER_TURF * BOREAS_PER_PHORON)

//Turfmakers
#define BOREAS_SET_ATMOS	nitrogen=BOREAS_MOL_N2;oxygen=BOREAS_MOL_O2;carbon_dioxide=BOREAS_MOL_CO2;phoron=BOREAS_MOL_PHORON;temperature=BOREAS_AVG_TEMP
#define BOREAS_TURF_CREATE(x)	x/boreas/nitrogen=BOREAS_MOL_N2;x/boreas/oxygen=BOREAS_MOL_O2;x/boreas/carbon_dioxide=BOREAS_MOL_CO2;x/boreas/phoron=BOREAS_MOL_PHORON;x/boreas/temperature=BOREAS_AVG_TEMP;x/boreas/outdoors=TRUE;x/boreas/update_graphic(list/graphic_add = null, list/graphic_remove = null) return 0
#define BOREAS_TURF_CREATE_UN(x)	x/boreas/nitrogen=BOREAS_MOL_N2;x/boreas/oxygen=BOREAS_MOL_O2;x/boreas/carbon_dioxide=BOREAS_MOL_CO2;x/boreas/phoron=BOREAS_MOL_PHORON;x/boreas/temperature=BOREAS_AVG_TEMP

//Normal map defs
#define Z_LEVEL_SURFACE_UNDER				1
#define Z_LEVEL_SURFACE_LOW					2
#define Z_LEVEL_SURFACE_MID					3

/datum/map/boreas
	name = "Boreas"
	full_name = "Boreas PRC"
	path = "boreas"


	lobby_icon = 'icons/misc/title_vr.dmi'
	lobby_screens = list("title1", "title2", "title3", "title4", "title5", "title6")
	id_hud_icons = 'icons/mob/hud_jobs_vr.dmi'


	station_name  = "Boreas Phoron Research Center"
	station_short = "Boreas"
	dock_name     = "Boreas Mass Driver"
	boss_name     = "Central Command"
	boss_short    = "CentCom"
	company_name  = "NanoTrasen"
	company_short = "NT"
	starsys_name  = "TBA"

	shuttle_docked_message = "The mass driver is prepping for launch to the %dock_name% has arrived. It will depart in launch %ETD%."
	shuttle_leaving_dock = "The mass driver has fired. Estimate %ETA% until the pod arrives at %dock_name%."
	shuttle_called_message = "A scheduled crew transfer to the %dock_name% is occuring. The pod will be firing shortly. Those departing should proceed to the mass driver within %ETA%."
	shuttle_recall_message = "The scheduled crew transfer has been cancelled."
	emergency_shuttle_docked_message = "The evacuation pod has arrived at the tram station. You have approximately %ETD% to board the pod."
	emergency_shuttle_leaving_dock = "The emergency pod has left the station. Estimate %ETA% until the pod arrives at %dock_name%."
	emergency_shuttle_called_message = "An emergency evacuation has begun, and an off-schedule pod has been called. It will be ready to fire in approximately %ETA%."
	emergency_shuttle_recall_message = "The evacuation pod has been cancelled."

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

/*	allowed_spawns = list("Tram Station","Gateway","Cryogenic Storage","Cyborg Storage")
	spawnpoint_died = /datum/spawnpoint/tram
	spawnpoint_left = /datum/spawnpoint/tram
	spawnpoint_stayed = /datum/spawnpoint/cryo

	meteor_strike_areas = list(/area/boreas/surfacebase/outside/outside3)

	unit_test_exempt_areas = list(
		/area/boreas/surfacebase/outside/outside1,
		/area/vacant/vacant_site,
		/area/vacant/vacant_site/east,
		/area/crew_quarters/sleep/Dorm_1/holo,
		/area/crew_quarters/sleep/Dorm_3/holo,
		/area/crew_quarters/sleep/Dorm_5/holo,
		/area/crew_quarters/sleep/Dorm_7/holo)
	unit_test_exempt_from_atmos = list(
		/area/engineering/atmos/intake, // Outside,
		/area/rnd/external, //  Outside,
		/area/boreas/surfacebase/mining_main/external, // Outside,
		/area/boreas/surfacebase/mining_main/airlock, //  Its an airlock,
		/area/boreas/surfacebase/emergency_storage/rnd,
		/area/boreas/surfacebase/emergency_storage/atrium)

	lateload_z_levels = list(
		list("Boreas - Misc","Boreas - Ships","Boreas - Underdark"), //Stock Boreas lateload maps
		list("Alien Ship - Z1 Ship"),
		list("Desert Planet - Z1 Beach","Desert Planet - Z2 Cave"),
		list("Remmi Aerostat - Z1 Aerostat","Remmi Aerostat - Z2 Surface")
		)

	lateload_single_pick = null //Nothing right now.

/datum/map/boreas/perform_map_generation()

	new /datum/random_map/automata/cave_system/no_cracks(null, 1, 1, Z_LEVEL_SURFACE_MINE, world.maxx, world.maxy) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, Z_LEVEL_SURFACE_MINE, 64, 64)         // Create the mining ore distribution map.

	new /datum/random_map/automata/cave_system/no_cracks(null, 1, 1, Z_LEVEL_SOLARS, world.maxx, world.maxy) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, Z_LEVEL_SOLARS, 64, 64)         // Create the mining ore distribution map.

	return 1

// Short range computers see only the six main levels, others can see the surrounding surface levels.
/datum/map/boreas/get_map_levels(var/srcz, var/long_range = TRUE)
	if (long_range && (srcz in map_levels))
		return map_levels
	else if (srcz == Z_LEVEL_TRANSIT)
		return list() // Nothing on transit!
	else if (srcz >= Z_LEVEL_SURFACE_LOW && srcz <= Z_LEVEL_SPACE_HIGH)
		return list(
			Z_LEVEL_SURFACE_LOW,
			Z_LEVEL_SURFACE_MID,
			Z_LEVEL_SURFACE_HIGH,
			Z_LEVEL_SPACE_LOW,
			Z_LEVEL_SPACE_MID,
			Z_LEVEL_SPACE_HIGH)
	else
		return list(srcz) //may prevent runtimes, but more importantly gives gps units a shortwave-esque function

// For making the 6-in-1 holomap, we calculate some offsets
#define TETHER_MAP_SIZE 140 // Width and height of compiled in boreas z levels.
#define TETHER_HOLOMAP_CENTER_GUTTER 40 // 40px central gutter between columns
#define TETHER_HOLOMAP_MARGIN_X ((HOLOMAP_ICON_SIZE - (2*TETHER_MAP_SIZE) - TETHER_HOLOMAP_CENTER_GUTTER) / 2) // 100
#define TETHER_HOLOMAP_MARGIN_Y ((HOLOMAP_ICON_SIZE - (3*TETHER_MAP_SIZE)) / 2) // 60

// We have a bunch of stuff common to the station z levels
/datum/map_z_level/boreas/station
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_XENOARCH_EXEMPT
	holomap_legend_x = 220
	holomap_legend_y = 160

/datum/map_z_level/boreas/station/surface_low
	z = Z_LEVEL_SURFACE_LOW
	name = "Surface 1"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_SEALED|MAP_LEVEL_XENOARCH_EXEMPT
	base_turf = /turf/simulated/floor/outdoors/rocks/boreas
	holomap_offset_x = TETHER_HOLOMAP_MARGIN_X
	holomap_offset_y = TETHER_HOLOMAP_MARGIN_Y + TETHER_MAP_SIZE*0

/datum/map_z_level/boreas/station/surface_mid
	z = Z_LEVEL_SURFACE_MID
	name = "Surface 2"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_SEALED|MAP_LEVEL_XENOARCH_EXEMPT
	base_turf = /turf/simulated/open
	holomap_offset_x = TETHER_HOLOMAP_MARGIN_X
	holomap_offset_y = TETHER_HOLOMAP_MARGIN_Y + TETHER_MAP_SIZE*1

/datum/map_z_level/boreas/station/surface_high
	z = Z_LEVEL_SURFACE_HIGH
	name = "Surface 3"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_SEALED|MAP_LEVEL_XENOARCH_EXEMPT
	base_turf = /turf/simulated/open
	holomap_offset_x = TETHER_HOLOMAP_MARGIN_X
	holomap_offset_y = TETHER_HOLOMAP_MARGIN_Y + TETHER_MAP_SIZE*2

/datum/map_z_level/boreas/transit
	z = Z_LEVEL_TRANSIT
	name = "Transit"
	flags = MAP_LEVEL_SEALED|MAP_LEVEL_PLAYER|MAP_LEVEL_CONTACT|MAP_LEVEL_XENOARCH_EXEMPT

/datum/map_z_level/boreas/station/space_low
	z = Z_LEVEL_SPACE_LOW
	name = "Asteroid 1"
	base_turf = /turf/space
	transit_chance = 33
	holomap_offset_x = HOLOMAP_ICON_SIZE - TETHER_HOLOMAP_MARGIN_X - TETHER_MAP_SIZE
	holomap_offset_y = TETHER_HOLOMAP_MARGIN_Y + TETHER_MAP_SIZE*0

/datum/map_z_level/boreas/station/space_mid
	z = Z_LEVEL_SPACE_MID
	name = "Asteroid 2"
	base_turf = /turf/simulated/open
	transit_chance = 33
	holomap_offset_x = HOLOMAP_ICON_SIZE - TETHER_HOLOMAP_MARGIN_X - TETHER_MAP_SIZE
	holomap_offset_y = TETHER_HOLOMAP_MARGIN_Y + TETHER_MAP_SIZE*1

/datum/map_z_level/boreas/station/space_high
	z = Z_LEVEL_SPACE_HIGH
	name = "Asteroid 3"
	base_turf = /turf/simulated/open
	transit_chance = 33
	holomap_offset_x = HOLOMAP_ICON_SIZE - TETHER_HOLOMAP_MARGIN_X - TETHER_MAP_SIZE
	holomap_offset_y = TETHER_HOLOMAP_MARGIN_Y + TETHER_MAP_SIZE*2

/datum/map_z_level/boreas/mine
	z = Z_LEVEL_SURFACE_MINE
	name = "Mining Outpost"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER
	base_turf = /turf/simulated/floor/outdoors/rocks/boreas

/datum/map_z_level/boreas/solars
	z = Z_LEVEL_SOLARS
	name = "Solar Field"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER
	base_turf = /turf/simulated/floor/outdoors/rocks/boreas

/datum/map_z_level/boreas/colony
	z = Z_LEVEL_CENTCOM
	name = "Colony"
	flags = MAP_LEVEL_ADMIN|MAP_LEVEL_CONTACT|MAP_LEVEL_XENOARCH_EXEMPT

/datum/map_z_level/boreas/misc
	z = Z_LEVEL_MISC
	name = "Misc"
	flags = MAP_LEVEL_ADMIN|MAP_LEVEL_XENOARCH_EXEMPT

/*
/datum/map_z_level/boreas/wilderness
	name = "Wilderness"
	flags = MAP_LEVEL_PLAYER
	var/activated = 0
	var/list/frozen_mobs = list()

/datum/map_z_level/boreas/wilderness/proc/activate_mobs()
	if(activated && !length(frozen_mobs))
		return
	activated = 1
	for(var/mob/living/simple_animal/M in frozen_mobs)
		M.life_disabled = 0
		frozen_mobs -= M
	frozen_mobs.Cut()

/datum/map_z_level/boreas/wilderness/wild_1
	z = Z_LEVEL_SURFACE_WILDERNESS_1

/datum/map_z_level/boreas/wilderness/wild_2
	z = Z_LEVEL_SURFACE_WILDERNESS_2

/datum/map_z_level/boreas/wilderness/wild_3
	z = Z_LEVEL_SURFACE_WILDERNESS_3

/datum/map_z_level/boreas/wilderness/wild_4
	z = Z_LEVEL_SURFACE_WILDERNESS_4

/datum/map_z_level/boreas/wilderness/wild_5
	z = Z_LEVEL_SURFACE_WILDERNESS_5

/datum/map_z_level/boreas/wilderness/wild_6
	z = Z_LEVEL_SURFACE_WILDERNESS_6

/datum/map_z_level/boreas/wilderness/wild_crash
	z = Z_LEVEL_SURFACE_WILDERNESS_CRASH

/datum/map_z_level/boreas/wilderness/wild_ruins
	z = Z_LEVEL_SURFACE_WILDERNESS_RUINS
*/
*/