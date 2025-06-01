//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * get overall magic channel efficiency multiplier
 */
/mob/proc/mansus_get_magic_efficiency()
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)
	. = 1
	#warn impl

/**
 * get overall magic mitigation multiplier
 * * lower is better, 0.5 = take 0.5x effect
 */
/mob/proc/mansus_get_magic_mitigation()
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)
	. = 1
	#warn impl

/**
 * returns a list of active mansus_holder's
 */
/mob/proc/mansus_get_holders() as /list
	return list()
	#warn impl

/**
 * returns dominant mansus_holder, if any
 */
/mob/proc/mansus_get_holder() as /datum/mansus_holder
	return
	#warn impl

#warn how to do this
/mob/proc/mansus_inflict_mindshock(req_power, req_duration)
