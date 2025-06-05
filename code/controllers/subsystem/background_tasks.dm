//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

SUBSYSTEM_DEF(background_tasks)
	name = "Background Intelligent Task Scheduler"

	wait = 2 SECONDS

	/// tasks running right now
	var/list/datum/background_task/running = list()
	/// task instance = next world.time to fire
	var/list/datum/background_task/yielding = list()

	/// keyed tasks
	var/alist/keyed_tasks = alist()

	/// finished task counter
	var/finished_count = 0

	/// the world.time start of the oldest task in running
	var/lrt_time = 0

/datum/controller/subsystem/background_tasks/Recover()
	var/list/datum/background_task/new_running = list()
	var/list/datum/background_task/new_yielding = list()
	var/alist/new_keyed_tasks = list()
	for(var/datum/background_task/task in running)
		new_running += task
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

/datum/controller/subsystem/background_tasks/proc/fire(resumed)
	var/list/datum/background_task/running = src.running
	var/list/datum/background_task/yielding = src.yielding
	#warn impl including lrt_time
	var/tasks_to_run = min(5, running)
	MC_SPLIT_TICK_INIT(tasks_to_run)
	for(var/running_idx in 1 to tasks_to_run)
		MC_SPLIT_TICK
		var/datum/background_task/to_run = running[running_idx]

	// check yielding for what needs to go to running
	var/yielding_idx
	for(yielding_idx in 1 to length(yielding))
		if(yielding[yielding_idx].next_run_time <= world.time)
			running += yielding[yielding_idx]
		else
			break
	yielding.Cut(1, yielding_idx)

/datum/controller/subsystem/background_tasks/proc/submit_task(datum/background_task/task)
	ASSERT(task.status == BACKGROUND_TASK_IDLE)
	task.status = BACKGROUND_TASK_QUEUED
	running += task

/**
 * @return ejected task, if one already existed
 */
/datum/controller/subsystem/background_tasks/proc/submit_keyed_task(datum/background_task/task, key)
	task.key = key
	if(keyed_tasks[key])
		var/datum/background_task/existing = keyed_tasks[key]
		. = existing
		#warn update lrt if needed
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
	/// status
	/// * do not manually set, subsystem sets this
	var/status = BACKGROUND_TASK_IDLE
	/// next world.time to run
	/// * do not manually set, subsystem sets this
	var/next_run_time
	/// our key, if any
	/// * do not manually set, subsystem sets this
	var/key

/**
 * Called to run.
 *
 * @params
 * * ticklimit - ticklimit to return on
 *
 * @return BACKGROUND_TASK_CONTINUE or BACKGROUND_TASK_YEILD
 */
/datum/background_task/proc/run()
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
