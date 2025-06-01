//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

SUBSYSTEM_DEF(background_tasks)
	name = "Background Intelligent Task Scheduler"

	wait = 2 SECONDS

/datum/controller/subsystem/background_tasks/proc/fire(resumed)

/datum/controller/subsystem/background_tasks/proc/submit_task(datum/background_task/task)

/**
 * @return ejected task, if one already existed
 */
/datum/controller/subsystem/background_tasks/proc/submit_keyed_task(datum/background_task/task, key)

#warn impl

/**
 * Advanced background task scheduling system.
 * * You must yield() or finish() on run() if you have nothing else to do. Otherwise,
 *   you will burn CPU unnecessarily idle-looping forever!
 */
/datum/background_task
	/// status
	var/status = BACKGROUND_TASK_IDLE

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

/**
 * Ejects from the background task scheduler. Call on finish.
 */
/datum/background_task/proc/finish()

