//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * get overall magic channel efficiency multiplier
 */
/mob/proc/eldritch_get_magic_efficiency()
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)
	. = 1
	#warn impl

/**
 * get overall magic mitigation multiplier
 * * lower is better, 0.5 = take 0.5x effect
 */
/mob/proc/eldritch_get_magic_mitigation()
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)
	. = 1
	#warn impl

/**
 * returns a list of active eldritch_holder's
 */
/mob/proc/eldritch_get_holders() as /list
	return list()
	#warn impl

/**
 * returns dominant eldritch_holder, if any
 */
/mob/proc/eldritch_get_holder() as /datum/eldritch_holder
	return
	#warn impl

#warn how to do this
/mob/proc/eldritch_inflict_mindshock(req_power, req_duration)
