//Atmosphere properties
#define VIRGO3B_ONE_ATMOSPHERE	82.4 //kPa
#define VIRGO3B_AVG_TEMP	234 //kelvin

#define VIRGO3B_PER_N2		0.16 //percent
#define VIRGO3B_PER_O2		0.00
#define VIRGO3B_PER_N2O		0.00 //Currently no capacity to 'start' a turf with this. See turf.dm
#define VIRGO3B_PER_CO2		0.12
#define VIRGO3B_PER_PHORON	0.72

//Math only beyond this point
#define VIRGO3B_MOL_PER_TURF	(VIRGO3B_ONE_ATMOSPHERE*CELL_VOLUME/(VIRGO3B_AVG_TEMP*R_IDEAL_GAS_EQUATION))
#define VIRGO3B_MOL_N2			(VIRGO3B_MOL_PER_TURF * VIRGO3B_PER_N2)
#define VIRGO3B_MOL_O2			(VIRGO3B_MOL_PER_TURF * VIRGO3B_PER_O2)
#define VIRGO3B_MOL_N2O			(VIRGO3B_MOL_PER_TURF * VIRGO3B_PER_N2O)
#define VIRGO3B_MOL_CO2			(VIRGO3B_MOL_PER_TURF * VIRGO3B_PER_CO2)
#define VIRGO3B_MOL_PHORON		(VIRGO3B_MOL_PER_TURF * VIRGO3B_PER_PHORON)

//Turfmakers
#define VIRGO3B_SET_ATMOS	nitrogen=VIRGO3B_MOL_N2;oxygen=VIRGO3B_MOL_O2;carbon_dioxide=VIRGO3B_MOL_CO2;phoron=VIRGO3B_MOL_PHORON;temperature=VIRGO3B_AVG_TEMP
#define VIRGO3B_TURF_CREATE(x)	x/virgo3b/nitrogen=VIRGO3B_MOL_N2;x/virgo3b/oxygen=VIRGO3B_MOL_O2;x/virgo3b/carbon_dioxide=VIRGO3B_MOL_CO2;x/virgo3b/phoron=VIRGO3B_MOL_PHORON;x/virgo3b/temperature=VIRGO3B_AVG_TEMP;x/virgo3b/outdoors=TRUE;x/virgo3b/update_graphic(list/graphic_add = null, list/graphic_remove = null) return 0
#define VIRGO3B_TURF_CREATE_UN(x)	x/virgo3b/nitrogen=VIRGO3B_MOL_N2;x/virgo3b/oxygen=VIRGO3B_MOL_O2;x/virgo3b/carbon_dioxide=VIRGO3B_MOL_CO2;x/virgo3b/phoron=VIRGO3B_MOL_PHORON;x/virgo3b/temperature=VIRGO3B_AVG_TEMP

#define Z_LEVEL_SURFACE_LOW					1
#define Z_LEVEL_SURFACE_MID					2
#define Z_LEVEL_SURFACE_HIGH				3
#define Z_LEVEL_TRANSIT						4
#define Z_LEVEL_SPACE_LOW					5
#define Z_LEVEL_SPACE_MID					6
#define Z_LEVEL_SPACE_HIGH					7
#define Z_LEVEL_SURFACE_MINE				8
#define Z_LEVEL_SOLARS						9
#define Z_LEVEL_CENTCOM						10

/*
//Normal map defs
#define Z_LEVEL_MISC						11
#define Z_LEVEL_SHIPS						12
#define Z_LEVEL_UNDERDARK					13
#define Z_LEVEL_ALIENSHIP					14
#define Z_LEVEL_BEACH						15
#define Z_LEVEL_BEACH_CAVE					16
#define Z_LEVEL_AEROSTAT					17
#define Z_LEVEL_AEROSTAT_SURFACE			18
*/

#define DEFAULT_MAP_TRAITS \
	list(\
	DECLARE_LEVEL("Surface 1", list(ZTRAIT_STATION = TRUE, ZTRAIT_UP = 1, ZTRAIT_BASETURF = /turf/simulated/floor/outdoors/grass/sif/virgo3b, ZTRAIT_LINKAGE = STATIC, ZTRAIT_LEVEL_ID = "TETHER_SURFACE_1", ZTRAIT_TRANSITION_ID_NORTH = "TETHER_SURFACE_MINE", ZTRAIT_TRANSITION_ID_SOUTH = "TETHER_SURFACE_PLAINS", ZTRAIT_TRANSITION_ID_WEST = "TETHER_SURFACE_SOLARS", ZTRAIT_TRANSITION_MODE = ZTRANSITION_MODE_STEP_TELEPORTER, ZTRAIT_TRANSITION_PADDING = 2)),\
	DECLARE_LEVEL("Surface 2", list(ZTRAIT_STATION = TRUE, ZTRAIT_UP = 1, ZTRAIT_DOWN = -1, ZTRAIT_BASETURF = /turf/simulated/open)),\
	DECLARE_LEVEL("Surface 3", list(ZTRAIT_STATION = TRUE, ZTRAIT_DOWN = -1, ZTRAIT_BASETURF = /turf/simulated/open)),\
	DECLARE_LEVEL("ELEVATOR MIDPOINT", list(ZTRAIT_BASETURF = /turf/simulated/floor/plating)),\
	DECLARE_LEVEL("Station 1", list(ZTRAIT_STATION = TRUE, ZTRAIT_UP = 1, ZTRAIT_LINKAGE = CROSSLINKED, ZTRAIT_BASETURF = /turf/space)),\
	DECLARE_LEVEL("Station 2", list(ZTRAIT_STATION = TRUE, ZTRAIT_UP = 1, ZTRAIT_DOWN = -1, ZTRAIT_LINKAGE = CROSSLINKED, ZTRAIT_BASETURF = /turf/space)),\
	DECLARE_LEVEL("Station 3", list(ZTRAIT_STATION = TRUE, ZTRAIT_DOWN = -1, ZTRAIT_LINKAGE = CROSSLINKED, ZTRAIT_BASETURF = /turf/space)),\
	DECLARE_LEVEL("Surface Mine", list(ZTRAIT_STATION = TRUE, ZTRAIT_MINE = TRUE, ZTRAIT_BOMBCAP_MULTIPLIER = 2.5, ZTRAIT_BASETURF = /turf/simulated/floor/outdoors/grass/sif/virgo3b, ZTRAIT_LINKAGE = STATIC, ZTRAIT_LEVEL_ID = "TETHER_SURFACE_MINE", ZTRAIT_TRANSITION_ID_SOUTH = "TETHER_SURFACE_1", ZTRAIT_TRANSITION_MODE = ZTRANSITION_MODE_STEP_TELEPORTER, ZTRAIT_TRANSITION_PADDING = 2)),\
	DECLARE_LEVEL("Surface Solars", list(ZTRAIT_STATION = TRUE, ZTRAIT_MINE = TRUE, ZTRAIT_BASETURF = /turf/simulated/floor/outdoors/grass/sif/virgo3b, ZTRAIT_LINKAGE = STATIC, ZTRAIT_LEVEL_ID = "TETHER_SURFACE_SOLARS", ZTRAIT_TRANSITION_ID_EAST = "TETHER_SURFACE_1", ZTRAIT_TRANSITION_MODE = ZTRANSITION_MODE_STEP_TELEPORTER, ZTRAIT_TRANSITION_PADDING = 2)),\
	DECLARE_LEVEL("CentComm", list(ZTRAIT_CENTCOM = TRUE, ZTRAIT_BASETURF = /turf/simulated/floor/outdoors/grass/sif/virgo3b)),\
	)
	/*
	DECLARE_LEVEL("Misc", list(ZTRAIT_CENTCOM = TRUE)),\
	DECLARE_LEVEL("Ships", list(ZTRAIT_CENTCOM = TRUE)),\
	DECLARE_LEVEL("Underdark", list(ZTRAIT_STATION = TRUE, ZTRAIT_MINE = TRUE, ZTRAIT_BOMBCAP_MULTIPLIER = 3.5)),\
	DECLARE_LEVEL("Alien Ship", list(ZTRAIT_AWAY = TRUE, ZTRAIT_LINKAGE = SELFLOOPING)),\
	DECLARE_LEVEL("V2 Beach", list(ZTRAIT_AWAY = TRUE)),\
	DECLARE_LEVEL("V2 Caves", list(ZTRAIT_AWAY = TRUE, ZTRAIT_MINE = TRUE)),\
	DECLARE_LEVEL("V4 Aerostat", list(ZTRAIT_AWAY = TRUE, ZTRAIT_DOWN = -1)),\
	DECLARE_LEVEL("V4 Surface", list(ZTRAIT_AWAY = TRUE, ZTRAIT_UP = 1))\
	*/

//Doing an override like this does not make me happy but it makes things work until runtime maploading..
/datum/controller/subsystem/mapping/InitializeDefaultZLevels()
	if (z_list)  // subsystem/Recover or badminnery, no need
		return

	z_list = list()
	var/list/default_map_traits = DEFAULT_MAP_TRAITS

	if (default_map_traits.len != world.maxz)
		stack_trace("More or less map attributes pre-defined ([default_map_traits.len]) than existent z-levels ([world.maxz]). Ignoring the larger.")
		if (default_map_traits.len > world.maxz)
			default_map_traits.Cut(world.maxz + 1)

	for (var/I in 1 to default_map_traits.len)
		var/list/features = default_map_traits[I]
		var/datum/space_level/S = new(I, features[DL_NAME], features[DL_TRAITS])
		z_list += S

/datum/map/tether
	name = "Virgo"
	full_name = "NSB Adephagia"
	path = "tether"

	zlevel_datum_type = /datum/map_z_level/tether

	lobby_icon = 'icons/misc/title_vr.dmi'
	lobby_screens = list("title1", "title2", "title3", "title4", "title5", "title6")
	id_hud_icons = 'icons/mob/hud_jobs_vr.dmi' //CITADEL CHANGE: Ignore this line because it's going to be overriden in modular_citadel\maps\tether\tether_defines.dm

	holomap_smoosh = list(list(
		Z_LEVEL_SURFACE_LOW,
		Z_LEVEL_SURFACE_MID,
		Z_LEVEL_SURFACE_HIGH,
		Z_LEVEL_SPACE_LOW,
		Z_LEVEL_SPACE_MID,
		Z_LEVEL_SPACE_HIGH))

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

	allowed_spawns = list("Tram Station","Gateway","Cryogenic Storage","Cyborg Storage")
	spawnpoint_died = /datum/spawnpoint/tram
	spawnpoint_left = /datum/spawnpoint/tram
	spawnpoint_stayed = /datum/spawnpoint/cryo

	meteor_strike_areas = list(/area/tether/surfacebase/outside/outside3)

	unit_test_exempt_areas = list(
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
		/area/tether/surfacebase/emergency_storage/atrium)

	lateload_z_levels = list(
		list(
			"tether_misc" = list(ZTRAIT_CENTCOM = TRUE, ZTRAIT_BASETURF = /turf/space),
			"tether_ships" = list(ZTRAIT_CENTCOM = TRUE, ZTRAIT_BASETURF = /turf/space),
			"tether_underdark" = list(ZTRAIT_STATION = TRUE, ZTRAIT_MINE = TRUE, ZTRAIT_BOMBCAP_MULTIPLIER = 3.5, ZTRAIT_BASETURF = /turf/simulated/mineral/virgo3b/rich)
		),
		list(
			"abductor_mothership" = list(ZTRAIT_AWAY = TRUE, ZTRAIT_LINKAGE = SELFLOOPING, ZTRAIT_BASETURF = /turf/space)
		),
		list(
			"v4_beach" = list(ZTRAIT_AWAY = TRUE, ZTRAIT_BASETURF = /turf/simulated/floor/beach/sand/desert),
			"v4_cave" = list(ZTRAIT_AWAY = TRUE, ZTRAIT_MINE = TRUE, ZTRAIT_BASETURF = /turf/simulated/floor/beach/sand/desert)
		),
		list(
			"v2_sky" = list(ZTRAIT_AWAY = TRUE, ZTRAIT_DOWN = -1, ZTRAIT_BASETURF = /turf/unsimulated/floor/sky/virgo2_sky),
			"v2_surface" = list(ZTRAIT_AWAY = TRUE, ZTRAIT_UP = 1, ZTRAIT_BASETURF = /turf/simulated/mineral/floor/ignore_mapgen/virgo2)
		),
		list(
			"tether_debrisfield" = list(ZTRAIT_AWAY = TRUE, ZTRAIT_LINKAGE = SELFLOOPING, ZTRAIT_BASETURF = /turf/space)
		),
		list(
			"tether_plains" = list(ZTRAIT_AWAY = TRUE, ZTRAIT_BASETURF = /turf/simulated/mineral/floor/virgo3b, ZTRAIT_LEVEL_ID = "TETHER_SURFACE_PLAINS", ZTRAIT_LINKAGE = STATIC, ZTRAIT_TRANSITION_ID_NORTH = "TETHER_SURFACE_1", ZTRAIT_TRANSITION_MODE = ZTRANSITION_MODE_STEP_TELEPORTER, ZTRAIT_TRANSITION_PADDING = 2)
		)
	)

/datum/map/tether/perform_map_generation()

	new /datum/random_map/automata/cave_system/no_cracks(null, 1, 1, Z_LEVEL_SURFACE_MINE, world.maxx, world.maxy) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, Z_LEVEL_SURFACE_MINE, 64, 64)		// Create the mining ore distribution map.

	new /datum/random_map/automata/cave_system/no_cracks(null, 1, 1, Z_LEVEL_SOLARS, world.maxx, world.maxy) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, Z_LEVEL_SOLARS, 64, 64)				// Create the mining ore distribution map.

	return 1

// Short range computers see only the six main levels, others can see the surrounding surface levels.
/datum/map/tether/get_map_levels(var/srcz, var/long_range = TRUE)
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
	name = "Misc"
	flags = MAP_LEVEL_ADMIN|MAP_LEVEL_XENOARCH_EXEMPT

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
	for(var/mob/living/simple_mob/M in frozen_mobs)
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
