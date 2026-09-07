/datum/map/station/strelka
	id = "strelka"
	name = "World - Strelka"
	levels = list(
		/datum/map_level/strelka/ship/deck_four,
		/datum/map_level/strelka/ship/deck_three,
		/datum/map_level/strelka/ship/deck_two,
		/datum/map_level/strelka/ship/deck_one,
	)
	width = 192
	height = 192
	world_width = 192
	world_height = 192
	dependencies = list(
		/datum/map/centcom/ncv_astral,
	)
	lateload = list(
		/datum/map/sector/debrisfield_192,
	)

	// todo: remove after dev is done
	allow_random_draw = FALSE

	//* LEGACY BELOW *//

	legacy_assert_shuttle_datums = list(
		/datum/shuttle/autodock/overmap/excursion/strelka,
		/datum/shuttle/autodock/ferry/emergency/escape/strelka,
		/datum/shuttle/autodock/ferry/supply/cargo/strelka,
		/datum/shuttle/autodock/overmap/emt/strelka,
		/datum/shuttle/autodock/overmap/civvie/strelka,
		/datum/shuttle/autodock/overmap/trade/personalmicro1,
		/datum/shuttle/autodock/overmap/trade/personalmicro2,
		/datum/shuttle/autodock/overmap/trade/personalmicro3,
		/datum/shuttle/autodock/overmap/trade/personalmicro4,
		/datum/shuttle/autodock/ferry/belter,
	)

	full_name = "NEV Strelka"

	use_overmap = TRUE
	overmap_size = 60
	overmap_event_areas = 50
	usable_email_tlds = list("strelka.nt")
	titlescreens = list(
		list(
			'icons/misc/title_vr.dmi',
			"strelka",
		),
		)

	station_name	= "NEV Strelka"
	station_short	= "Strelka"
	dock_name		= "NCV Astral"
	dock_type		= "space"
	boss_name		= "Central Command"
	boss_short		= "CentCom"
	company_name	= "Nanotrasen"
	company_short	= "NT"
	starsys_name	= "Vacuum Crucis Expanse"

	shuttle_docked_message = "This is the %dock_name% calling to the NEV Strelka. The scheduled NCS Helios Junior shuttle has docked with the NEV Strelka. Departing crew should board the shuttle within %ETD%."
	shuttle_leaving_dock = "The transfer shuttle has left the ship. Estimate %ETA% until the shuttle arrives at the %dock_name%."
	shuttle_called_message = "This is the captain of the %dock_name% calling to the NEV Strelka. We will start schedule maintenance of the Strelka, So we are sending the NCS Helios Junior to get your crew. We should arrive in %ETD%."
	shuttle_recall_message = "Astral to Strelka. Message received and noted. Shuttle canceled, and on stand-by. Enjoy the rust and old carpet a bit more."
	shuttle_name =  "NCS Helios Junior"
	emergency_shuttle_docked_message = "The evacuation shuttle has arrived at the ship. You have approximately %ETD% to board the shuttle."
	emergency_shuttle_leaving_dock = "Captain of the Astral to NEV Strelka : The emergency shuttle has left the ship. Estimate %ETA% until the shuttle arrives at %dock_name%. You will be safe in no time."
	emergency_shuttle_called_message =  "Astral to Strelka. Understood. Sending emergency shuttle. ETA in approximately %ETA%. Hang on a bit."
	emergency_shuttle_recall_message = "Astral to Strelka, The evacuation shuttle has been recalled, but we are still on standby."

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
							"Strelka",
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
/// Width and height of compiled in strelka z levels.
#define STRELKA_MAP_SIZE 192
/// 40px central gutter between columns
#define STRELKA_HOLOMAP_CENTER_GUTTER 20
/// 100
#define STRELKA_HOLOMAP_MARGIN_X ((HOLOMAP_ICON_SIZE - (2*STRELKA_MAP_SIZE) - STRELKA_HOLOMAP_CENTER_GUTTER) / 2)
/// 60
#define STRELKA_HOLOMAP_MARGIN_Y ((HOLOMAP_ICON_SIZE - (3*STRELKA_MAP_SIZE)) / 2)
// We have a bunch of stuff common to the station z levels

/datum/map_level/strelka/ship
	flags = LEGACY_LEVEL_STATION|LEGACY_LEVEL_CONTACT|LEGACY_LEVEL_PLAYER|LEGACY_LEVEL_CONSOLES
	persistence_allowed = TRUE

/datum/map_level/strelka/ship/deck_four
	id = "StrelkaDeck4"
	name = "strelka - Deck 4"
	display_id = "strelka-deck-4"
	display_name = "NEV Strelka - Deck 4"
	path = "maps/stations/strelka/levels/strelka_deck4.dmm"
	traits = list(
		ZTRAIT_STATION,
		ZTRAIT_FACILITY_SAFETY,
	)
	base_turf = /turf/simulated/open
	struct_x = 0
	struct_y = 0
	struct_z = 3
	flags = LEGACY_LEVEL_STATION|LEGACY_LEVEL_CONTACT|LEGACY_LEVEL_PLAYER|LEGACY_LEVEL_CONSOLES

/datum/map_level/strelka/ship/deck_three
	id = "StrelkaDeck3"
	name = "strelka - Deck 3"
	display_id = "strelka-deck-3"
	display_name = "NEV Strelka - Deck 3"
	path = "maps/stations/strelka/levels/strelka_deck3.dmm"
	traits = list(
		ZTRAIT_STATION,
		ZTRAIT_FACILITY_SAFETY,
		ZTRAIT_LEGACY_BELTER_DOCK,
	)
	base_turf = /turf/simulated/open
	struct_x = 0
	struct_y = 0
	struct_z = 2
	flags = LEGACY_LEVEL_STATION|LEGACY_LEVEL_CONTACT|LEGACY_LEVEL_PLAYER|LEGACY_LEVEL_CONSOLES

/datum/map_level/strelka/ship/deck_two
	id = "StrelkaDeck2"
	name = "strelka - Deck 2"
	display_id = "strelka-deck-2"
	display_name = "NEV Strelka - Deck 2"
	path = "maps/stations/strelka/levels/strelka_deck2.dmm"
	traits = list(
		ZTRAIT_STATION,
		ZTRAIT_FACILITY_SAFETY,
	)
	base_turf = /turf/simulated/open
	struct_x = 0
	struct_y = 0
	struct_z = 1
	flags = LEGACY_LEVEL_STATION|LEGACY_LEVEL_CONTACT|LEGACY_LEVEL_PLAYER|LEGACY_LEVEL_CONSOLES

/datum/map_level/strelka/ship/deck_one
	id = "StrelkaDeck1"
	name = "strelka - Deck 1"
	display_id = "strelka-deck-1"
	display_name = "NEV Strelka - Deck 1"
	path ="maps/stations/strelka/levels/strelka_deck1.dmm"
	traits = list(
		ZTRAIT_STATION,
		ZTRAIT_FACILITY_SAFETY,
	)
	base_turf = /turf/simulated/open
	struct_x = 0
	struct_y = 0
	struct_z = 0
	flags = LEGACY_LEVEL_STATION|LEGACY_LEVEL_CONTACT|LEGACY_LEVEL_PLAYER|LEGACY_LEVEL_CONSOLES

#undef STRELKA_MAP_SIZE
#undef STRELKA_HOLOMAP_CENTER_GUTTER
#undef STRELKA_HOLOMAP_MARGIN_X
#undef STRELKA_HOLOMAP_MARGIN_Y
