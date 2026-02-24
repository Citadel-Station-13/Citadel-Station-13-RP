//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * Airlock cycle state.
 *
 * * created for use during a discrete cycle operation
 *
 * TODO: Track stuckage time and cancel if airlock is stuck to save CPU.
 */
/datum/airlock_cycling
	/**
	 * UI desc for what we're actually doing
	 */
	var/desc = "Operating"

	/// current op id
	/// * set by airlock system
	var/op_id
	/// next operation cycle
	var/static/op_id_next = 0
	/// finished status
	/// * only set on finish
	var/finished_status
	/// finished reason description, if any
	/// * only set on finish
	var/finished_reason

	/// blackboard
	/// * arbitrary k-v list
	var/list/blackboard = list()

	/// the system we belong to
	var/datum/airlock_system/system
	/// tasks running in the cycle
	var/list/datum/airlock_task/running_tasks = list()

	/// current phase
	/// * This is immutable and stateless from our POV; we do not own references to phases.
	var/datum/airlock_phase/current_phase
	/// world.time currenet phase started at
	var/current_phase_started_at
	/// current phase progress estimate, if any
	var/current_phase_progress_estimate
	/// ordered pending phases
	/// * we are done if there's none left
	/// * This is immutable and stateless from our POV; we do not own references to phases.
	var/list/datum/airlock_phase/pending_phases = list()

/datum/airlock_cycling/New()
	op_id = ++op_id_next
	if(op_id_next >= SHORT_REAL_LIMIT)
		op_id_next = 0

/datum/airlock_cycling/Destroy()
	blackboard = null
	if(system?.cycling == src)
		system.stop_cycle(status = AIRLOCK_CYCLE_FIN_FAILED, why_str = "Unknown error.")
	system = null
	QDEL_LIST(running_tasks)
	current_phase = null
	pending_phases = null
	return ..()

/datum/airlock_cycling/proc/setup(datum/airlock_system/system)
	ASSERT(!src.system && !system.cycling)
	system.cycling = src
	src.system = system

/**
 * Called when the airlock processes to tick the cycle.
 */
/datum/airlock_cycling/proc/poll(dt)
	if(!system.controller.network)
		// It's unsound to run while network isn't up.
		return
	poll_or_next_phase(dt)
	if(!current_phase && !length(pending_phases))
		system.finish_cycle(op_id, "no pending tasks remain")

/datum/airlock_cycling/proc/poll_or_next_phase(dt, safety = 128)
	if(--safety <= 0)
		STACK_TRACE("ran out of safety, aborting")
		system.fail_cycle()
		return
	if(!current_phase)
		if(!length(pending_phases))
			return
		var/datum/airlock_phase/next_phase = pending_phases[1]
		pending_phases.Cut(1, 2)
		switch(next_phase.setup(system, src))
			if(AIRLOCK_PHASE_SETUP_FAIL)
				system.fail_cycle()
				return
			if(AIRLOCK_PHASE_SETUP_SKIP)
				return poll_or_next_phase(dt, safety - 1)
			if(AIRLOCK_PHASE_SETUP_SUCCESS)
				current_phase_started_at = world.time
				current_phase = next_phase
	// poll running tasks in this loop rather than outside
	for(var/datum/airlock_task/task as anything in running_tasks)
		task.poll(dt)
		if(task.completed)
			remove_task(task)
	switch(current_phase.tick(system, src))
		if(AIRLOCK_PHASE_TICK_ERROR)
			current_phase.cleanup(system, src)
			system.fail_cycle()
			return
		if(AIRLOCK_PHASE_TICK_CONTINUE)
			current_phase_progress_estimate = current_phase.estimate_progress_ratio(system, src)
		if(AIRLOCK_PHASE_TICK_FINISH)
			current_phase.finished(system, src)
			current_phase.cleanup(system, src)
			current_phase = null
			poll_or_next_phase(dt, safety - 1)

/datum/airlock_cycling/proc/enqueue_phase(datum/airlock_phase/phase)
	pending_phases += phase
	if(!current_phase)
		current_phase = phase

/datum/airlock_cycling/proc/add_task(datum/airlock_task/task)
	running_tasks += task
	task.assign_cycle(src)

/datum/airlock_cycling/proc/remove_task(datum/airlock_task/task)
	task.unassign_cycle(src)
	running_tasks -= task

/datum/airlock_cycling/proc/ui_cycle_data()
	var/list/assembled_tasks = list()
	for(var/datum/airlock_task/task as anything in running_tasks)
		assembled_tasks[++assembled_tasks.len] = task.ui_task_data()
	return list(
		"tasks" = assembled_tasks,
		"cyclingDesc" = desc,
		"phaseVerb" = current_phase?.display_verb,
	)
