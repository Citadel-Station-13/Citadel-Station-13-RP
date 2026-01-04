/**
 * Endeavour
 *
 * * Shipmap
 *
 * # Credits
 *
 * Thanks to the following people for their contributions on this map.
 * * GySgtMurphy
 * * Niezan
 * * Washikarasu
 * * APMK
 * * LordME
 */
/datum/map/station/endeavour
	id = "endeavour"
	name = "World - Endeavour"
	levels = list(
		/datum/map_level/endeavour/ship/deck_four,
		/datum/map_level/endeavour/ship/deck_three,
		/datum/map_level/endeavour/ship/deck_two,
		/datum/map_level/endeavour/ship/deck_one,
		/datum/map_level/endeavour/misc,
		/datum/map_level/endeavour/transit,
	)
	width = 192
	height = 192
	world_width = 192
	world_height = 192
	dependencies = list(
		/datum/map/centcom/ncv_oracle,
	)
	lateload = list(
		/datum/map/sector/debrisfield_192,
		/datum/map/sector/piratebase_192,
		/datum/map/sector/mining_192,
		/datum/map/sector/gaia_192,
		/datum/map/sector/frozen_192,
		/datum/map/sector/wasteland_192,
		/datum/map/sector/nebula_tradeport,
		/datum/map/sector/delerict_casino,
		/datum/map/sector/surt,
		/datum/map/sector/miaphus,
		/datum/map/sector/roguemining_192/one,
		/datum/map/sector/sky_planet,
		/datum/map/sector/solars_station,
		/datum/map/sector/ice_comet,
		/datum/map/sector/osiris_field,
	)

	overmap_initializer = /datum/overmap_initializer/map{
		legacy_entity_type = /obj/overmap/entity/visitable/ship/endeavour;
	}

	//* LEGACY BELOW *//

	legacy_assert_shuttle_datums = list(
		/datum/shuttle/autodock/overmap/excursion/endeavour,
		/datum/shuttle/autodock/ferry/emergency/escape/endeavour,
		/datum/shuttle/autodock/ferry/supply/cargo/endeavour,
		/datum/shuttle/autodock/overmap/emt/endeavour,
		/datum/shuttle/autodock/overmap/mining/endeavour,
		/datum/shuttle/autodock/overmap/civvie/endeavour,
		/datum/shuttle/autodock/overmap/courser/endeavour,
		/datum/shuttle/autodock/ferry/belter,
	)

	full_name = "NSV Endeavour"

	use_overmap = TRUE
	overmap_size = 60
	overmap_event_areas = 50
	usable_email_tlds = list("endeavour.nt")

	station_name	= "NSV Endeavour"
	station_short	= "Endeavour"
	dock_name		= "NCV Oracle"
	dock_type		= "space"
	boss_name		= "Central Command"
	boss_short		= "CentCom"
	company_name	= "Nanotrasen"
	company_short	= "NT"
	starsys_name	= "Lythios-43"

	shuttle_docked_message = "This is the %dock_name% calling to the NSV Endeavour. The scheduled NTV Hermes shuttle flight has docked with the NSV Endeavour. Departing crew should board the shuttle within %ETD%."
	shuttle_leaving_dock = "The transfer shuttle has left the ship. Estimate %ETA% until the shuttle arrives at the %dock_name%."
	shuttle_called_message = "This is the %dock_name% calling to the NSV Endeavour. A scheduled crew transfer to the %dock_name% is commencing. Those departing should proceed to the shuttle bay within %ETA%."
	shuttle_recall_message = "The scheduled crew transfer has been cancelled."
	shuttle_name = "NTV Hermes"
	emergency_shuttle_docked_message = "The evacuation shuttle has arrived at the ship. You have approximately %ETD% to board the shuttle."
	emergency_shuttle_leaving_dock = "The emergency shuttle has left the ship. Estimate %ETA% until the shuttle arrives at %dock_name%."
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
							"Endeavour",
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

	allowed_spawns = list(LATEJOIN_METHOD_ARRIVALS_SHUTTLE,LATEJOIN_METHOD_GATEWAY,LATEJOIN_METHOD_CRYOGENIC_STORAGE,LATEJOIN_METHOD_ROBOT_STORAGE,"Beruang Trading Corp Cryo","Nebula Visitor Arrival")
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
/// Width and height of compiled in endeavour z levels.
#define ENDEAVOUR_MAP_SIZE 192
/// 40px central gutter between columns
#define ENDEAVOUR_HOLOMAP_CENTER_GUTTER 20
/// 100
#define ENDEAVOUR_HOLOMAP_MARGIN_X ((HOLOMAP_ICON_SIZE - (2*ENDEAVOUR_MAP_SIZE) - ENDEAVOUR_HOLOMAP_CENTER_GUTTER) / 2)
/// 60
#define ENDEAVOUR_HOLOMAP_MARGIN_Y ((HOLOMAP_ICON_SIZE - (3*ENDEAVOUR_MAP_SIZE)) / 2)
// We have a bunch of stuff common to the station z levels

/datum/map_level/endeavour/ship
	flags = LEGACY_LEVEL_STATION|LEGACY_LEVEL_CONTACT|LEGACY_LEVEL_PLAYER|LEGACY_LEVEL_CONSOLES
	persistence_allowed = TRUE

/datum/map_level/endeavour/ship/deck_one
	id = "EndeavourDeck1"
	name = "Endeavour - Deck 1"
	display_id = "endeavour-deck-1"
	display_name = "NSV Endeavour - Command Deck"
	path = "maps/stations/endeavour/levels/deck1.dmm"
	traits = list(
		ZTRAIT_STATION,
		ZTRAIT_FACILITY_SAFETY,
	)
	struct_x = 0
	struct_y = 0
	struct_z = 3
	base_turf = /turf/space
	flags = LEGACY_LEVEL_STATION|LEGACY_LEVEL_CONTACT|LEGACY_LEVEL_PLAYER|LEGACY_LEVEL_CONSOLES

/datum/map_level/endeavour/ship/deck_two
	id = "EndeavourDeck2"
	name = "Endeavour - Deck 2"
	display_id = "endeavour-deck-2"
	display_name = "NSV Endeavour - MedSci Deck"
	path = "maps/stations/endeavour/levels/deck2.dmm"
	traits = list(
		ZTRAIT_STATION,
		ZTRAIT_FACILITY_SAFETY,
	)
	struct_x = 0
	struct_y = 0
	struct_z = 2
	base_turf = /turf/simulated/open
	flags = LEGACY_LEVEL_STATION|LEGACY_LEVEL_CONTACT|LEGACY_LEVEL_PLAYER|LEGACY_LEVEL_CONSOLES

/datum/map_level/endeavour/ship/deck_three
	id = "EndeavourDeck3"
	name = "Endeavour - Deck 3"
	display_id = "endeavour-deck-3"
	display_name = "NSV Endeavour - Service & Security Deck"
	path = "maps/stations/endeavour/levels/deck3.dmm"
	traits = list(
		ZTRAIT_STATION,
		ZTRAIT_FACILITY_SAFETY,
		ZTRAIT_LEGACY_BELTER_DOCK,
	)
	struct_x = 0
	struct_y = 0
	struct_z = 1
	base_turf = /turf/simulated/open
	flags = LEGACY_LEVEL_STATION|LEGACY_LEVEL_CONTACT|LEGACY_LEVEL_PLAYER|LEGACY_LEVEL_CONSOLES

/datum/map_level/endeavour/ship/deck_four
	id = "EndeavourDeck4"
	name = "Endeavour - Deck 4"
	display_id = "endeavour-deck-4"
	display_name = "NSV Endeavour - Engineering Deck"
	path = "maps/stations/endeavour/levels/deck4.dmm"
	traits = list(
		ZTRAIT_STATION,
		ZTRAIT_FACILITY_SAFETY,
	)
	struct_x = 0
	struct_y = 0
	struct_z = 0
	base_turf = /turf/simulated/open
	flags = LEGACY_LEVEL_STATION|LEGACY_LEVEL_CONTACT|LEGACY_LEVEL_PLAYER|LEGACY_LEVEL_CONSOLES

/datum/map_level/endeavour/transit
	id = "EndeavourTransit"
	name = "Endeavour - Ships / Static Transit"
	path = "maps/stations/endeavour/levels/transit.dmm"
	traits = list(
		ZTRAIT_LEGACY_BELTER_TRANSIT,
	)
	flags = LEGACY_LEVEL_ADMIN

/datum/map_level/endeavour/misc
	id = "EndeavourMisc"
	name = "Endeavour - Misc"
	path = "maps/stations/endeavour/levels/misc.dmm"
	flags = LEGACY_LEVEL_ADMIN

#undef ENDEAVOUR_MAP_SIZE
#undef ENDEAVOUR_HOLOMAP_CENTER_GUTTER
#undef ENDEAVOUR_HOLOMAP_MARGIN_X
#undef ENDEAVOUR_HOLOMAP_MARGIN_Y
