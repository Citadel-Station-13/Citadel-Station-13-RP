/datum/map/station/triumph
	id = "triumph"
	name = "World - Triumph"
	levels = list(
		/datum/map_level/triumph/ship/deck_one,
		/datum/map_level/triumph/ship/deck_two,
		/datum/map_level/triumph/ship/deck_three,
		/datum/map_level/triumph/ship/deck_four,
		/datum/map_level/triumph/misc,
		/datum/map_level/triumph/transit,
		/datum/map_level/triumph/flagship,
	)
	width = 140
	height = 140
	orientation = WEST
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

	//* LEGACY BELOW *//

	legacy_assert_shuttle_datums = list(
		/datum/shuttle/autodock/overmap/excursion/triumph,
		/datum/shuttle/autodock/ferry/emergency/escape/triumph,
		/datum/shuttle/autodock/ferry/supply/cargo/triumph,
		/datum/shuttle/autodock/overmap/emt/triumph,
		/datum/shuttle/autodock/overmap/mining/triumph,
		/datum/shuttle/autodock/overmap/civvie/triumph,
		/datum/shuttle/autodock/overmap/courser/triumph,
		/datum/shuttle/autodock/ferry/belter,
	)

	full_name = "NSV Triumph"

	use_overmap = TRUE
	overmap_size = 60
	overmap_event_areas = 50
	usable_email_tlds = list("triumph.nt")

	station_name	= "NSV Triumph"
	station_short	= "Triumph"
	dock_name		= "NDV Marksman"
	dock_type		= "space"
	boss_name		= "Central Command"
	boss_short		= "CentCom"
	company_name	= "NanoTrasen"
	company_short	= "NT"
	starsys_name	= "Sigmar Concord"

	shuttle_docked_message = "This is the %dock_name% calling to the NSV Triumph. The scheduled crew transfer shuttle has docked with the NSV Triumph. Departing crew should board the shuttle within %ETD%."
	shuttle_leaving_dock = "The transfer shuttle has left the ship. Estimate %ETA% until the shuttle arrives at the %dock_name%."
	shuttle_called_message = "This is the %dock_name% calling to the NSV Triumph. A scheduled crew transfer to the %dock_name% is commencing. Those departing should proceed to the shuttle bay within %ETA%."
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
							NETWORK_TRIUMPH
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

	allowed_spawns = list("Shuttle Bay","Gateway","Cryogenic Storage","Cyborg Storage","Beruang Trading Corp Cryo")
	spawnpoint_died = /datum/spawnpoint/shuttle
	spawnpoint_left = /datum/spawnpoint/shuttle
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
/// Width and height of compiled in triumph z levels.
#define TRIUMPH_MAP_SIZE 192
/// 40px central gutter between columns
#define TRIUMPH_HOLOMAP_CENTER_GUTTER 20
/// 100
#define TRIUMPH_HOLOMAP_MARGIN_X ((HOLOMAP_ICON_SIZE - (2*TRIUMPH_MAP_SIZE) - TRIUMPH_HOLOMAP_CENTER_GUTTER) / 2)
/// 60
#define TRIUMPH_HOLOMAP_MARGIN_Y ((HOLOMAP_ICON_SIZE - (3*TRIUMPH_MAP_SIZE)) / 2)
// We have a bunch of stuff common to the station z levels

/datum/map_level/triumph/ship
	flags = LEGACY_LEVEL_STATION|LEGACY_LEVEL_CONTACT|LEGACY_LEVEL_PLAYER|LEGACY_LEVEL_CONSOLES

/datum/map_level/triumph/ship/deck_one
	id = "TriumphDeck1"
	name = "Triumph - Deck 1"
	display_id = "triumph-deck-1"
	display_name = "NSV Triumph - Engineering Deck"
	absolute_path = "maps/triumph/levels/deck1.dmm"
	traits = list(
		ZTRAIT_STATION,
		ZTRAIT_FACILITY_SAFETY,
	)
	base_turf = /turf/space
	link_above = /datum/map_level/triumph/ship/deck_two
	flags = LEGACY_LEVEL_STATION|LEGACY_LEVEL_CONTACT|LEGACY_LEVEL_PLAYER|LEGACY_LEVEL_CONSOLES

/datum/map_level/triumph/ship/deck_two
	id = "TriumphDeck2"
	name = "Triumph - Deck 2"
	display_id = "triumph-deck-2"
	display_name = "NSV Triumph - Service Deck"
	absolute_path = "maps/triumph/levels/deck2.dmm"
	traits = list(
		ZTRAIT_STATION,
		ZTRAIT_FACILITY_SAFETY,
		ZTRAIT_LEGACY_BELTER_DOCK,
	)
	base_turf = /turf/simulated/open
	link_above = /datum/map_level/triumph/ship/deck_three
	link_below = /datum/map_level/triumph/ship/deck_one
	flags = LEGACY_LEVEL_STATION|LEGACY_LEVEL_CONTACT|LEGACY_LEVEL_PLAYER|LEGACY_LEVEL_CONSOLES

/datum/map_level/triumph/ship/deck_three
	id = "TriumphDeck3"
	name = "Triumph - Deck 3"
	display_id = "triumph-deck-3"
	display_name = "NSV Triumph - Operations Deck"
	absolute_path = "maps/triumph/levels/deck3.dmm"
	traits = list(
		ZTRAIT_STATION,
		ZTRAIT_FACILITY_SAFETY,
	)
	base_turf = /turf/simulated/open
	link_above = /datum/map_level/triumph/ship/deck_four
	link_below = /datum/map_level/triumph/ship/deck_two
	flags = LEGACY_LEVEL_STATION|LEGACY_LEVEL_CONTACT|LEGACY_LEVEL_PLAYER|LEGACY_LEVEL_CONSOLES

/datum/map_level/triumph/ship/deck_four
	id = "TriumphDeck4"
	name = "Triumph - Deck 4"
	display_id = "triumph-deck-4"
	display_name = "NSV Triumph - Command Deck"
	absolute_path = "maps/triumph/levels/deck4.dmm"
	traits = list(
		ZTRAIT_STATION,
		ZTRAIT_FACILITY_SAFETY,
	)
	base_turf = /turf/simulated/open
	link_below = /datum/map_level/triumph/ship/deck_three
	flags = LEGACY_LEVEL_STATION|LEGACY_LEVEL_CONTACT|LEGACY_LEVEL_PLAYER|LEGACY_LEVEL_CONSOLES

/datum/map_level/triumph/flagship
	id = "TriumphFlagship"
	name = "Triumph - Centcom / Flagship"
	display_id = "triumph-flagship"
	display_name = "NSV Triumph - Flagship Offboarding"
	absolute_path = "maps/triumph/levels/flagship.dmm"
	flags = LEGACY_LEVEL_ADMIN|LEGACY_LEVEL_CONTACT

/datum/map_level/triumph/transit
	id = "TriumphTransit"
	name = "Triumph - Ships / Static Transit"
	absolute_path = "maps/triumph/levels/transit.dmm"
	traits = list(
		ZTRAIT_LEGACY_BELTER_TRANSIT,
	)
	flags = LEGACY_LEVEL_ADMIN

/datum/map_level/triumph/misc
	id = "TriumphMisc"
	name = "Triumph - Misc"
	absolute_path = "maps/triumph/levels/misc.dmm"
	flags = LEGACY_LEVEL_ADMIN

#undef TRIUMPH_MAP_SIZE
#undef TRIUMPH_HOLOMAP_CENTER_GUTTER
#undef TRIUMPH_HOLOMAP_MARGIN_X
#undef TRIUMPH_HOLOMAP_MARGIN_Y
