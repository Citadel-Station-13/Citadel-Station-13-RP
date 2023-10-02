///////////////////////////////
/// 		Archive         ///
///////////////////////////////
/*
Contained in this file are the old datums for pre-overmap shuttles. Pretty much unused and
potentially none functional now. Still nothing wrong with keeping a little bit of history
stored for a bit. As well a fair few of these could be converted to use proper overmaps. If
one or more of these are properly converted just stick a comment next to its respective
archived cousin here.
*/
//////////////////
/// Trade Ship ///
//////////////////
/datum/shuttle/autodock/multi/trade
	name = "Trade"
	current_location = "trade_dock"
	shuttle_area = /area/shuttle/trade
	docking_controller_tag = "trade_shuttle"
	warmup_time = 10	//want some warmup time so people can cancel.
	destination_tags = list(
		"trade_dock",
		"tether_dockarm_d1l",
		"aerostat_south",
		"beach_e",
		"beach_c",
		"beach_nw"
	)
	defer_initialisation = TRUE
	move_direction = WEST

/////////////////////////
/// Mercenary Shuttle ///
/////////////////////////
/datum/shuttle/autodock/multi/mercenary
	name = "Mercenary"
	warmup_time = 8
	move_time = 60
	current_location = "merc_base"
	shuttle_area = /area/shuttle/mercenary
	destination_tags = list(
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
		"tether_dockarm_d2l" //End of right docking arm
		)
	docking_controller_tag = "merc_shuttle"
	announcer = "Automated Traffic Control"
	arrival_message = "Attention. An unregistered vessel is approaching Virgo-3B."
	departure_message = "Attention. A unregistered vessel is now leaving Virgo-3B."
	defer_initialisation = TRUE
	move_direction = WEST

/////////////////////
/// Ninja Shuttle ///
/////////////////////
/datum/shuttle/autodock/multi/ninja
	name = "Ninja"
	warmup_time = 8
	move_time = 60
	can_cloak = TRUE
	cloaked = TRUE
	current_location = "ninja_base"
	landmark_transition = "ninja_transit"
	shuttle_area = /area/shuttle/ninja
	destination_tags = list(
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
		"tether_dockarm_d1a3" //Inside of left dockarm
		)
	docking_controller_tag = "ninja_shuttle"
	announcer = "Automated Traffic Control"
	arrival_message = "Attention. An unregistered vessel is approaching Virgo-3B."
	departure_message = "Attention. A unregistered vessel is now leaving Virgo-3B."
	defer_initialisation = TRUE
	move_direction = NORTH

////////////////
/// Skipjack ///
////////////////
/datum/shuttle/autodock/multi/heist
	name = "Skipjack"
	warmup_time = 8
	move_time = 60
	can_cloak = TRUE
	cloaked = TRUE
	current_location = "skipjack_base"
	landmark_transition = "skipjack_transit"
	shuttle_area = /area/shuttle/skipjack
	destination_tags = list(
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
		"tether_dockarm_d1l" //End of left dockarm
		)
	//docking_controller_tag = ??? doesn't have one?
	announcer = "Automated Traffic Control"
	arrival_message = "Attention. An unregistered vessel is approaching Virgo-3B."
	departure_message = "Attention. A unregistered vessel is now leaving Virgo-3B."
	defer_initialisation = TRUE
	move_direction = NORTH

///////////////////
/// ERT Shuttle ///
///////////////////
/datum/shuttle/autodock/multi/specialops
	name = "NDV Phantom"
	can_cloak = TRUE
	cloaked = FALSE
	warmup_time = 8
	move_time = 60
	current_location = "specops_base"
	landmark_transition = "specops_transit"
	shuttle_area = /area/shuttle/specops/centcom
	destination_tags = list(
		"specops_base",
		"aerostat_south",
		"beach_e",
		"beach_nw",
		"tether_solars_ne",
		"tether_solars_sw",
		"tether_mine_nw",
		"tether_space_NE",
		"tether_space_SE",
		"tether_space_SW",
		"tether_dockarm_d1l" //End of left dockarm
		)
	docking_controller_tag = "ert1_control"
	announcer = "Automated Traffic Control"
	arrival_message = "Attention. An NT support vessel is approaching Virgo-3B."
	departure_message = "Attention. A NT support vessel is now leaving Virgo-3B."
	defer_initialisation = TRUE
	move_direction = WEST

