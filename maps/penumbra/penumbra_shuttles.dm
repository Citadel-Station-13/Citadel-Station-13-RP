/area/shuttle/penumbra/excursion/tether

/datum/shuttle_destination/excursion/docked_penumbra
	name = "Place Docking Arm"
	my_area = /area/shuttle/penumbra/excursion/tether

	dock_target = "d1a2_dock"
	radio_announce = 1
	announcer = "Excursion Shuttle"

//////////////////////////////////////////////////////////////
// Escape shuttle
/datum/shuttle/ferry/emergency/escape
	name = "Escape"
	location = 1 // At offsite
	warmup_time = 10
	area_offsite = /area/shuttle/escape/centcom
	area_station = /area/shuttle/escape/station
	area_transition = /area/shuttle/escape/transit
	docking_controller_tag = "escape_shuttle"
	dock_target_station = "escape_dock"
	dock_target_offsite = "centcom_dock"
	move_time = SHUTTLE_TRANSIT_DURATION_RETURN

//////////////////////////////////////////////////////////////
// Supply shuttle
/datum/shuttle/ferry/supply/cargo
	name = "Supply"
	location = 1
	warmup_time = 10
	area_offsite = /area/supply/dock
	area_station = /area/supply/station
	docking_controller_tag = "supply_shuttle"
	dock_target_station = "cargo_bay"
	flags = SHUTTLE_FLAGS_PROCESS|SHUTTLE_FLAGS_SUPPLY

//////////////////////////////////////////////////////////////
// Trade Ship
/*
/datum/shuttle/ferry/trade
	name = "Trade"
	location = 1
	warmup_time = 10	//want some warmup time so people can cancel.
	area_offsite = /area/shuttle/trade/centcom
	area_station = /area/shuttle/trade/station
	docking_controller_tag = "trade_shuttle"
	dock_target_station = "trade_shuttle_dock_airlock"
	dock_target_offsite = "trade_shuttle_bay"
*/

//////////////////////////////////////////////////////////////
// Antag Space "Proto Shuttle" Shuttle
/*
/datum/shuttle/multi_shuttle/protoshuttle
	name = "Proto"
	warmup_time = 8
	move_time = 60
	origin = /area/shuttle/antag_space/base
	interim = /area/shuttle/antag_space/transit
	start_location = "Home Base"
	destinations = list(
		"Nearby" = /area/shuttle/antag_space/north,
		"Docks" =  /area/shuttle/antag_space/docks
	)
	docking_controller_tag = "antag_space_shuttle"
	destination_dock_targets = list("Home Base" = "antag_space_dock")
*/

//////////////////////////////////////////////////////////////
// Antag Surface "Land Crawler" Shuttle
/*
/datum/shuttle/multi_shuttle/landcrawler
	name = "Land Crawler"
	warmup_time = 8
	move_time = 60
	origin = /area/shuttle/antag_ground/base
	interim = /area/shuttle/antag_ground/transit
	start_location = "Home Base"
	destinations = list(
		"Solar Array" = /area/shuttle/antag_ground/solars,
		"Mining Outpost" =  /area/shuttle/antag_ground/mining
	)
	docking_controller_tag = "antag_ground_shuttle"
	destination_dock_targets = list("Home Base" = "antag_ground_dock")
*/

//////////////////////////////////////////////////////////////
// Mercenary Shuttle
/*
/datum/shuttle/multi_shuttle/mercenary
	name = "Mercenary"
	warmup_time = 8
	move_time = 60
	origin = /area/syndicate_station/start
	//interim = /area/syndicate_station/transit // Disabled until this even exists.
	start_location = "Mercenary base"
	destinations = list(
		"Tether spaceport" = /area/syndicate_station/arrivals_dock
		)
	docking_controller_tag = "merc_shuttle"
	destination_dock_targets = list(
		"Mercenary base" = "merc_base",
		"Tether spaceport" = "nuke_shuttle_dock_airlock",
		)
	announcer = "Automated Traffic Control"

/datum/shuttle/multi_shuttle/mercenary/New()
	arrival_message = "Attention. An unregistered vessel is approaching Virgo-3B."
	departure_message = "Attention. A unregistered vessel is now leaving Virgo-3B."
	..()
*/

//////////////////////////////////////////////////////////////
//ERT
/*
/datum/shuttle/ferry/multidock/specops/ert
	name = "Special Operations"
	location = 0
	warmup_time = 10
	area_offsite = /area/shuttle/specops/station	//centcom is the home station, the Exodus is offsite
	area_station = /area/shuttle/specops/centcom
	docking_controller_tag = "specops_shuttle_port"
	docking_controller_tag_station = "specops_shuttle_port"
	docking_controller_tag_offsite = "specops_shuttle_fore"
	dock_target_station = "specops_centcom_dock"
	dock_target_offsite = "specops_dock_airlock"
*/