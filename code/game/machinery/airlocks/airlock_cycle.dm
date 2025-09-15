//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Airlock cycle state.
 *
 * * created for use during a discrete cycle operation
 */
/datum/airlock_cycle
	/// blackboard
	///
	/// * arbitrary k-v list for use by programs
	var/list/blackboard = list()
	/// phase;
	var/phase
	/// phase; human readable;
	var/phase_display
	/// phase started at
	var/phase_started
	/// tasks running in the cycle
	var/list/datum/airlock_task/running_tasks

/datum/airlock_cycle/proc/set_phase(phase, phase_display)
	src.phase = phase
	src.phase_display = phase_display || "Operating"
	src.phase_started = world.time

/datum/airlock_cycle/proc/update_phase(phase_display)
	src.phase_display = phase_display || "Operating"

/datum/airlock_cycle/proc/get_phase()
	return phase

/datum/airlock_cycle/proc/ui_cycle_data()
	var/list/assembled_tasks = list()
	for(var/datum/airlock_task/task as anything in running_tasks)
		assembled_tasks[++assembled_tasks.len] = task.ui_task_data()
	return list(
		"phaseRender" = phase_display,
		"phaseStarted" = phase_started,
		"tasks" = assembled_tasks,
	)

/datum/airlock_cycle/proc/add_task(datum/airlock_task/task)
	task.assign_cycle(src)

/datum/airlock_cycle/proc/remove_task(datum/airlock_task/task)
	task.unassign_cycle(src)
