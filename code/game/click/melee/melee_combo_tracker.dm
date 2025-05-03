//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/combo_tracker/melee
	/// if set, we automatically clear ourselves if nothing happens for this time; 0 to disable.
	var/continuation_timeout = 3 SECONDS
	/// currently in continuation mode
	var/tmp/continuation_active = FALSE
	/// last world.time an action occurred
	var/tmp/continuation_last
	/// terminate continuation on a 'wrong combo'
	/// * only works with 'stateful exclusive chain' right now.
	var/continuation_terminate_on_fail = TRUE
	/// if exists, invoked with ()
	/// * this is not allowed to sleep.
	var/datum/callback/on_continuation_begin
	/// if exists, invoked with (list/stored_keys, timed_out)
	/// * this is not allowed to sleep.
	var/datum/callback/on_continuation_end

/datum/combo_tracker/melee/New(continuation_timeout)
	if(!isnull(continuation_timeout))
		src.continuation_timeout = continuation_timeout

/datum/combo_tracker/melee/proc/begin_continuation()
	if(!continuation_timeout)
		return
	if(continuation_active)
		refresh_continuation()
		return
	continuation_active = TRUE
	on_continuation_begin?.invoke_no_sleep()
	addtimer(CALLBACK(src, PROC_REF(check_continuation)), continuation_timeout)

/datum/combo_tracker/melee/proc/end_continuation(timed_out)
	var/list/old_stored = stored_keys
	reset()
	on_continuation_end?.invoke_no_sleep(old_stored, timed_out)

/datum/combo_tracker/melee/proc/refresh_continuation()
	continuation_last = world.time

/datum/combo_tracker/melee/proc/check_continuation()
	if(!continuation_timeout)
		return
	var/remaining_time = continuation_last - (world.time - continuation_timeout)
	if(remaining_time <= 0)
		end_continuation()
		return
	addtimer(CALLBACK(src, PROC_REF(check_continuation)), remaining_time)

/datum/combo_tracker/melee/process_inbound(inbound, datum/combo_set/combo_set, tail_match)
	begin_continuation()
	. = ..()
	if(continuation_terminate_on_fail && combo_position == null)
		end_continuation(FALSE)

/datum/combo_tracker/melee/intent_based
