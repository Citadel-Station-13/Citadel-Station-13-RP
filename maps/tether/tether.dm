/datum/map/station/tether
	id = "tether"
	name = "World - Tether"
	levels = list(
		/datum/map_level/tether/station/surface_low,
		/datum/map_level/tether/station/surface_mid,
		/datum/map_level/tether/station/surface_high,
		/datum/map_level/tether/transit,
		/datum/map_level/tether/station/space_low,
		/datum/map_level/tether/station/space_high,
		/datum/map_level/tether/mine,
		/datum/map_level/tether/solars,
		/datum/map_level/tether/misc,
		/datum/map_level/tether/underdark,
		/datum/map_level/tether/plains,
	)
	width = 140
	height = 140
	lateload = list(
		/datum/map/sector/roguemining_140,
		/datum/map/sector/desert_140,
		/datum/map/sector/virgo2_140,
		/datum/map/sector/virgo4_140,
		/datum/map/sector/tradeport_140,
		/datum/map/sector/wasteland_140,
	)

	//* LEGACY BELOW *//

	legacy_assert_shuttle_datums = list(
		/datum/shuttle/autodock/ferry/emergency/escape/tether,
		/datum/shuttle/autodock/ferry/escape_pod/large_escape_pod1/tether,
		/datum/shuttle/autodock/ferry/supply/cargo/tether,
		/datum/shuttle/autodock/ferry/tether_backup,
		/datum/shuttle/autodock/ferry/surface_mining_outpost,
		/datum/shuttle/autodock/overmap/excursion/tether,
		/datum/shuttle/autodock/overmap/tourbus,
		/datum/shuttle/autodock/overmap/medivac,
		/datum/shuttle/autodock/overmap/securiship,
	)

	full_name = "NSB Adephagia"
	use_overmap = TRUE
	overmap_size = 50
	overmap_event_areas = 44
	usable_email_tlds = list("virgo.nt")

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

	unit_test_exempt_areas = list(
		/area/tether/surfacebase/outside/outside1,
		/area/tether/elevator,
		/area/vacant/vacant_site,
		/area/vacant/vacant_site/east,
		/area/crew_quarters/sleep/Dorm_1/holo,
		/area/crew_quarters/sleep/Dorm_3/holo,
		/area/crew_quarters/sleep/Dorm_5/holo,
		/area/crew_quarters/sleep/Dorm_7/holo,
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
	flags = LEGACY_LEVEL_STATION|LEGACY_LEVEL_CONTACT|LEGACY_LEVEL_PLAYER|LEGACY_LEVEL_CONSOLES
	holomap_legend_x = 220
	holomap_legend_y = 160

/datum/map_level/tether/station/surface_low
	id = "TetherSurface1"
	name = "Tether - Surface 1"
	display_id = "adephagia-surface-1"
	display_name = "NSB Adephagia Surface 1 (Lobby & External)"
	absolute_path = "maps/tether/levels/surface1.dmm"
	traits = list(
		ZTRAIT_STATION,
		ZTRAIT_FACILITY_SAFETY,
		ZTRAIT_GRAVITY,
		ZTRAIT_LEGACY_HOLOMAP_SMOOSH,
	)
	planet_path = /datum/planet/virgo3b
	link_above = /datum/map_level/tether/station/surface_mid
	flags = LEGACY_LEVEL_STATION|LEGACY_LEVEL_CONTACT|LEGACY_LEVEL_PLAYER|LEGACY_LEVEL_CONSOLES|LEGACY_LEVEL_SEALED
	base_turf = /turf/simulated/floor/outdoors/rocks/virgo3b
	holomap_offset_x = TETHER_HOLOMAP_MARGIN_X
	holomap_offset_y = TETHER_HOLOMAP_MARGIN_Y + TETHER_MAP_SIZE*0

/datum/map_level/tether/station/surface_mid
	id = "TetherSurface2"
	name = "Tether - Surface 2"
	display_id = "adephagia-surface-2"
	display_name = "NSB Adephagia Surface 2 (Research & Life Suppot)"
	absolute_path = "maps/tether/levels/surface2.dmm"
	traits = list(
		ZTRAIT_STATION,
		ZTRAIT_FACILITY_SAFETY,
		ZTRAIT_GRAVITY,
		ZTRAIT_LEGACY_HOLOMAP_SMOOSH,
	)
	planet_path = /datum/planet/virgo3b
	link_above = /datum/map_level/tether/station/surface_high
	link_below = /datum/map_level/tether/station/surface_low
	flags = LEGACY_LEVEL_STATION|LEGACY_LEVEL_CONTACT|LEGACY_LEVEL_PLAYER|LEGACY_LEVEL_CONSOLES|LEGACY_LEVEL_SEALED
	base_turf = /turf/simulated/open
	holomap_offset_x = TETHER_HOLOMAP_MARGIN_X
	holomap_offset_y = TETHER_HOLOMAP_MARGIN_Y + TETHER_MAP_SIZE*1

/datum/map_level/tether/station/surface_high
	id = "TetherSurface3"
	name = "Tether - Surface 3"
	display_id = "adephagia-surface-3"
	display_name = "NSB Adephagia Surface 3 (Services & Command)"
	absolute_path = "maps/tether/levels/surface3.dmm"
	traits = list(
		ZTRAIT_STATION,
		ZTRAIT_FACILITY_SAFETY,
		ZTRAIT_GRAVITY,
		ZTRAIT_LEGACY_HOLOMAP_SMOOSH,
	)
	planet_path = /datum/planet/virgo3b
	link_above = /datum/map_level/tether/transit
	link_below = /datum/map_level/tether/station/surface_mid
	flags = LEGACY_LEVEL_STATION|LEGACY_LEVEL_CONTACT|LEGACY_LEVEL_PLAYER|LEGACY_LEVEL_CONSOLES|LEGACY_LEVEL_SEALED
	base_turf = /turf/simulated/open
	holomap_offset_x = TETHER_HOLOMAP_MARGIN_X
	holomap_offset_y = TETHER_HOLOMAP_MARGIN_Y + TETHER_MAP_SIZE*2

/datum/map_level/tether/transit
	id = "TetherMidpoint"
	name = "Tether - Midpoint"
	display_id = "adephagia-tether"
	display_name = "NSB Adephagia Tether Midpoint"
	absolute_path = "maps/tether/levels/midpoint.dmm"
	traits = list(
		ZTRAIT_STATION,
		ZTRAIT_FACILITY_SAFETY,
		ZTRAIT_GRAVITY,
	)
	planet_path = /datum/planet/virgo3b
	link_above = /datum/map_level/tether/station/space_low
	link_below = /datum/map_level/tether/station/surface_high
	flags = LEGACY_LEVEL_STATION|LEGACY_LEVEL_SEALED|LEGACY_LEVEL_PLAYER|LEGACY_LEVEL_CONTACT
	base_turf = /turf/simulated/open

/datum/map_level/tether/station/space_low
	id = "TetherSpace1"
	name = "Tether - Space 1"
	display_id = "adephagia-station-1"
	display_name = "NSB Adephagia Station 1 (Engineering Deck)"
	absolute_path = "maps/tether/levels/station1.dmm"
	traits = list(
		ZTRAIT_STATION,
		ZTRAIT_FACILITY_SAFETY,
		ZTRAIT_LEGACY_HOLOMAP_SMOOSH,
	)
	link_above = /datum/map_level/tether/station/space_high
	link_below = /datum/map_level/tether/transit
	base_turf = /turf/space
	holomap_offset_x = HOLOMAP_ICON_SIZE - TETHER_HOLOMAP_MARGIN_X - TETHER_MAP_SIZE
	holomap_offset_y = TETHER_HOLOMAP_MARGIN_Y + TETHER_MAP_SIZE*0

/datum/map_level/tether/station/space_high
	id = "TetherSpace2"
	name = "Tether - Space 2"
	display_id = "adephagia-station-2"
	display_name = "NSB Adephagia Station 2 (Logistics Deck)"
	absolute_path = "maps/tether/levels/station2.dmm"
	traits = list(
		ZTRAIT_STATION,
		ZTRAIT_FACILITY_SAFETY,
		ZTRAIT_LEGACY_BELTER_DOCK,
		ZTRAIT_LEGACY_HOLOMAP_SMOOSH,
	)
	link_below = /datum/map_level/tether/station/space_low
	base_turf = /turf/simulated/open
	holomap_offset_x = HOLOMAP_ICON_SIZE - TETHER_HOLOMAP_MARGIN_X - TETHER_MAP_SIZE
	holomap_offset_y = TETHER_HOLOMAP_MARGIN_Y + TETHER_MAP_SIZE*1

/datum/map_level/tether/mine
	id = "TetherMiningOutpost"
	name = "Tether - Mining Outpost"
	display_id = "adephagia-mining"
	display_name = "NSB Adephagia Mining Outpost"
	absolute_path = "maps/tether/levels/mining.dmm"
	traits = list(
		ZTRAIT_STATION,
		ZTRAIT_GRAVITY,
	)
	flags = LEGACY_LEVEL_CONTACT|LEGACY_LEVEL_PLAYER|LEGACY_LEVEL_SEALED
	base_turf = /turf/simulated/floor/outdoors/rocks/virgo3b

/datum/map_level/tether/mine/on_loaded_immediate(z_index, list/datum/callback/additional_generation)
	. = ..()
	new /datum/random_map/automata/cave_system/no_cracks(null, 1, 1, z_index, world.maxx, world.maxy) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, z_index, 64, 64)         // Create the mining ore distribution map.

/datum/map_level/tether/solars
	id = "TetherScienceOutpost"
	name = "Tether - Science Outpost"
	display_id = "adephagia-solars"
	display_name = "NSB Adephagia Solars & Research Outpost"
	absolute_path = "maps/tether/levels/solars.dmm"
	traits = list(
		ZTRAIT_STATION,
		ZTRAIT_GRAVITY,
	)
	flags = LEGACY_LEVEL_CONTACT|LEGACY_LEVEL_PLAYER|LEGACY_LEVEL_SEALED
	base_turf = /turf/simulated/floor/outdoors/rocks/virgo3b

/datum/map_level/tether/solars/on_loaded_immediate(z_index, list/datum/callback/additional_generation)
	. = ..()
	new /datum/random_map/automata/cave_system/no_cracks(null, 1, 1, z_index, world.maxx, world.maxy) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, z_index, 64, 64)         // Create the mining ore distribution map.

/datum/map_level/tether/misc
	id = "TetherMisc"
	name = "Tether - Misc"
	absolute_path = "maps/tether/levels/misc.dmm"
	traits = list(
		ZTRAIT_LEGACY_BELTER_TRANSIT,
	)
	flags = LEGACY_LEVEL_ADMIN|LEGACY_LEVEL_SEALED|LEGACY_LEVEL_CONTACT

/datum/map_level/tether/underdark
	id = "TetherUnderdark"
	name = "Tether - Underdark"
	display_id = "adephagia-underdark"
	display_name = "NSB Adephagia Underdark"
	absolute_path = "maps/tether/levels/underdark.dmm"
	traits = list(
		ZTRAIT_STATION,
		ZTRAIT_GRAVITY,
	)
	flags = LEGACY_LEVEL_CONTACT|LEGACY_LEVEL_PLAYER|LEGACY_LEVEL_SEALED
	base_turf = /turf/simulated/mineral/floor/virgo3b

/datum/map_level/tether/underdark/on_loaded_immediate(z_index, list/datum/callback/additional_generation)
	. = ..()
	additional_generation?.Add(
		CALLBACK(
			GLOBAL_PROC,
			GLOBAL_PROC_REF(seed_submaps),
			list(z_index),
			150,
			/area/mine/unexplored/underdark,
			/datum/map_template/submap/level_specific/underdark,
		)
	)
	new /datum/random_map/automata/cave_system/no_cracks(null, 3, 3, z_index, world.maxx - 4, world.maxy - 4) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, z_index, 64, 64)         // Create the mining ore distribution map.

/datum/map_level/tether/plains
	id = "TetherSouthPlains"
	name = "Tether - South Plains"
	display_id = "adephagia-south-plains"
	display_name = "NSB Adephagia Southern Plains"
	absolute_path = "maps/tether/levels/plains.dmm"
	traits = list(
		ZTRAIT_GRAVITY,
	)
	flags = LEGACY_LEVEL_CONTACT|LEGACY_LEVEL_PLAYER|LEGACY_LEVEL_SEALED
	base_turf = /turf/simulated/mineral/floor/virgo3b

/datum/map_level/tether/plains/on_loaded_immediate(z_index, list/datum/callback/additional_generation)
	. = ..()
	additional_generation?.Add(
		CALLBACK(
			GLOBAL_PROC,
			GLOBAL_PROC_REF(seed_submaps),
			list(z_index),
			150,
			/area/tether/outpost/exploration_plains,
			/datum/map_template/submap/level_specific/plains,
		)
	)
