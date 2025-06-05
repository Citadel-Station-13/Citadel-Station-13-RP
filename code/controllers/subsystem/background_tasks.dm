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

/datum/controller/subsystem/background_tasks/proc/fire(resumed)
	#warn impl

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
