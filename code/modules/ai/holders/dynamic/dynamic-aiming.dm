//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * Generic 'aiming' system: Used to calculate raycasted angles.
 *
 * How it works:
 * * 'true' aim: We try to hit the mob.
 * * 'false' aim: We *do not try to hit the mob*, but are still firing at it.
 * * 'miss' aim: We *try to miss the mob*.
 *
 * When we attempt to do automatic target aiming, we will choose one of the three.
 *
 * * Generally, this is only done once per burst if firing a burst weapon, as this is somewhat expensive.
 * * Aiming can and will curve bullets around walls. This is not necessarily what you want.
 */

/datum/ai_holder/dynamic
	/// our base chance to 'intentionally hit'.
	/// this is the chances that we aim 'true'.
	var/aiming_true_probability = 0.8
	/// our base chance multiplier to 'intentionally hit'.
	/// separate so balancing is easier.
	var/aiming_true_probability_multiplier = 1

/**
 * @return angle to fire in
 */
/datum/ai_holder/dynamic/proc/aiming_default_process(atom/movable/target)
	#warn impl
	var/result = aiming_default_consider(target)
	switch(result)
		if(AI_DYNAMIC_AIM_TRUE)
			return aiming_get_true(target)
		if(AI_DYNAMIC_AIM_FALSE)
			return aiming_get_false(target)
		if(AI_DYNAMIC_AIM_MISS)
			return aiming_get_miss(target)

/**
 * @return AI_DYNAMIC_AIM_*
 */
/datum/ai_holder/dynamic/proc/aiming_default_consider(atom/movable/target)
	#warn impl

/**
 * @return angle
 */
/datum/ai_holder/dynamic/proc/aiming_get_true(atom/movable/target)
	#warn impl

/**
 * @return angle
 */
/datum/ai_holder/dynamic/proc/aiming_get_false(atom/movable/target)
	#warn impl

/**
 * @return angle
 */
/datum/ai_holder/dynamic/proc/aiming_get_miss(atom/movable/target)
	#warn impl
