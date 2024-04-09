//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/ai_holder
	/// ai movement instance to use normally
	var/movement_handler_type = /datum/ai_movement
	/// ai movement instance being used
	var/datum/ai_movement/movement_handler
	/// forced dir to move next
	var/movement_next = NONE

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
	#warn impl

/**
 * Request an immediate step in a certain direction
 */
/datum/ai_holder/proc/step_in_dir(dir)
	#warn impl

/**
 * Request an immediate dodge in a certain direction - this means that it's added to next movement
 * instead of overriding it.
 */
/datum/ai_holder/proc/dodge_in_dir(dir)
	#warn impl

#warn AAAA

