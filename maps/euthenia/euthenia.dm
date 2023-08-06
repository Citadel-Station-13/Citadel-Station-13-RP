/datum/map/station/euthenia
	id = "euthenia"
	name = "World - Euthenia"

	width = 192
	height = 192

	levels = list(
		/datum/map_level/euthenia/deck/one,
		/datum/map_level/euthenia/deck/two,
		/datum/map_level/euthenia/deck/three,
		/datum/map_level/euthenia/deck/four,
		/datum/map_level/euthenia/deck/five,
		/datum/map_level/euthenia/misc,
	)

	full_name = "NSV Euthenia"
	legacy_persistence_id = "euthenia"
	full_name = "NSV Euthenia"
	use_overmap = TRUE
	overmap_size = 60
	overmap_event_areas = 50
	usable_email_tlds = list("euthenia.nt")

	titlescreens = list(
		list(
			'icons/misc/title_vr.dmi',
			"title1",
		),
		list(
			'icons/misc/title_vr.dmi',
			"title2",
		),
		list(
			'icons/misc/title_vr.dmi',
			"title3",
		),
		list(
			'icons/misc/title_vr.dmi',
			"title4",
		),
		list(
			'icons/misc/title_vr.dmi',
			"title5",
		),
		list(
			'icons/misc/title_vr.dmi',
			"title6",
		),
		list(
			'icons/misc/title_vr.dmi',
			"title7",
		),
		list(
			'icons/misc/title_vr.dmi',
			"title8",
		),
		list(
			'icons/misc/title_vr.dmi',
			"bnny",
		),
	)

	admin_levels = list()
	sealed_levels = list()
	empty_levels = null
	station_levels = list(Z_LEVEL_DECK_ONE,
		Z_LEVEL_DECK_TWO,
		Z_LEVEL_DECK_THREE,
		Z_LEVEL_DECK_FOUR)
	contact_levels = list(Z_LEVEL_DECK_ONE,
		Z_LEVEL_DECK_TWO,
		Z_LEVEL_DECK_THREE,
		Z_LEVEL_DECK_FOUR)
	player_levels = list(Z_LEVEL_DECK_ONE,
		Z_LEVEL_DECK_TWO,
		Z_LEVEL_DECK_THREE,
		Z_LEVEL_DECK_FOUR)

	holomap_smoosh = list(list(
		Z_LEVEL_DECK_ONE,
		Z_LEVEL_DECK_TWO,
		Z_LEVEL_DECK_THREE,
		Z_LEVEL_DECK_FOUR))

	station_name	= "NSV Euthenia"
	station_short	= "Euthenia"
	dock_name		= "NDV Marksman"
	dock_type		= "space"
	boss_name		= "Central Command"
	boss_short		= "CentCom"
	company_name	= "NanoTrasen"
	company_short	= "NT"
	starsys_name	= "Sigmar Concord"

	shuttle_docked_message = "This is the %dock_name% calling to the NSV Euthenia. The scheduled crew transfer shuttle has docked with the NSV Euthenia. Departing crew should board the shuttle within %ETD%."
	shuttle_leaving_dock = "The transfer shuttle has left the ship. Estimate %ETA% until the shuttle arrives at the %dock_name%."
	shuttle_called_message = "This is the %dock_name% calling to the NSV Euthenia. A scheduled crew transfer to the %dock_name% is commencing. Those departing should proceed to the shuttle bay within %ETA%."
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
							NETWORK_TCOMMS
//							NETWORK_TRIUMPH
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

	bot_patrolling = TRUE

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

/datum/map_level/euthenia/deck/one
	id = "EutheniaDeck1"
	name = "Euthenia - Deck 1"
	display_id = "euthenia-1"
	display_name = "NSV Euthenia Deck 1"
	absolute_path = "maps/euthenia/levels/deck1.dmm"
	traits = list(
		ZTRAIT_STATION,
		ZTRAIT_FACILITY_SAFETY,
	)
	base_turf = /turf/space
	flags = LEGACY_LEVEL_CONTACT | LEGACY_LEVEL_PLAYER | LEGACY_LEVEL_CONSOLES
	link_above = /datum/map_level/euthenia/deck/two

/datum/map_level/euthenia/deck/two
	id = "EutheniaDeck2"
	name = "Euthenia - Deck 2"
	display_id = "euthenia-2"
	display_name = "NSV Euthenia Deck 2"
	absolute_path = "maps/euthenia/levels/deck2.dmm"
	traits = list(
		ZTRAIT_STATION,
		ZTRAIT_FACILITY_SAFETY,
	)
	base_turf = /turf/simulated/open
	flags = LEGACY_LEVEL_CONTACT | LEGACY_LEVEL_PLAYER | LEGACY_LEVEL_CONSOLES
	link_above = /datum/map_level/euthenia/deck/three
	link_below = /datum/map_level/euthenia/deck/one

/datum/map_level/euthenia/deck/three
	id = "EutheniaDeck3"
	name = "Euthenia - Deck 3"
	display_id = "euthenia-3"
	display_name = "NSV Euthenia Deck 3"
	absolute_path = "maps/euthenia/levels/deck3.dmm"
	traits = list(
		ZTRAIT_STATION,
		ZTRAIT_FACILITY_SAFETY,
	)
	base_turf = /turf/simulated/open
	flags = LEGACY_LEVEL_CONTACT | LEGACY_LEVEL_PLAYER | LEGACY_LEVEL_CONSOLES
	link_above = /datum/map_level/euthenia/deck/four
	link_below = /datum/map_level/euthenia/deck/two

/datum/map_level/euthenia/deck/four
	id = "EutheniaDeck4"
	name = "Euthenia - Deck 4"
	display_id = "euthenia-4"
	display_name = "NSV Euthenia Deck 4"
	absolute_path = "maps/euthenia/levels/deck4.dmm"
	traits = list(
		ZTRAIT_STATION,
		ZTRAIT_FACILITY_SAFETY,
	)
	base_turf = /turf/simulated/open
	flags = LEGACY_LEVEL_CONTACT | LEGACY_LEVEL_PLAYER | LEGACY_LEVEL_CONSOLES
	link_above = /datum/map_level/euthenia/deck/five
	link_below = /datum/map_level/euthenia/deck/three

/datum/map_level/euthenia/deck/five
	id = "EutheniaDeck5"
	name = "Euthenia - Deck 5"
	display_id = "euthenia-5"
	display_name = "NSV Euthenia Deck 5"
	absolute_path = "maps/euthenia/levels/deck5.dmm"
	traits = list(
		ZTRAIT_STATION,
		ZTRAIT_FACILITY_SAFETY,
	)
	base_turf = /turf/simulated/open
	flags = LEGACY_LEVEL_CONTACT | LEGACY_LEVEL_PLAYER | LEGACY_LEVEL_CONSOLES
	link_below = /datum/map_level/euthenia/deck/four

/datum/map_level/euthenia/misc
	id = "EutheniaMisc"
	name = "Euthenia - Misc"
	display_id = "euthenia-command"
	display_name = "NSV Euthenia Command Relay"
	absolute_path = "maps/euthenia/levels/misc.dmm"
	traits = list()
	base_turf = /turf/space
	flags = LEGACY_LEVEL_CONTACT | LEGACY_LEVEL_PLAYER | LEGACY_LEVEL_CONSOLES
