//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * point to point shuttle controller
 *
 * we have two destinations, linked directly via shuttle ids
 *
 * please use web shuttles for multi-dock on single destination support.
 *
 * the standard is 'shuttle shuttle load at home', which means:
 * * cargo shuttle starts centcom
 * * emergency shuttle starts centcom
 * * belter shuttle starts station
 */
/datum/shuttle_controller/ferry
	tgui_module = "TGUIShuttleFerry"

	/// home dock id or typepath
	var/dock_home_id
	/// away dock id or typepath
	var/dock_away_id
	#warn hook init for both

/datum/shuttle_controller/ferry/New(home_id, away_id)
	src.dock_home_id = home_id
	src.dock_away_id = away_id
	..()

/datum/shuttle_controller/ferry/proc/is_at_home()
	return shuttle.docked.dock_id == dock_home_id

/datum/shuttle_controller/ferry/proc/is_at_away()
	return shuttle.docked.dock_id == dock_away_id

/datum/shuttle_controller/ferry/proc/is_at_known_location()
	return is_at_home() || is_at_away()

/datum/shuttle_controller/ferry/tgui_static_data()
	. = ..()

/datum/shuttle_controller/ferry/tgui_data()
	. = ..()

#warn impl all
