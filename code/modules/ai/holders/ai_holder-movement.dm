//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/ai_holder
	/// movement subsystem registered?
	///
	/// warning: we can technically be moving while disabled
	/// make sure you handle this.
	var/movement_ticking = FALSE
	/// bucket position
	var/movement_bucket_position
	/// last datum in bucket
	var/datum/ai_holder/movement_bucket_prev
	/// next datum in bucket
	var/datum/ai_holder/movement_bucket_next
	/// movement cycle
	var/movement_cycle

/**
 * process movement
 *
 * @return amount of time to next move; 0 to stop moving
 */
/datum/ai_holder/proc/move(cycles)
	. = 0
	CRASH("unimplemented move proc called; what happened here?")

/**
 * register on movement subsystem to move
 */
/datum/ai_holder/proc/start_moving(initial_delay)
	return SSai_movement.register_moving(src)

/**
 * stop moving
 */
/datum/ai_holder/proc/stop_moving()
	return SSai_movement.unregister_moving(src)
