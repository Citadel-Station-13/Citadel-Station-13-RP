#if !defined(USING_MAP_DATUM)

	#include "rift_defines.dm"
	#include "rift_shuttle_defs.dm"
	#include "rift_shuttles.dm"
	#include "rift_telecomms.dm"
	#include "rift_weather.dm"

	#define USING_MAP_DATUM /datum/map/station/rift


#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Rift

#endif


/datum/map/station/rift
	id = "rift"
	name = "Rift"
	full_name = "NSB Atlas"
	path = "rift"
	levels = list(
		/datum/map_level/rift/station/underground_floor,
		/datum/map_level/rift/station/underground_deep,
		/datum/map_level/rift/station/underground_shallow,
		/datum/map_level/rift/station/surface_low,
		/datum/map_level/rift/station/surface_mid,
		/datum/map_level/rift/station/surface_high,
		/datum/map_level/rift/base,
		/datum/map_level/rift/deep,
		/datum/map_level/rift/caves,
		/datum/map_level/rift/plains,
		/datum/map_level/rift/colony,
	)

	use_overmap = TRUE
	overmap_z = Z_LEVEL_MISC
	overmap_size = 60
	overmap_event_areas = 50
	usable_email_tlds = list("lythios.nt")

	zlevel_datum_type = /datum/map_level/rift
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

/// Cave Generation
/datum/map/station/rift/perform_map_generation()
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

/datum/map_level/rift/station/underground_floor
	id = "RiftUnderground3"
	name = "Rift - East Canyon"
	display_id = "atlas-underground-3"
	display_name = "NSB Atlas Underground -3 (Canyon)"
	traits = list(
		ZTRAIT_STATION,
		ZTRAIT_FACILITY_SAFETY,
		ZTRAIT_GRAVITY,
	)
	base_turf = /turf/simulated/floor/outdoors/safeice/lythios43c
	flags = MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_SEALED|MAP_LEVEL_XENOARCH_EXEMPT

/datum/map_level/rift/station/underground_deep
	id = "RiftUnderground2"
	name = "Rift - Underground 2"
	display_id = "atlas-underground-2"
	display_name = "NSB Atlas Underground -2 (Engineering Deck)"
	traits = list(
		ZTRAIT_STATION,
		ZTRAIT_FACILITY_SAFETY,
		ZTRAIT_GRAVITY,
	)
	base_turf = /turf/simulated/floor/outdoors/safeice/lythios43c
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_SEALED|MAP_LEVEL_XENOARCH_EXEMPT

/datum/map_level/rift/station/underground_shallow
	id = "RiftUnderground1"
	name = "Rift - Underground 1"
	display_id = "atlas-underground-1"
	display_name = "NSB Atlas Underground -1 (Maintenance Deck)"
	traits = list(
		ZTRAIT_STATION,
		ZTRAIT_FACILITY_SAFETY,
		ZTRAIT_GRAVITY,
	)
	base_turf = /turf/simulated/open
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_SEALED|MAP_LEVEL_XENOARCH_EXEMPT

/datum/map_level/rift/station/surface_low
	id = "RiftSurface1"
	name = "Rift - Surface 1"
	display_id = "atlas-surface-1"
	display_name = "NSB Atlas Surface 1 (Logistics Deck)"
	traits = list(
		ZTRAIT_STATION,
		ZTRAIT_FACILITY_SAFETY,
		ZTRAIT_GRAVITY,
	)
	base_turf = /turf/simulated/open
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_XENOARCH_EXEMPT
	transit_chance = 100

/datum/map_level/rift/station/surface_mid
	id = "RiftSurface2"
	name = "Rift - Surface 2"
	display_id = "atlas-surface-2"
	display_name = "NSB Atlas Surface 2 (Operations Deck)"
	traits = list(
		ZTRAIT_STATION,
		ZTRAIT_FACILITY_SAFETY,
		ZTRAIT_GRAVITY,
	)
	base_turf = /turf/simulated/open
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_XENOARCH_EXEMPT

/datum/map_level/rift/station/surface_high
	id = "RiftSurface3"
	name = "Rift - Surface 3"
	display_id = "atlas-surface-3"
	display_name = "NSB Atlas Surface 3 (Command Deck)"
	traits = list(
		ZTRAIT_STATION,
		ZTRAIT_FACILITY_SAFETY,
		ZTRAIT_GRAVITY,
	)
	base_turf = /turf/simulated/open
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_XENOARCH_EXEMPT

/datum/map_level/rift/base
	id = "RiftWestUnderground3"
	name = "Rift - West Canyon"
	display_id = "atlas-west-canyon"
	display_name = "NSB Atlas Western Canyons"
	traits = list(
		ZTRAIT_STATION,
		ZTRAIT_GRAVITY,
	)
	base_turf = /turf/simulated/mineral/floor/icerock/lythios43c/indoors
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER

/datum/map_level/rift/deep
	id = "RiftWestUnderground2"
	name = "Rift - West Caves (Deep)"
	display_id = "atlas-west-deep"
	display_name = "NSB Atlas Western Caves - Deep"
	traits = list(
		ZTRAIT_STATION,
		ZTRAIT_GRAVITY,
	)
	base_turf = /turf/simulated/mineral/floor/icerock/lythios43c/indoors
	flags = MAP_LEVEL_STATION|MAP_LEVEL_PLAYER

/datum/map_level/rift/caves
	id = "RiftWestUnderground1"
	name = "Rift - West Caves (Shallow)"
	display_id = "atlas-west-caves"
	display_name = "NSB Atlas Western Caves - Shallow"
	traits = list(
		ZTRAIT_STATION,
		ZTRAIT_GRAVITY,
	)
	base_turf = /turf/simulated/mineral/floor/icerock/lythios43c/indoors
	flags = MAP_LEVEL_STATION|MAP_LEVEL_PLAYER

/datum/map_level/rift/plains
	id = "RiftWestSurface1"
	name = "Rift - Western Plains"
	display_id = "atlas-west-plains"
	display_name = "NSB Atlas Western Plains"
	base_turf = /turf/simulated/floor/outdoors/safeice/lythios43c
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER

/datum/map_level/rift/colony
	id = "RiftOrbitalRelay"
	name = "Rift - Orbital Relay"
	display_id = "atlas-relay"
	display_name = "NSB Atlas Orbital Relay"
	flags = MAP_LEVEL_ADMIN|MAP_LEVEL_CONTACT|MAP_LEVEL_XENOARCH_EXEMPT
