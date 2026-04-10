//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

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
	/// * null to default to default transit time
	var/transit_time_home
	/// default transit time for an aligned transit towards away
	/// * null to default to default transit time
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

/datum/shuttle_controller/ferry/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()

/datum/shuttle_controller/ferry/ui_data(mob/user, datum/tgui/ui)
	. = ..()

/datum/shuttle_controller/ferry/ui_act(action, list/params, datum/tgui/ui)
	. = ..()

#warn impl all

/datum/shuttle_controller/ferry/default_transit_time(obj/shuttle_dock/towards_dock)
	if(towards_dock.dock_id == dock_home_id)
		if(!isnull(transit_time_home))
			return transit_time_home
	else if(towards_dock.dock_id == dock_away_id)
		if(!isnull(transit_time_away))
			return transit_time_away
	return ..()

/datum/shuttle_controller/ferry/on_transit_end(datum/shuttle_transit_cycle/cycle, status)
	. = ..()
	if(cycle.target_dock.dock_id == dock_home_id)
		on_end_transit_to_home(cycle, status)
	else if(cycle.target_dock.dock_id == dock_away_id)
		on_end_transit_to_away(cycle, status)

/**
 * only called if we're doing a default, non-manual docking with home dock!
 */
/datum/shuttle_controller/ferry/proc/on_end_transit_to_home(datum/shuttle_transit_cycle/cycle, status)
	SHOULD_NOT_SLEEP(TRUE)

/**
 * only called if we're doing a default, non-manual docking with away dock!
 */
/datum/shuttle_controller/ferry/proc/on_end_transit_to_away(datum/shuttle_transit_cycle/cycle, status)
	SHOULD_NOT_SLEEP(TRUE)

/datum/shuttle_controller/ferry/on_transit_begin(datum/shuttle_transit_cycle/cycle, redirected)
	. = ..()
	if(cycle.target_dock.dock_id == dock_home_id)
		on_begin_transit_to_home(cycle, redirected)
	else if(cycle.target_dock.dock_id == dock_away_id)
		on_begin_transit_to_away(cycle, redirected)

/**
 * only called if we're doing a default, non-manual docking with home dock!
 */
/datum/shuttle_controller/ferry/proc/on_begin_transit_to_home(datum/shuttle_transit_cycle/cycle, redirected)
	SHOULD_NOT_SLEEP(TRUE)

/**
 * only called if we're doing a default, non-manual docking with away dock!
 */
/datum/shuttle_controller/ferry/proc/on_begin_transit_to_away(datum/shuttle_transit_cycle/cycle, redirected)
	SHOULD_NOT_SLEEP(TRUE)

//*                      Easy Helpers / Simplified API                         *//
//*                                                                            *//
//* Usually, shuttles are controlled via shuttle controllers and bespoke APIs  *//
//* That sounds snowflake but is kind of the reality because without           *//
//* struct return types we can't really make good APIs for .. anything?        *//
//*                                                                            *//
//* Lots of legacy-style ferries, though, like escape/supply shuttle, can      *//
//* get away with a simplified API.                                            *//

/datum/shuttle_controller/ferry/proc/is_at_home()
	return shuttle.docked.dock_id == dock_home_id

/datum/shuttle_controller/ferry/proc/is_at_away()
	return shuttle.docked.dock_id == dock_away_id

/datum/shuttle_controller/ferry/proc/is_at_known_location()
	return ferry_is_at_home() || ferry_is_at_away()

/datum/shuttle_controller/ferry/proc/is_in_transit()
	return !shuttle.docked

/datum/shuttle_controller/ferry/proc/transit_towards_home(time, list/datum/callback/on_transit_callbacks)
	var/obj/shuttle_dock/dock = SSshuttle.resolve_dock(dock_home_id)
	if(!dock)
		CRASH("invalid home dock for ferry transit: " + dock_home_id)
	return transit_towards_dock(
		dock,
		time,
		on_transit_callbacks = on_transit_callbacks,
	)

/datum/shuttle_controller/ferry/proc/transit_towards_away(time, list/datum/callback/on_transit_callbacks)
	var/obj/shuttle_dock/dock = SSshuttle.resolve_dock(dock_away_id)
	if(!dock)
		CRASH("invalid away dock for ferry transit: " + dock_away_id)
	return transit_towards_dock(
		dock,
		time,
		on_transit_callbacks = on_transit_callbacks,
	)

/datum/shuttle_controller/ferry/proc/is_in_transit_towards_home()
	#warn impl

/datum/shuttle_controller/ferry/proc/is_in_transit_towards_away()
	#warn impl

/**
 * @return SHUTTLE_FERRY_DOCKING_STATE_*
 */
/datum/shuttle_controller/ferry/proc/get_docking_state()
	#warn impl

/**
 * @return TRUE if done, FALSE if failed for any reason (including 'done', 'not docking', 'rejected')
 */
/datum/shuttle_controller/ferry/proc/attempt_force_in_progress_docking()
	#warn impl

/**
 * @return TRUE if done, FALSE if failed for any reason (including 'done', 'not docking', 'rejected')
 */
/datum/shuttle_controller/ferry/proc/attempt_dangerously_force_in_progress_docking()
	#warn impl

/datum/shuttle_controller/ferry/proc/is_forcing_in_progress_docking()
	#warn impl

/datum/shuttle_controller/ferry/proc/is_dangerously_forcing_in_progress_docking()
	#warn impl

