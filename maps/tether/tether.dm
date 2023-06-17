/datum/map/station/tether
	id = "tether"
	name = "World - Tether"
	levels = list(

	)
	width = 140
	height = 140
	lateload = list(

	)

	//* LEGACY BELOW *//

//Camera networks
#define NETWORK_TETHER "Tether"
///Using different from Polaris one for better name
#define NETWORK_TCOMMS "Telecommunications"
#define NETWORK_OUTSIDE "Outside"
#define NETWORK_EXPLORATION "Exploration"
#define NETWORK_XENOBIO "Xenobiology"

/datum/map/station/tether
	full_name = "NSB Adephagia"
	use_overmap = TRUE
	overmap_size = 50
	overmap_event_areas = 44
	usable_email_tlds = list("virgo.nt")


	lobby_icon = 'icons/misc/title_vr.dmi'
	lobby_screens = list("tether2_night")
	id_hud_icons = 'icons/mob/hud_jobs_cit.dmi'

	holomap_smoosh = list(list(
		Z_LEVEL_SURFACE_LOW,
		Z_LEVEL_SURFACE_MID,
		Z_LEVEL_SURFACE_HIGH,
		Z_LEVEL_SPACE_LOW,
		Z_LEVEL_SPACE_HIGH))

	station_name  = "NSB Adephagia"
	station_short = "Tether"
	dock_name     = "Virgo-3B Colony"
	dock_type     = "surface"
	boss_name     = "Central Command"
	boss_short    = "CentCom"
	company_name  = "NanoTrasen"
	company_short = "NT"
	starsys_name  = "Virgo-Erigone"

	shuttle_docked_message = "The scheduled Orange Line tram to the %dock_name% has arrived. It will depart in approximately %ETD%."
	shuttle_leaving_dock = "The Orange Line tram has left the station. Estimate %ETA% until the tram arrives at %dock_name%."
	shuttle_called_message = "A scheduled crew transfer to the %dock_name% is occuring. The tram will be arriving shortly. Those departing should proceed to the Orange Line tram station within %ETA%."
	shuttle_recall_message = "The scheduled crew transfer has been cancelled."
	shuttle_name = "Automated Tram"
	emergency_shuttle_docked_message = "The evacuation tram has arrived at the tram station. You have approximately %ETD% to board the tram."
	emergency_shuttle_leaving_dock = "The emergency tram has left the station. Estimate %ETA% until the tram arrives at %dock_name%."
	emergency_shuttle_called_message = "An emergency evacuation has begun, and an off-schedule tram has been called. It will arrive at the tram station in approximately %ETA%."
	emergency_shuttle_recall_message = "The evacuation tram has been recalled."

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
							NETWORK_TETHER
							)
	secondary_networks = list(
							NETWORK_ERT,
							NETWORK_MERCENARY,
							NETWORK_THUNDER,
							NETWORK_COMMUNICATORS,
							NETWORK_ALARM_ATMOS,
							NETWORK_ALARM_POWER,
							NETWORK_ALARM_FIRE,
							NETWORK_TRADE_STATION
							)

	bot_patrolling = FALSE

	allowed_spawns = list("Tram Station","Gateway","Cryogenic Storage","Cyborg Storage","Beruang Trading Corp Cryo")
	spawnpoint_died = /datum/spawnpoint/tram
	spawnpoint_left = /datum/spawnpoint/tram
	spawnpoint_stayed = /datum/spawnpoint/cryo

	meteor_strike_areas = list(/area/tether/surfacebase/outside/outside3)

	default_skybox = /datum/skybox_settings/tether

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
		/area/rnd/miscellaneous_lab
		)

	unit_test_exempt_from_atmos = list(
		/area/engineering/atmos_intake, // Outside,
		/area/rnd/external, //  Outside,
		/area/tether/surfacebase/emergency_storage/rnd,
		/area/tether/surfacebase/emergency_storage/atrium,
		/area/tether/surfacebase/lowernortheva, // it airlock
		/area/tether/surfacebase/lowernortheva/external, //it outside
		/area/tether/surfacebase/security/gasstorage) //it maint


	lateload_z_levels = list(
		list("Tether - Misc","Tether - Underdark","Tether - Plains"), //Stock Tether lateload maps
		list("Asteroid Belt 1","Asteroid Belt 2"),
		list("Desert Planet - Z1 Beach","Desert Planet - Z2 Cave","Desert Planet - Z3 Desert"),
		list("Remmi Aerostat - Z1 Aerostat","Remmi Aerostat - Z2 Surface"),
		list("Debris Field - Z1 Space"),
		list("Fuel Depot - Z1 Space"),
		list("Class D - Mountains and Rock Plains")
		)

	belter_docked_z = 		list(Z_LEVEL_SPACE_HIGH)
	belter_transit_z =	 	list(Z_LEVEL_MISC)
	belter_belt_z = 		list(Z_LEVEL_ROGUEMINE_1,
						 		 Z_LEVEL_ROGUEMINE_2)


// /datum/map/station/tether/get_map_info()
// 	. = list()
// 	. +=  "The [full_name] is an ancient ruin turned workplace in the Virgo-Erigone System, deep in the midst of the Coreward Periphery.<br>"
// 	. +=  "Humanity has spread across the stars and has met many species on similar or even more advanced terms than them - it's a brave new world and many try to find their place in it . <br>"
// 	. +=  "Though Virgo-Erigone is not important for the great movers and shakers, it sees itself in the midst of the interests of a reviving alien species of the Zorren, corporate and subversive interests and other exciting dangers the Periphery has to face.<br>"
// 	. +=  "As an employee or contractor of NanoTrasen, operators of the Adephagia and one of the galaxy's largest corporations, you're probably just here to do a job."
// 	return jointext(., "<br>")

/datum/map/station/tether/perform_map_generation()

	new /datum/random_map/automata/cave_system/no_cracks(null, 1, 1, Z_LEVEL_SURFACE_MINE, world.maxx, world.maxy) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, Z_LEVEL_SURFACE_MINE, 64, 64)         // Create the mining ore distribution map.

	new /datum/random_map/automata/cave_system/no_cracks(null, 1, 1, Z_LEVEL_SOLARS, world.maxx, world.maxy) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, Z_LEVEL_SOLARS, 64, 64)         // Create the mining ore distribution map.

	return 1

/obj/effect/overmap/visitable/sector/virgo3b/get_space_zlevels()
	return list(Z_LEVEL_SPACE_LOW, Z_LEVEL_SPACE_HIGH)

// For making the 6-in-1 holomap, we calculate some offsets
/// Width and height of compiled in tether z levels.
#define TETHER_MAP_SIZE 140
/// 40px central gutter between columns
#define TETHER_HOLOMAP_CENTER_GUTTER 40
/// 80
#define TETHER_HOLOMAP_MARGIN_X ((HOLOMAP_ICON_SIZE - (2*TETHER_MAP_SIZE) - TETHER_HOLOMAP_CENTER_GUTTER) / 2)
/// 30
#define TETHER_HOLOMAP_MARGIN_Y ((HOLOMAP_ICON_SIZE - (3*TETHER_MAP_SIZE)) / 2)
// We have a bunch of stuff common to the station z levels
/datum/map_level/tether
	base_turf = /turf/simulated/floor/outdoors/rocks/virgo3b

/datum/map_level/tether/station
	flags = LEGACY_LEVEL_STATION|LEGACY_LEVEL_CONTACT|LEGACY_LEVEL_PLAYER|LEGACY_LEVEL_CONSOLES|MAP_LEVEL_XENOARCH_EXEMPT
	holomap_legend_x = 220
	holomap_legend_y = 160

/datum/map_level/tether/station/surface_low
	z = Z_LEVEL_SURFACE_LOW
	name = "Surface 1"
	flags = LEGACY_LEVEL_STATION|LEGACY_LEVEL_CONTACT|LEGACY_LEVEL_PLAYER|LEGACY_LEVEL_CONSOLES|LEGACY_LEVEL_SEALED|MAP_LEVEL_XENOARCH_EXEMPT
	base_turf = /turf/simulated/floor/outdoors/rocks/virgo3b
	holomap_offset_x = TETHER_HOLOMAP_MARGIN_X
	holomap_offset_y = TETHER_HOLOMAP_MARGIN_Y + TETHER_MAP_SIZE*0

/datum/map_level/tether/station/surface_mid
	z = Z_LEVEL_SURFACE_MID
	name = "Surface 2"
	flags = LEGACY_LEVEL_STATION|LEGACY_LEVEL_CONTACT|LEGACY_LEVEL_PLAYER|LEGACY_LEVEL_CONSOLES|LEGACY_LEVEL_SEALED|MAP_LEVEL_XENOARCH_EXEMPT
	base_turf = /turf/simulated/open
	holomap_offset_x = TETHER_HOLOMAP_MARGIN_X
	holomap_offset_y = TETHER_HOLOMAP_MARGIN_Y + TETHER_MAP_SIZE*1

/datum/map_level/tether/station/surface_high
	z = Z_LEVEL_SURFACE_HIGH
	name = "Surface 3"
	flags = LEGACY_LEVEL_STATION|LEGACY_LEVEL_CONTACT|LEGACY_LEVEL_PLAYER|LEGACY_LEVEL_CONSOLES|LEGACY_LEVEL_SEALED|MAP_LEVEL_XENOARCH_EXEMPT
	base_turf = /turf/simulated/open
	holomap_offset_x = TETHER_HOLOMAP_MARGIN_X
	holomap_offset_y = TETHER_HOLOMAP_MARGIN_Y + TETHER_MAP_SIZE*2

/datum/map_level/tether/transit
	z = Z_LEVEL_TRANSIT
	name = "Transit"
	flags = LEGACY_LEVEL_STATION|LEGACY_LEVEL_SEALED|LEGACY_LEVEL_PLAYER|LEGACY_LEVEL_CONTACT|MAP_LEVEL_XENOARCH_EXEMPT

/datum/map_level/tether/station/space_low
	z = Z_LEVEL_SPACE_LOW
	name = "Asteroid 1"
	base_turf = /turf/space
	transit_chance = 50
	holomap_offset_x = HOLOMAP_ICON_SIZE - TETHER_HOLOMAP_MARGIN_X - TETHER_MAP_SIZE
	holomap_offset_y = TETHER_HOLOMAP_MARGIN_Y + TETHER_MAP_SIZE*0

/datum/map_level/tether/station/space_high
	z = Z_LEVEL_SPACE_HIGH
	name = "Asteroid 2"
	base_turf = /turf/simulated/open
	transit_chance = 50
	holomap_offset_x = HOLOMAP_ICON_SIZE - TETHER_HOLOMAP_MARGIN_X - TETHER_MAP_SIZE
	holomap_offset_y = TETHER_HOLOMAP_MARGIN_Y + TETHER_MAP_SIZE*1

/datum/map_level/tether/mine
	z = Z_LEVEL_SURFACE_MINE
	name = "Mining Outpost"
	flags = LEGACY_LEVEL_CONTACT|LEGACY_LEVEL_PLAYER|LEGACY_LEVEL_SEALED
	base_turf = /turf/simulated/floor/outdoors/rocks/virgo3b

/datum/map_level/tether/solars
	z = Z_LEVEL_SOLARS
	name = "Solar Field"
	flags = LEGACY_LEVEL_CONTACT|LEGACY_LEVEL_PLAYER|LEGACY_LEVEL_SEALED
	base_turf = /turf/simulated/floor/outdoors/rocks/virgo3b

/datum/map_template/lateload/tether/tether_misc
	name = "Tether - Misc"
	desc = "Misc areas, like some transit areas, holodecks, merc area."
	map_path = "maps/map_files/tether/tether_misc.dmm"

	associated_map_datum = /datum/map_level/tether_lateload/misc

/datum/map_level/tether_lateload/misc
	name = "Misc"
	flags = LEGACY_LEVEL_ADMIN|LEGACY_LEVEL_SEALED|LEGACY_LEVEL_CONTACT|MAP_LEVEL_XENOARCH_EXEMPT

/datum/map_template/lateload/tether/tether_underdark
	name = "Tether - Underdark"
	desc = "Mining, but harder."
	map_path = "maps/map_files/tether/tether_underdark.dmm"

	associated_map_datum = /datum/map_level/tether_lateload/underdark

/datum/map_level/tether_lateload/underdark
	name = "Underdark"
	flags = LEGACY_LEVEL_CONTACT|LEGACY_LEVEL_PLAYER|LEGACY_LEVEL_SEALED
	base_turf = /turf/simulated/mineral/floor/virgo3b

/datum/map_template/lateload/tether/tether_underdark/on_map_loaded(z)
	. = ..()
	seed_submaps(list(z), 150, /area/mine/unexplored/underdark, /datum/map_template/submap/level_specific/underdark)
	new /datum/random_map/automata/cave_system/no_cracks(null, 3, 3, z, world.maxx - 4, world.maxy - 4) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, z, 64, 64)         // Create the mining ore distribution map.

/datum/map_template/lateload/tether/tether_plains
	name = "Tether - Plains"
	desc = "The Virgo 3B away mission."
	map_path = "maps/map_files/tether/tether_plains.dmm"
	associated_map_datum = /datum/map_level/tether_lateload/tether_plains

/datum/map_level/tether_lateload/tether_plains
	name = "Away Mission - Plains"
	flags = LEGACY_LEVEL_CONTACT|LEGACY_LEVEL_PLAYER|LEGACY_LEVEL_SEALED
	base_turf = /turf/simulated/mineral/floor/virgo3b

/datum/map_template/lateload/tether/tether_plains/on_map_loaded(z)
 	. = ..()
 	seed_submaps(list(z), 150, /area/tether/outpost/exploration_plains, /datum/map_template/submap/level_specific/plains)
