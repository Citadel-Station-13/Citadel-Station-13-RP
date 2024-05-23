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

/datum/shuttle_controller/ferry/New(home_id, away_id)
	src.dock_home_id = home_id
	src.dock_away_id = away_id
	if(ispath(src.dock_home_id))
		var/obj/shuttle_dock/casted = src.dock_home_id
		src.dock_home_id = initial(casted.dock_id)
		stack_trace(!isnull(src.dock_home_id))
	if(ispath(src.dock_away_id))
		var/obj/shuttle_dock/casted = src.dock_away_id
		src.dock_away_id = initial(casted.dock_id)
		stack_trace(!isnull(src.dock_away_id))
	..()

/datum/shuttle_controller/ferry/proc/is_at_home()
	return shuttle.docked.dock_id == dock_home_id

/datum/shuttle_controller/ferry/proc/is_at_away()
	return shuttle.docked.dock_id == dock_away_id

/datum/shuttle_controller/ferry/proc/is_at_known_location()
	return is_at_home() || is_at_away()

/datum/shuttle_controller/ferry/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()

/datum/shuttle_controller/ferry/ui_data(mob/user, datum/tgui/ui)
	. = ..()

/datum/shuttle_controller/ferry/ui_act(action, list/params, datum/tgui/ui)
	. = ..()


#warn impl all
