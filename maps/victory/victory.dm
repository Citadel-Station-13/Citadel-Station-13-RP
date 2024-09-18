/datum/map/station/victory
	id = "victory"
	name = "World - Victory"
	levels = list(
		/datum/map_level/victory/ship/deck_one,
		/datum/map_level/victory/ship/deck_two,
		/datum/map_level/victory/ship/deck_three,
		/datum/map_level/victory/ship/deck_four,
		/datum/map_level/victory/misc,
		/datum/map_level/victory/transit,
		/datum/map_level/victory/flagship,
	)
	width = 192
	height = 192
	world_width = 192
	world_height = 192
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

	// todo: remove after dev is done
	allow_random_draw = FALSE

	//* LEGACY BELOW *//

	legacy_assert_shuttle_datums = list(
		/datum/shuttle/autodock/overmap/excursion/victory,
		/datum/shuttle/autodock/ferry/emergency/escape/victory,
		/datum/shuttle/autodock/ferry/supply/cargo/victory,
		/datum/shuttle/autodock/overmap/emt/victory,
		/datum/shuttle/autodock/overmap/mining/victory,
		/datum/shuttle/autodock/overmap/civvie/victory,
		/datum/shuttle/autodock/overmap/courser/victory,
		/datum/shuttle/autodock/ferry/belter,
	)

	full_name = "NSV Victory"

	use_overmap = TRUE
	overmap_size = 60
	overmap_event_areas = 50
	usable_email_tlds = list("victory.nt")

	station_name	= "NSV Victory"
	station_short	= "Victory"
	dock_name		= "NDV Marksman"
	dock_type		= "space"
	boss_name		= "Central Command"
	boss_short		= "CentCom"
	company_name	= "Nanotrasen"
	company_short	= "NT"
	starsys_name	= "Sigmar Concord"

	shuttle_docked_message = "This is the %dock_name% calling to the NSV Victory. The scheduled crew transfer shuttle has docked with the NSV Victory. Departing crew should board the shuttle within %ETD%."
	shuttle_leaving_dock = "The transfer shuttle has left the ship. Estimate %ETA% until the shuttle arrives at the %dock_name%."
	shuttle_called_message = "This is the %dock_name% calling to the NSV Victory. A scheduled crew transfer to the %dock_name% is commencing. Those departing should proceed to the shuttle bay within %ETA%."
	shuttle_recall_message = "The scheduled crew transfer has been cancelled."
	shuttle_name = "Crew Hands Transfer"
	emergency_shuttle_docked_message = "The evacuation shuttle has arrived at the ship. You have approximately %ETD% to board the shuttle."
	emergency_shuttle_leaving_dock = "The emergency shuttle has left the station. Estimate %ETA% until the shuttle arrives at %dock_name%."
	emergency_shuttle_called_message = "An emergency evacuation has begun, and an off-schedule shuttle has been called. It will arrive at the hanger bay in approximately %ETA%."
	emergency_shuttle_recall_message = "The evacuation shuttle has been recalled."

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
							"Victory",
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

	allowed_spawns = list(LATEJOIN_METHOD_ARRIVALS_SHUTTLE,LATEJOIN_METHOD_GATEWAY,LATEJOIN_METHOD_CRYOGENIC_STORAGE,LATEJOIN_METHOD_ROBOT_STORAGE,"Beruang Trading Corp Cryo")
	spawnpoint_died = /datum/spawnpoint/arrivals
	spawnpoint_left = /datum/spawnpoint/arrivals
	spawnpoint_stayed = /datum/spawnpoint/cryo

	meteor_strike_areas = null

	unit_test_exempt_areas = list(
		/area/vacant/vacant_site,
		/area/vacant/vacant_site/east,
		/area/solar/)
	unit_test_exempt_from_atmos = list(
		/area/engineering/atmos/intake,
		/area/tcommsat/chamber,
		/area/engineering/engineering_airlock,
		/area/solar/)

// For making the 4-in-1 holomap, we calculate some offsets
/// Width and height of compiled in victory z levels.
#define VICTORY_MAP_SIZE 192
/// 40px central gutter between columns
#define VICTORY_HOLOMAP_CENTER_GUTTER 20
/// 100
#define VICTORY_HOLOMAP_MARGIN_X ((HOLOMAP_ICON_SIZE - (2*VICTORY_MAP_SIZE) - VICTORY_HOLOMAP_CENTER_GUTTER) / 2)
/// 60
#define VICTORY_HOLOMAP_MARGIN_Y ((HOLOMAP_ICON_SIZE - (3*VICTORY_MAP_SIZE)) / 2)
// We have a bunch of stuff common to the station z levels

/datum/map_level/victory/ship
	flags = LEGACY_LEVEL_STATION|LEGACY_LEVEL_CONTACT|LEGACY_LEVEL_PLAYER|LEGACY_LEVEL_CONSOLES
	persistence_allowed = TRUE

/datum/map_level/victory/ship/deck_one
	id = "VictoryDeck1"
	name = "Victory - Deck 1"
	display_id = "victory-deck-1"
	display_name = "NSV Victory - Engineering Deck"
	absolute_path = "maps/victory/levels/deck1.dmm"
	traits = list(
		ZTRAIT_STATION,
		ZTRAIT_FACILITY_SAFETY,
	)
	base_turf = /turf/space
	link_above = /datum/map_level/victory/ship/deck_two
	flags = LEGACY_LEVEL_STATION|LEGACY_LEVEL_CONTACT|LEGACY_LEVEL_PLAYER|LEGACY_LEVEL_CONSOLES

/datum/map_level/victory/ship/deck_two
	id = "VictoryDeck2"
	name = "Victory - Deck 2"
	display_id = "victory-deck-2"
	display_name = "NSV Victory - Service Deck"
	absolute_path = "maps/victory/levels/deck2.dmm"
	traits = list(
		ZTRAIT_STATION,
		ZTRAIT_FACILITY_SAFETY,
		ZTRAIT_LEGACY_BELTER_DOCK,
	)
	base_turf = /turf/simulated/open
	link_above = /datum/map_level/victory/ship/deck_three
	link_below = /datum/map_level/victory/ship/deck_one
	flags = LEGACY_LEVEL_STATION|LEGACY_LEVEL_CONTACT|LEGACY_LEVEL_PLAYER|LEGACY_LEVEL_CONSOLES

/datum/map_level/victory/ship/deck_three
	id = "VictoryDeck3"
	name = "Victory - Deck 3"
	display_id = "victory-deck-3"
	display_name = "NSV Victory - Operations Deck"
	absolute_path = "maps/victory/levels/deck3.dmm"
	traits = list(
		ZTRAIT_STATION,
		ZTRAIT_FACILITY_SAFETY,
	)
	base_turf = /turf/simulated/open
	link_above = /datum/map_level/victory/ship/deck_four
	link_below = /datum/map_level/victory/ship/deck_two
	flags = LEGACY_LEVEL_STATION|LEGACY_LEVEL_CONTACT|LEGACY_LEVEL_PLAYER|LEGACY_LEVEL_CONSOLES

/datum/map_level/victory/ship/deck_four
	id = "VictoryDeck4"
	name = "Victory - Deck 4"
	display_id = "victory-deck-4"
	display_name = "NSV Victory - Command Deck"
	absolute_path = "maps/victory/levels/deck4.dmm"
	traits = list(
		ZTRAIT_STATION,
		ZTRAIT_FACILITY_SAFETY,
	)
	base_turf = /turf/simulated/open
	link_below = /datum/map_level/victory/ship/deck_three
	flags = LEGACY_LEVEL_STATION|LEGACY_LEVEL_CONTACT|LEGACY_LEVEL_PLAYER|LEGACY_LEVEL_CONSOLES

/datum/map_level/victory/flagship
	id = "VictoryFlagship"
	name = "Victory - Centcom / Flagship"
	display_id = "victory-flagship"
	display_name = "NSV Victory - Flagship Offboarding"
	absolute_path = "maps/victory/levels/flagship.dmm"
	flags = LEGACY_LEVEL_ADMIN|LEGACY_LEVEL_CONTACT

/datum/map_level/victory/transit
	id = "VictoryTransit"
	name = "Victory - Ships / Static Transit"
	absolute_path = "maps/victory/levels/transit.dmm"
	traits = list(
		ZTRAIT_LEGACY_BELTER_TRANSIT,
	)
	flags = LEGACY_LEVEL_ADMIN

/datum/map_level/victory/misc
	id = "VictoryMisc"
	name = "Victory - Misc"
	absolute_path = "maps/victory/levels/misc.dmm"
	flags = LEGACY_LEVEL_ADMIN

#undef VICTORY_MAP_SIZE
#undef VICTORY_HOLOMAP_CENTER_GUTTER
#undef VICTORY_HOLOMAP_MARGIN_X
#undef VICTORY_HOLOMAP_MARGIN_Y
