//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/combo_tracker/melee
	/// if set, we automatically clear ourselves if nothing happens for this time
	var/continuation_timeout = 3 SECONDS
	var/tmp/continuation_timeout_active = FALSE
	var/tmp/continuation_last
	/// if exists, invoked with ()
	/// * this is not allowed to sleep.
	var/datum/callback/on_continuation_begin
	/// if exists, invoked with (list/stored_keys)
	/// * this is not allowed to sleep.
	var/datum/callback/on_continuation_timeout

/datum/combo_tracker/melee/New(continuation_timeout)
	if(!isnull(continuation_timeout))
		src.continuation_timeout = continuation_timeout

/datum/combo_tracker/melee/proc/keep_alive()
	continuation_last = world.time
	if(!continuation_timeout_active)
		on_timeout()
		on_continuation_begin?.invoke_no_sleep()

/datum/combo_tracker/melee/proc/on_timeout()
	continuation_timeout_active = FALSE
	var/remaining_time = continuation_last - (world.time - continuation_timeout)
	if(remaining_time < 0)
		var/list/stored_keys = stored
		reset()
		on_continuation_timeout?.invoke_no_sleep(stored_keys)
		return
	addtimer(CALLBACK(src, PROC_REF(on_timeout)), remaining_time)
	continuation_timeout_active = TRUE

/datum/combo_tracker/melee/evaluate_inbound_via_tail_match(inbound, datum/combo_set/combo_set)
	keep_alive()
	return ..()

/datum/combo_tracker/melee/evaluate_inbound_via_stateful_exclusive_match(inbound, datum/combo_set/combo_set)
	keep_alive()
	return ..()

/datum/combo_tracker/melee/intent_based
