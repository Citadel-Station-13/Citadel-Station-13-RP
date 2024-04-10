//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/ai_holder
	/// movement subsystem registered? null, or number for delay.
	var/movement_ticking
	/// bucket position
	var/movement_bucket_position
	/// last datum in bucket
	var/datum/ai_holder/movement_bucket_prev
	/// next datum in bucket
	var/datum/ai_holder/movement_bucket_next

/**
 * process movement
 *
 * @return amount of time to next move; 0 to stop moving
 */
/datum/ai_holder/proc/move(times_fired)
	. = 0
	CRASH("unimplemented move proc called; what happened here?")

/**
 * register on movement subsystem to move
 */
/datum/ai_holder/proc/start_moving(initial_delay)
	#warn impl

/**
 * stop moving
 */
/datum/ai_holder/proc/stop_moving()
	#warn impl
