//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

SUBSYSTEM_DEF(background_tasks)
	name = "Background Intelligent Task Scheduler"

	wait = 2 SECONDS
	subsystem_flags = SS_BACKGROUND
	priority = FIRE_PRIORITY_BACKGROUND_TASKS

	/// tasks running right now
	/// * from oldest to newest in next fire timing; basically, FIFO-ish
	var/list/datum/background_task/running = list()
	/// task instance = next world.time to fire
	var/list/datum/background_task/yielding = list()

	/// keyed tasks
	var/alist/keyed_tasks = alist()

	/// finished task counter
	var/finished_count = 0

	/// the world.time start of the oldest task in running
	/// * basically, the longest a task is currently waiting to run
	var/lrt_time = 0

/datum/controller/subsystem/background_tasks/Initialize()
	initialize_hardcoded_background_task(/datum/background_task/eldritch_reality_task)
	return ..()

/datum/controller/subsystem/background_tasks/proc/initialize_hardcoded_background_task(path)
	ASSERT(ispath(path, /datum/background_task))
	if(locate(path) in running)
		return
	if(locate(path) in yielding)
		return
	submit_task(new path)

/datum/controller/subsystem/background_tasks/Recover()
	var/list/datum/background_task/new_running = list()
	var/list/datum/background_task/new_yielding = list()
	var/alist/new_keyed_tasks = list()
	for(var/datum/background_task/task in running)
		BINARY_INSERT(task, new_running, /datum/background_task, task, next_run_time, COMPARE_KEY)
		if(task.key)
			new_keyed_tasks[task.key] = task
	for(var/datum/background_task/task in yielding)
		new_yielding += task
	tim_sort(new_yielding, /proc/cmp_numeric_asc, TRUE)

	running = new_running
	yielding = new_yielding
	keyed_tasks = new_keyed_tasks

	return TRUE

/datum/controller/subsystem/background_tasks/stat_entry()
	if(can_fire && !(SS_NO_FIRE & subsystem_flags))
		. = "[length(running)] RUN | [length(yielding)] YLD | [finished_count] FIN | [max(0, CEILING(world.time - lrt_time, 1) * 0.1)]s LRT"
	else
		. = ..()

// todo: this would benefit from a hibernation system; background tasks are not always running
/datum/controller/subsystem/background_tasks/proc/fire(resumed)
	var/list/datum/background_task/running = src.running
	var/list/datum/background_task/yielding = src.yielding
	var/tasks_to_run = min(5, running)
	MC_SPLIT_TICK_INIT(tasks_to_run + 1)

	var/list/datum/background_task/now_running = list()
	for(var/running_idx in 1 to tasks_to_run)
		now_running += running[running_idx]
	for(var/datum/background_task/to_run as anything in now_running)
		MC_SPLIT_TICK
		to_run.status = BACKGROUND_TASK_RUNNING
		var/result = to_run.run(Master.current_ticklimit)
		var/eject = TRUE
		switch(result)
			if(BACKGROUND_TASK_RETVAL_CONTINUE)
				if(to_run.status != BACKGROUND_TASK_RUNNING)
					stack_trace("ejecting misbehaving task [to_run] ([to_run.type]) - returned continue but no longer running status")
			if(BACKGROUND_TASK_RETVAL_YIELD)
				switch(to_run.status)
					if(BACKGROUND_TASK_FINISHED)
						finished_count += 1
					if(BACKGROUND_TASK_YIELDING)
						BINARY_INSERT(to_run, yielding, /datum/background_task, to_run, next_run_time, COMPARE_KEY)
			else
				stack_trace("ejecting misbehaving task [to_run] ([to_run.type]) - returned invalid retval [result]")
		if(eject)
			running -= to_run

	// give us time to do bookkeeping ; never take up the whole tick because we are pretty
	// aggressive about rescheduling.
	MC_SPLIT_TICK
	// check yielding for what needs to go to running
	var/yielding_idx
	for(yielding_idx in 1 to length(yielding))
		if(yielding[yielding_idx].next_run_time <= world.time)
			var/datum/background_task/inserting = yielding[yielding_idx]
			var/datum/background_task/last = running[length(running)]
			if(last.next_run_time < inserting.next_run_time)
				running += inserting
				inserting.status = BACKGROUND_TASK_RUNNING
			else
				BINARY_INSERT(inserting, running, /datum/background_task, inserting, next_run_time, COMPARE_KEY)
		else
			break
	yielding.Cut(1, yielding_idx)

	lrt_time = length(running) ? running[1].next_run_time : world.time

	if(length(running))
		pause()

/datum/controller/subsystem/background_tasks/proc/submit_task(datum/background_task/task)
	ASSERT(task.status == BACKGROUND_TASK_IDLE)
	task.status = BACKGROUND_TASK_QUEUED
	task.next_run_time = world.time
	BINARY_INSERT(task, running, /datum/background_task, task, next_run_time, COMPARE_KEY)

/**
 * @return ejected task, if one already existed
 */
/datum/controller/subsystem/background_tasks/proc/submit_keyed_task(datum/background_task/task, key)
	task.key = key
	if(keyed_tasks[key])
		var/datum/background_task/existing = keyed_tasks[key]
		. = existing
		switch(existing.status)
			if(BACKGROUND_TASK_QUEUED)
				running -= existing
			if(BACKGROUND_TASK_YIELDING)
				yielding -= existing
	keyed_tasks[key] = task
	submit_task(task)

/**
 * Advanced background task scheduling system.
 * * You must yield() or finish() on run() if you have nothing else to do. Otherwise,
 *   you will burn CPU unnecessarily idle-looping forever!
 */
/datum/background_task
	/// name; required
	var/name = "???"
	/// status
	/// * do not manually set, subsystem sets this
	var/status = BACKGROUND_TASK_IDLE
	/// next world.time to run
	/// * do not manually set, subsystem sets this
	var/next_run_time
	/// our key, if any
	/// * do not manually set, subsystem sets this
	var/key
	// todo: var/datum/callback/on_finish
	// todo: var/datum/callback/on_scheduled
	// todo: var/datum/callback/on_unscheduled

/**
 * Called to run.
 *
 * @params
 * * ticklimit - ticklimit to return on
 *
 * @return BACKGROUND_TASK_CONTINUE or BACKGROUND_TASK_YEILD
 */
/datum/background_task/proc/run(ticklimit)
	CRASH("base run() on /datum/background_task ran")

/**
 * Yield for duration.
 */
/datum/background_task/proc/yield(duration)
	ASSERT(status == BACKGROUND_TASK_RUNNING)
	next_run_time = world.time + duration
	status = BACKGROUND_TASK_YIELDING

/**
 * Ejects from the background task scheduler. Call on finish.
 */
/datum/background_task/proc/finish()
	ASSERT(status == BACKGROUND_TASK_RUNNING)
	status = BACKGROUND_TASK_FINISHED

// todo: on_scheduled
// todo: on_unscheduled
