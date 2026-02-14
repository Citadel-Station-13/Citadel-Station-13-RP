//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * * Stateless
 */
/datum/airlock_cycle
	/// Phases to copy
	/// * Phases are stateless
	var/list/datum/airlock_phase/initial_phases = list()
	/// Blackboard to apply
	var/list/initial_blackboard = list()

/datum/airlock_cycle/proc/create_cycling(...)
	var/datum/airlock_cycling/cycling = new
	cycling.pending_phases = gather_phases(arglist(args.Copy()))
	cycling.blackboard = gather_blackboard(arglist(args.Copy()))
	return cycling

/datum/airlock_cycle/proc/gather_phases(...)
	return initial_phases.Copy()

/datum/airlock_cycle/proc/gather_blackboard(...)
	return initial_phases.Copy()
