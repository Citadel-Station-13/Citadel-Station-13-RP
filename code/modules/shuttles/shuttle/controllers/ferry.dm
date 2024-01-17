//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * point to point shuttle controller
 *
 * we have two destinations, linked directly via shuttle ids
 *
 * please use web shuttles for multi-dock one-destination.
 */
/datum/shuttle_controller/ferry
	tgui_module = "TGUIShuttleFerry"
	/// home dock id or typepath
	var/dock_home_id
	/// away dock id or typepath
	var/dock_away_id
	/// travel time
	var/travel_time = 10 SECONDS
	#warn hook init for both

/datum/shuttle_controller/ferry/proc/is_at_home()
	return shuttle.docked.dock_id == dock_home_id

/datum/shuttle_controller/ferry/proc/is_at_away()
	return shuttle.docked.dock_id == dock_away_id

/datum/shuttle_controller/ferry/proc/is_at_known_location()
	return is_at_home() || is_at_away()

#warn impl all
