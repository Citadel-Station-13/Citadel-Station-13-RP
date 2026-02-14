//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * * Stateless
 */
/datum/airlock_phase
	/// should be lowercase
	var/display_verb =  "???"

/**
 * * can return outside of 0 to 1, which would result in something like `2` being `"200%"`.
 * @return null if not supported or number, ideally 0 to 1
 */
/datum/airlock_phase/proc/estimate_progress_ratio(datum/airlock_system/system, datum/airlock_cycling/cycling)
	return null

/**
 * Called when entering this phase.
 * @return AIRLOCK_PHASE_SETUP_* enum
 */
/datum/airlock_phase/proc/setup(datum/airlock_system/system, datum/airlock_cycling/cycling)
	return AIRLOCK_PHASE_SETUP_SUCCESS

/**
 * * 'dt' is in seconds
 * @return TRUE if finished, FALSE otherwise
 */
/datum/airlock_phase/proc/tick(datum/airlock_system/system, datum/airlock_cycling/cycling, dt)
	// by default, we just care that all tasks are done
	if(!length(cycling.running_tasks))
		return AIRLOCK_PHASE_TICK_FINISH
	return AIRLOCK_PHASE_TICK_CONTINUE

/**
 * Called when exiting this phase.
 * * Only called when successful.
 */
/datum/airlock_phase/proc/finished(datum/airlock_system/system, datum/airlock_cycling/cycling)
	return

/**
 * Called when exiting this phase.
 * * Only called when successful, for now.
 */
/datum/airlock_phase/proc/cleanup(datum/airlock_system/system, datum/airlock_cycling/cycling)
	return

/datum/airlock_phase/merge_blackboard
	var/list/merge_system_blackboard
	var/list/merge_cycling_blackboard

/datum/airlock_phase/merge_blackboard/setup(datum/airlock_system/system, datum/airlock_cycling/cycling)
	if(merge_system_blackboard)
		system.blackboard ||= merge_system_blackboard
	if(merge_cycling_blackboard)
		cycling.blackboard ||= merge_cycling_blackboard
	return AIRLOCK_PHASE_SETUP_SKIP

/**
 * Depressurize airlock to handler's waste buffer, or an exterior vent.
 */
/datum/airlock_phase/depressurize
	display_verb = "depressurizing"
	/// push air out of vents instead of through the handler's waste side
	var/vent_to_outside = FALSE
	/// stop at pressure
	var/depressurize_to_kpa = 0

/datum/airlock_phase/depressurize/setup(datum/airlock_system/system, datum/airlock_cycling/cycling)
	if(vent_to_outside)
		cycling.add_task(new /datum/airlock_task/gasnet/pump/cycler_to_vent)
	else
		cycling.add_task(new /datum/airlock_task/gasnet/pump/cycler_to_handler_waste)
	return AIRLOCK_PHASE_SETUP_SUCCESS

/datum/airlock_phase/depressurize/vent_to_outside
	vent_to_outside = TRUE

/datum/airlock_phase/depressurize/drain_to_handler
	vent_to_outside = FALSE

/**
 * Repressurize airlock from handler's supply
 */
/datum/airlock_phase/repressurize
	display_verb = "repressurizing"
	/// stop at pressure
	var/pressurize_to_kpa = ONE_ATMOSPHERE
	/// pull from exterior vent if possible
	var/pull_from_outside_if_possible = FALSE
	/// must pull from outside
	/// * requires [pull_from_outside_if_possible]
	var/pull_from_outside_required = FALSE

/datum/airlock_phase/repressurize/setup(datum/airlock_system/system, datum/airlock_cycling/cycling)
	if(pull_from_outside_required)
		cycling.add_task(new /datum/airlock_task/gasnet/pump/handler_supply_to_cycler)
	else if(pull_from_outside_if_possible)
		cycling.add_task(new /datum/airlock_task/gasnet/pump/vent_or_handler_supply_to_cycler)
	else
		cycling.add_task(new /datum/airlock_task/gasnet/pump/vent_to_cycler)
	return AIRLOCK_PHASE_SETUP_SUCCESS

/datum/airlock_phase/repressurize/allow_external_air
	pull_from_outside_if_possible = TRUE

/datum/airlock_phase/repressurize/require_external_air
	pull_from_outside_if_possible = TRUE
	pull_from_outside_required = TRUE

/datum/airlock_phase/repressurize/from_handler_supply

/datum/airlock_phase/doors
	display_verb = "operating doors"

/datum/airlock_phase/doors/assert_state
	var/interior_open
	var/interior_locked
	var/exterior_open
	var/exterior_locked

/datum/airlock_phase/doors/assert_state/New(interior_open, interior_locked, exterior_open, exterior_locked)
	src.interior_open = interior_open
	src.interior_locked = interior_locked
	src.exterior_open = exterior_open
	src.exterior_locked = exterior_locked

/datum/airlock_phase/doors/assert_state/setup(datum/airlock_system/system, datum/airlock_cycling/cycling)
	#warn impl
	return AIRLOCK_PHASE_SETUP_SUCCESS

/datum/airlock_phase/doors/seal
	display_verb = "sealing"

/datum/airlock_phase/doors/seal/setup(datum/airlock_system/system, datum/airlock_cycling/cycling)
	#warn impl
	return AIRLOCK_PHASE_SETUP_SUCCESS

/datum/airlock_phase/doors/seal/finished(datum/airlock_system/system, datum/airlock_cycling/cycling)
#warn set X_DOOR_LOCKED_STATE blackboard on these phases

/datum/airlock_phase/doors/lock_open
	display_verb = "opening doors"
	var/interior = FALSE
	var/exterior = FALSE

/datum/airlock_phase/doors/lock_open/interior
	interior = TRUE

/datum/airlock_phase/doors/lock_open/exterior
	exterior = TRUE

/datum/airlock_phase/doors/lock_open/everything
	interior = TRUE
	exterior = TRUE

/datum/airlock_phase/doors/lock_open/setup(datum/airlock_system/system, datum/airlock_cycling/cycling)
	#warn impl
	return AIRLOCK_PHASE_SETUP_SUCCESS

/datum/airlock_phase/doors/lock_open/finished(datum/airlock_system/system, datum/airlock_cycling/cycling)
#warn set X_DOOR_LOCKED_STATE blackboard on these phases

/datum/airlock_phase/doors/lock_closed
	display_verb = "closing doors"
	var/interior = FALSE
	var/exterior = FALSE

/datum/airlock_phase/doors/lock_closed/interior
	interior = TRUE

/datum/airlock_phase/doors/lock_closed/exterior
	exterior = TRUE

/datum/airlock_phase/doors/lock_closed/everything
	interior = TRUE
	exterior = TRUE

/datum/airlock_phase/doors/lock_closed/setup(datum/airlock_system/system, datum/airlock_cycling/cycling)
	#warn impl
	return AIRLOCK_PHASE_SETUP_SUCCESS

/datum/airlock_phase/doors/lock_closed/finished(datum/airlock_system/system, datum/airlock_cycling/cycling)
#warn set X_DOOR_LOCKED_STATE blackboard on these phases
