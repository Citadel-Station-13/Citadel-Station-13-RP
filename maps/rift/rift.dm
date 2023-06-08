/datum/map/station/rift
	id = "rift"
	name = "World - Rift"
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
	width = 192
	height = 192
	lateload = list(
		/datum/map/sector/debrisfield_192,
		/datum/map/sector/piratebase_192,
		/datum/map/sector/mining_192,
		/datum/map/sector/gaia_192,
		/datum/map/sector/frozen_192,
		/datum/map/sector/wasteland_192,
		/datum/map/sector/tradeport_192,
		/datum/map/sector/lavaland_192,
		/datum/map/sector/miaphus_192,
		/datum/map/sector/roguemining_192/one,
	)

	//* LEGACY BELOW *//

	legacy_persistence_id = "rift"
	full_name = "NSB Atlas"
	use_overmap = TRUE
	usable_email_tlds = list("lythios.nt")

	lobby_icon = 'icons/misc/title_vr.dmi'
	lobby_screens = list("title1", "title2", "title3", "title4", "title5", "title6", "title7", "title8", "bnny")

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

/datum/map_level/rift/station/underground_floor
	id = "RiftUnderground3"
	name = "Rift - East Canyon"
	display_id = "atlas-underground-3"
	display_name = "NSB Atlas Underground -3 (Canyon)"
	absolute_path = "maps/rift/levels/rift-01-underground3.dmm"
	traits = list(
		ZTRAIT_STATION,
		ZTRAIT_FACILITY_SAFETY,
		ZTRAIT_GRAVITY,
	)
	base_turf = /turf/simulated/floor/outdoors/safeice/lythios43c
	flags = MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_SEALED
	planet_path = /datum/planet/lythios43c
	link_above = /datum/map_level/rift/station/underground_deep

/datum/map_level/rift/station/underground_floor/on_loaded_immediate(z_index, list/datum/callback/additional_generation)
	. = ..()
	new /datum/random_map/automata/cave_system/no_cracks(null, 3, 3, z_index, world.maxx - 3, world.maxy - 3)

/datum/map_level/rift/station/underground_deep
	id = "RiftUnderground2"
	name = "Rift - Underground 2"
	display_id = "atlas-underground-2"
	display_name = "NSB Atlas Underground -2 (Engineering Deck)"
	absolute_path = "maps/rift/levels/rift-02-underground2.dmm"
	traits = list(
		ZTRAIT_STATION,
		ZTRAIT_FACILITY_SAFETY,
		ZTRAIT_GRAVITY,
		ZTRAIT_LEGACY_HOLOMAP_SMOOSH,
	)
	base_turf = /turf/simulated/floor/outdoors/safeice/lythios43c
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_SEALED
	planet_path = /datum/planet/lythios43c
	link_below = /datum/map_level/rift/station/underground_floor
	link_above = /datum/map_level/rift/station/underground_shallow

/datum/map_level/rift/station/underground_deep/on_loaded_immediate(z_index, list/datum/callback/additional_generation)
	. = ..()
	new /datum/random_map/automata/cave_system/no_cracks(null, 3, 3, z_index, world.maxx - 3, world.maxy - 3)

/datum/map_level/rift/station/underground_shallow
	id = "RiftUnderground1"
	name = "Rift - Underground 1"
	display_id = "atlas-underground-1"
	display_name = "NSB Atlas Underground -1 (Maintenance Deck)"
	absolute_path = "maps/rift/levels/rift-03-underground1.dmm"
	traits = list(
		ZTRAIT_STATION,
		ZTRAIT_FACILITY_SAFETY,
		ZTRAIT_GRAVITY,
		ZTRAIT_LEGACY_HOLOMAP_SMOOSH,
	)
	base_turf = /turf/simulated/open
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_SEALED
	planet_path = /datum/planet/lythios43c
	link_below = /datum/map_level/rift/station/underground_deep
	link_above = /datum/map_level/rift/station/surface_low

/datum/map_level/rift/station/underground_shallow/on_loaded_immediate(z_index, list/datum/callback/additional_generation)
	. = ..()
	new /datum/random_map/automata/cave_system/no_cracks(null, 3, 3, z_index, world.maxx - 3, world.maxy - 3)

/datum/map_level/rift/station/surface_low
	id = "RiftSurface1"
	name = "Rift - Surface 1"
	display_id = "atlas-surface-1"
	display_name = "NSB Atlas Surface 1 (Logistics Deck)"
	absolute_path = "maps/rift/levels/rift-04-surface1.dmm"
	traits = list(
		ZTRAIT_STATION,
		ZTRAIT_FACILITY_SAFETY,
		ZTRAIT_GRAVITY,
		ZTRAIT_LEGACY_HOLOMAP_SMOOSH,
	)
	base_turf = /turf/simulated/open
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES
	planet_path = /datum/planet/lythios43c
	link_below = /datum/map_level/rift/station/underground_shallow
	link_above = /datum/map_level/rift/station/surface_mid

/datum/map_level/rift/station/surface_low/on_loaded_immediate(z_index, list/datum/callback/additional_generation)
	. = ..()
	new /datum/random_map/automata/cave_system/no_cracks(null, 3, 3, z_index, world.maxx - 3, world.maxy - 3)

/datum/map_level/rift/station/surface_mid
	id = "RiftSurface2"
	name = "Rift - Surface 2"
	display_id = "atlas-surface-2"
	display_name = "NSB Atlas Surface 2 (Operations Deck)"
	absolute_path = "maps/rift/levels/rift-05-surface2.dmm"
	traits = list(
		ZTRAIT_STATION,
		ZTRAIT_FACILITY_SAFETY,
		ZTRAIT_GRAVITY,
		ZTRAIT_LEGACY_HOLOMAP_SMOOSH,
	)
	base_turf = /turf/simulated/open
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES
	planet_path = /datum/planet/lythios43c
	link_below = /datum/map_level/rift/station/surface_low
	link_above = /datum/map_level/rift/station/surface_high

/datum/map_level/rift/station/surface_mid/on_loaded_immediate(z_index, list/datum/callback/additional_generation)
	. = ..()
	new /datum/random_map/automata/cave_system/no_cracks(null, 3, 3, z_index, world.maxx - 3, world.maxy - 3)

/datum/map_level/rift/station/surface_high
	id = "RiftSurface3"
	name = "Rift - Surface 3"
	display_id = "atlas-surface-3"
	display_name = "NSB Atlas Surface 3 (Command Deck)"
	absolute_path = "maps/rift/levels/rift-06-surface3.dmm"
	traits = list(
		ZTRAIT_STATION,
		ZTRAIT_FACILITY_SAFETY,
		ZTRAIT_GRAVITY,
		ZTRAIT_LEGACY_HOLOMAP_SMOOSH,
	)
	base_turf = /turf/simulated/open
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES
	planet_path = /datum/planet/lythios43c
	link_below = /datum/map_level/rift/station/surface_mid

/datum/map_level/rift/station/surface_high/on_loaded_immediate(z_index, list/datum/callback/additional_generation)
	. = ..()
	new /datum/random_map/automata/cave_system/no_cracks(null, 3, 3, z_index, world.maxx - 3, world.maxy - 3)

/datum/map_level/rift/base
	id = "RiftWestUnderground3"
	name = "Rift - West Canyon"
	display_id = "atlas-west-canyon"
	display_name = "NSB Atlas Western Canyons"
	absolute_path = "maps/rift/levels/rift-07-west_base.dmm"
	traits = list(
		ZTRAIT_STATION,
		ZTRAIT_GRAVITY,
	)
	base_turf = /turf/simulated/mineral/floor/icerock/lythios43c/indoors
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER
	planet_path = /datum/planet/lythios43c
	link_above = /datum/map_level/rift/deep

/datum/map_level/rift/base/on_loaded_immediate(z_index, list/datum/callback/additional_generation)
	. = ..()
	additional_generation?.Add(
		CALLBACK(
			GLOBAL_PROC,
			GLOBAL_PROC_REF(seed_submaps),
			list(z_index),
			50,
			/area/rift/surfacebase/outside/west_base/submap_seedzone, /datum/map_template/submap/level_specific/rift/west_base,
		)
	)
	new /datum/random_map/automata/cave_system/no_cracks(null, 3, 3, z_index, world.maxx - 3, world.maxy - 3)

/datum/map_level/rift/deep
	id = "RiftWestUnderground2"
	name = "Rift - West Caves (Deep)"
	display_id = "atlas-west-deep"
	display_name = "NSB Atlas Western Caves - Deep"
	absolute_path = "maps/rift/levels/rift-08-west_deep.dmm"
	traits = list(
		ZTRAIT_STATION,
		ZTRAIT_GRAVITY,
		ZTRAIT_LEGACY_BELTER_DOCK,
	)
	base_turf = /turf/simulated/mineral/floor/icerock/lythios43c/indoors
	flags = MAP_LEVEL_STATION|MAP_LEVEL_PLAYER
	planet_path = /datum/planet/lythios43c
	link_below = /datum/map_level/rift/base
	link_above = /datum/map_level/rift/caves

/datum/map_level/rift/deep/on_loaded_immediate(z_index, list/datum/callback/additional_generation)
	. = ..()
	additional_generation?.Add(
		CALLBACK(
			GLOBAL_PROC,
			GLOBAL_PROC_REF(seed_submaps),
			list(z_index),
			50,
			/area/rift/surfacebase/outside/west_deep/submap_seedzone, /datum/map_template/submap/level_specific/rift/west_deep,
		)
	)
	new /datum/random_map/automata/cave_system/no_cracks(null, 3, 3, z_index, world.maxx - 3, world.maxy - 3)

/datum/map_level/rift/caves
	id = "RiftWestUnderground1"
	name = "Rift - West Caves (Shallow)"
	display_id = "atlas-west-caves"
	display_name = "NSB Atlas Western Caves - Shallow"
	absolute_path = "maps/rift/levels/rift-09-west_caves.dmm"
	traits = list(
		ZTRAIT_STATION,
		ZTRAIT_GRAVITY,
	)
	base_turf = /turf/simulated/mineral/floor/icerock/lythios43c/indoors
	flags = MAP_LEVEL_STATION|MAP_LEVEL_PLAYER
	planet_path = /datum/planet/lythios43c
	link_below = /datum/map_level/rift/deep
	link_above = /datum/map_level/rift/plains

/datum/map_level/rift/caves/on_loaded_immediate(z_index, list/datum/callback/additional_generation)
	. = ..()
	additional_generation?.Add(
		CALLBACK(
			GLOBAL_PROC,
			GLOBAL_PROC_REF(seed_submaps),
			list(z_index),
			50,
			/area/rift/surfacebase/outside/west_caves/submap_seedzone, /datum/map_template/submap/level_specific/rift/west_caves,
		)
	)
	new /datum/random_map/automata/cave_system/no_cracks(null, 3, 3, z_index, world.maxx - 3, world.maxy - 3)

/datum/map_level/rift/plains
	id = "RiftWestSurface1"
	name = "Rift - Western Plains"
	display_id = "atlas-west-plains"
	display_name = "NSB Atlas Western Plains"
	absolute_path = "maps/rift/levels/rift-10-west_plains.dmm"
	base_turf = /turf/simulated/floor/outdoors/safeice/lythios43c
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER
	planet_path = /datum/planet/lythios43c
	link_below = /datum/map_level/rift/caves
	link_east = /datum/map_level/rift/station/surface_low

/datum/map_level/rift/colony
	id = "RiftOrbitalRelay"
	name = "Rift - Orbital Relay"
	display_id = "atlas-relay"
	display_name = "NSB Atlas Orbital Relay"
	absolute_path = "maps/rift/levels/rift-11-orbital.dmm"
	flags = MAP_LEVEL_ADMIN|MAP_LEVEL_CONTACT
	traits = list(
		ZTRAIT_LEGACY_BELTER_TRANSIT,
	)
