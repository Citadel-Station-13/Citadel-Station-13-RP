//////////////////////////////////////////////////////////////
// Escape shuttle and pods
/datum/shuttle/autodock/ferry/emergency/escape
	name = "Escape"
	location = FERRY_LOCATION_OFFSITE
	shuttle_area = /area/centcom/shuttle
	warmup_time = 10
	landmark_offsite = "escape_cc"
	landmark_station = "escape_triumph"
	landmark_transition = "escape_transit"
	move_time = SHUTTLE_TRANSIT_DURATION_RETURN

//////////////////////////////////////////////////////////////
/datum/shuttle/autodock/ferry/escape_pod/large_escape_pod1
	name = "Large Escape Pod 1"
	location = FERRY_LOCATION_STATION
	shuttle_area = /area/shuttle/large_escape_pod1
	warmup_time = 0
	landmark_station = "escapepod1_station"
	landmark_offsite = "escapepod1_cc"
	landmark_transition = "escapepod1_transit"
	docking_controller_tag = "large_escape_pod_1"
	move_time = SHUTTLE_TRANSIT_DURATION_RETURN

//////////////////////////////////////////////////////////////
// Supply shuttle
/datum/shuttle/autodock/ferry/supply/cargo
	name = "Supply"
	location = FERRY_LOCATION_OFFSITE
	shuttle_area = /area/shuttle/supply
	warmup_time = 10
	landmark_offsite = "supply_cc"
	landmark_station = "supply_dock"
	docking_controller_tag = "supply_shuttle"
	flags = SHUTTLE_FLAGS_PROCESS|SHUTTLE_FLAGS_SUPPLY

//////////////////////////////////////////////////////////////
// TODO - Zandario/Enzo - Get these compatible

// Trade Ship
/*
/datum/shuttle/autodock/multi/trade
	name = "Trade"
	current_location = "cc_trade_dock"
	shuttle_area = /area/shuttle/trade
	docking_controller_tag = "trade_shuttle"
	warmup_time = 10	// Want some warmup time so people can cancel.
	destination_tags = list(
		"cc_trade_dock",
		"nav_capitalship_docking1",
		"nav_capitalship_docking2"
	)

//////////////////////////////////////////////////////////////
// Mercenary Shuttle
/datum/shuttle/autodock/multi/mercenary
	name = "Mercenary"
	warmup_time = 8
	move_time = 60
	current_location = "merc_base"
	shuttle_area = /area/shuttle/mercenary
	destinations = list(
		"merc_base",
		"aerostat_south",
		"beach_e",
		"beach_nw",
		"tether_solars_ne",
		"tether_solars_sw",
		"tether_mine_nw",
		"tether_space_NE",
		"tether_space_SE",
		"tether_space_SW",
		"tether_dockarm_d2l"	// End of right docking arm
		)
	docking_controller_tag = "merc_shuttle"
	announcer = "Automated Traffic Control"
	arrival_message = "Attention. An unregistered vessel is approaching Virgo-3B."
	departure_message = "Attention. A unregistered vessel is now leaving Virgo-3B."


//////////////////////////////////////////////////////////////
// Ninja Shuttle
/datum/shuttle/autodock/multi/ninja
	name = "Ninja"
	warmup_time = 8
	move_time = 60
	can_cloak = TRUE
	cloaked = TRUE
	current_location = "ninja_base"
	landmark_transition = "ninja_transit"
	shuttle_area = /area/shuttle/ninja
	destinations = list(
		"ninja_base",
		"aerostat_northeast",
		"beach_e",
		"beach_nw",
		"tether_solars_ne",
		"tether_solars_sw",
		"tether_mine_nw",
		"tether_space_NE",
		"tether_space_SE",
		"tether_space_SW",
		"tether_dockarm_d1a3"	// Inside of left dockarm
		)
	docking_controller_tag = "ninja_shuttle"
	announcer = "Automated Traffic Control"
	arrival_message = "Attention. An unregistered vessel is approaching Virgo-3B."
	departure_message = "Attention. A unregistered vessel is now leaving Virgo-3B."

//////////////////////////////////////////////////////////////
// Skipjack
/datum/shuttle/autodock/multi/heist
	name = "Skipjack"
	warmup_time = 8
	move_time = 60
	can_cloak = TRUE
	cloaked = TRUE
	current_location = "skipjack_base"
	landmark_transition = "skipjack_transit"
	shuttle_area = /area/shuttle/skipjack
	destinations = list(
		"skipjack_base",
		"aerostat_south",
		"beach_e",
		"beach_nw",
		"tether_solars_ne",
		"tether_solars_sw",
		"tether_mine_nw",
		"tether_space_NE",
		"tether_space_SE",
		"tether_space_SW",
		"tether_dockarm_d1l"	// End of left dockarm
		)
	//docking_controller_tag = ??? doesn't have one?
	destination_dock_targets = list(
		"Mercenary base" = "merc_base",
		"Tether spaceport" = "nuke_shuttle_dock_airlock",
		)
	announcer = "Automated Traffic Control"

	arrival_message = "Attention. An unregistered vessel is approaching Virgo-3B."
	departure_message = "Attention. A unregistered vessel is now leaving Virgo-3B."

//////////////////////////////////////////////////////////////
// ERT Shuttle
/datum/shuttle/autodock/multi/specialops
	name = "NDV Phantom"
	can_cloak = TRUE
	cloaked = FALSE
	warmup_time = 8
	move_time = 60
	current_location = "specops_base"
	landmark_transition = "specops_transit"
	shuttle_area = /area/shuttle/specialops
	destination_tags = list(
		"specops_base",
		"aerostat_northwest",
		"beach_e",
		"beach_nw",
		"tether_solars_ne",
		"tether_solars_sw",
		"tether_mine_nw",
		"tether_space_NE",
		"tether_space_SE",
		"tether_space_SW",
		"tether_dockarm_d2a2"	// Top of right docking arm
		)
	docking_controller_tag = "specops_shuttle_hatch"
	announcer = "Automated Traffic Control"
	arrival_message = "Attention. An NT support vessel is approaching Virgo-3B."
	departure_message = "Attention. A NT support vessel is now leaving Virgo-3B."
*/
//////////////////////////////////////////////////////////////
// RogueMiner "Belter: Shuttle
// TODO - Not implemented yet on new map

/datum/shuttle/autodock/ferry/belter
	name = "Belter"
	location = FERRY_LOCATION_STATION
	warmup_time = 6
	move_time = 30
	shuttle_area = /area/shuttle/belter
	landmark_station = "belter_station"
	landmark_offsite = "belter_zone1"
	landmark_transition = "belter_transit"
	docking_controller_tag = "belter_docking"

/datum/shuttle/autodock/ferry/belter/New()
	move_time = move_time + rand(-10 SECONDS, 20 SECONDS) //50sec max, 20sec min.
	..()


//////////////////////////////////////////////////////////////
// CC Lewdship shuttle
// DISABLED - cruiser has been removed entirely
/*
/datum/shuttle/autodock/ferry/cruiser_shuttle
	name = "Cruiser Shuttle"
	location = 1
	warmup_time = 10	//want some warmup time so people can cancel.
	area_offsite = /area/shuttle/cruiser/cruiser
	area_station = /area/shuttle/cruiser/station
	docking_controller_tag = "cruiser_shuttle"
	dock_target_station = "d1a1_dock"
	dock_target_offsite = "cruiser_shuttle_bay"
*/
