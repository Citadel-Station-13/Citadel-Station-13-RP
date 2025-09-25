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
	/// operation display
	var/operation_display = "Operating"
	/// phase;
	var/phase
	/// phase; human readable;
	var/phase_display
	/// phase percent estimate, 0 to 100
	var/phase_progress
	/// phase started at
	var/phase_started
	/// tasks running in the cycle
	var/list/datum/airlock_task/running_tasks

	/// started side
	var/side_cycling_from
	/// ending side
	var/side_cycling_to

/datum/airlock_cycle/proc/set_phase(phase, phase_display)
	src.phase = phase
	src.phase_display = phase_display || "Working..."
	src.phase_started = world.time

/datum/airlock_cycle/proc/update_phase(phase_display)
	src.phase_display = phase_display || "Working..."

/datum/airlock_cycle/proc/get_phase()
	return phase

/datum/airlock_cycle/proc/ui_cycle_data()
	var/list/assembled_tasks = list()
	for(var/datum/airlock_task/task as anything in running_tasks)
		assembled_tasks[++assembled_tasks.len] = task.ui_task_data()
	return list(
		"operation" = operation_display,
		"phase" = phase_display,
		"startTime" = phase_started,
		"progress" = phase_progress,
		"tasks" = assembled_tasks,
	)

/datum/airlock_cycle/proc/add_task(datum/airlock_task/task)
	task.assign_cycle(src)

/datum/airlock_cycle/proc/remove_task(datum/airlock_task/task)
	task.unassign_cycle(src)

/datum/airlock_cycle/proc/complete()
	#warn impl
