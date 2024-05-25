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

	/// default transit time for an aligned transit towards home
	/// null to default to default
	var/transit_time_home
	/// default transit time for an aligned transit towards away
	/// null to default to default
	var/transit_time_away

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

/datum/shuttle_controller/feryy/default_transit_time_for_dock(obj/shuttle_dock/dock)
	if(dock.dock_id == dock_home_id)
		if(!isnull(transit_time_home))
			return transit_time_home
	else if(dock.dock_id == dock_away_id)
		if(!isnull(transit_time_away))
			return transit_time_away
	return ..()

/datum/shuttle_controller/ferry/on_transit_success(obj/shuttle_dock/dock)
	. = ..()
	if(dock.dock_id == dock_home_id)
		on_transit_to_home()
	else if(dock.dock_id == dock_away_id)
		on_transit_to_away()

/**
 * only called if we're doing a default, non-manual docking with home dock!
 */
/datum/shuttle_controller/ferry/proc/on_successful_transit_to_home()
	return

/**
 * only called if we're doing a default, non-manual docking with away dock!
 */
/datum/shuttle_controller/ferry/proc/on_successful_transit_to_away()
	return

/datum/shuttle_controller/ferry/on_transit_abort(obj/shuttle_dock/dock, redirected)
	. = ..()
	if(dock.dock_id == dock_home_id)
		on_abort_transit_to_home()
	else if(dock.dock_id == dock_away_id)
		on_abort_transit_to_away()

/**
 * only called if we're doing a default, non-manual docking with home dock!
 */
/datum/shuttle_controller/ferry/proc/on_abort_transit_to_home()
	return

/**
 * only called if we're doing a default, non-manual docking with away dock!
 */
/datum/shuttle_controller/ferry/proc/on_abort_transit_to_away()
	return

/datum/shuttle_controller/ferry/on_transit_begin(obj/shuttle_dock/dock, redirected)
	. = ..()
	if(dock.dock_id == dock_home_id)
		on_begin_transit_to_home()
	else if(dock.dock_id == dock_away_id)
		on_begin_transit_to_away()

/**
 * only called if we're doing a default, non-manual docking with home dock!
 */
/datum/shuttle_controller/ferry/proc/on_begin_transit_to_home()
	return

/**
 * only called if we're doing a default, non-manual docking with away dock!
 */
/datum/shuttle_controller/ferry/proc/on_begin_transit_to_away()
	return
