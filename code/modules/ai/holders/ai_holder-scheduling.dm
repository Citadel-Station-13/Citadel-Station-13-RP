//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

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
 * * ...rest - what to pass in
 */
/datum/ai_holder/proc/schedule(time, proc_ref, ...)
	var/datum/ai_callback = new(proc_ref, args.Copy(3), src)
	SSai_holders.schedule_callback(ai_callback)

/**
 * ! Hi. This datum has special GC behavior. Thus we only make it for one purpose that I selected
 * ! where it will not cause a memory leak. If you use it for other purposes, you will cause
 * ! problems, and we certainly wouldn't want to have that, right?
 *
 * * Not to mention this datum is specifically secured in a specific way to not be able to be
 *   hijacked by admin proccalls; infact it's more secure than normal /datum/callback.
 * * So, do not fuck with it.
 */
/datum/ai_callback
	var/proc_ref
	var/list/arguments
	var/datum/ai_holder/parent
	/// next
	var/datum/ai_callback/next

/datum/ai_callback/New(proc_ref, list/arguments, datum/ai_holder/parent)
	src.proc_ref = proc_ref
	src.arguments = arguments
	src.parent = parent

/datum/ai_callback/Destroy()
	arguments = parent = next = null
	// if this leaks, L; don't fuck it up!
	return QDEL_HINT_IWILLGC

/datum/ai_callback/vv_edit_var(var_name, var_value, mass_edit, raw_edit)
	return FALSE // no thanks bucko

/datum/ai_callback/CanProcCall(procname)
	return FALSE // no thanks bucko
