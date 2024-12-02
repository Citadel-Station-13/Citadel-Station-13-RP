
//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station developers.          *//

/datum/ai_holder

/**
 * as of right now, scheduled callbacks are allowed to leak.
 * AI_SCHEDULING_LIMIT is short enough that it's fine to do this.
 *
 * if it ever gets longer than 20-30 seconds, it's worthwhile to look into aborting if necessary.
 *
 * * This is a volatile system. If the subsystem resets, callbacks are lost.
 * * Do not use this for critical / synchronization behaviors. Use regular timers for that.
 *
 * @params
 * * time - how long to wait; this is server world.time
 * * proc_ref - reference to proc to call on ourselves
 * * arguments - a list of arguments to use with the call
 */
/datum/ai_holder/proc/schedule(time, proc_ref, list/arguments)
	SHOULD_NOT_SLEEP(TRUE)
	var/datum/ai_callback/ai_callback = new(proc_ref, arguments, src)
	SSai_scheduling.schedule_callback(ai_callback, time)
