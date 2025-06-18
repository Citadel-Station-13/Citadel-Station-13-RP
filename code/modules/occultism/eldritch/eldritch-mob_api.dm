//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * get overall magic channel efficiency multiplier
 */
/mob/proc/eldritch_get_magic_efficiency()
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)
	. = 1
	// TODO: /datum/component/eldritch_focus for worn & held items

/**
 * returns a list of active eldritch_holder's
 */
/mob/proc/eldritch_get_holders() as /list
	. = list()
	if(mind?.r_holder_eldritch)
		. += mind.r_holder_eldritch

/**
 * returns dominant eldritch_holder, if any
 */
/mob/proc/eldritch_get_holder() as /datum/eldritch_holder
	return mind?.r_holder_eldritch

#warn how to do this
/mob/proc/eldritch_inflict_mindshock(req_power, req_duration)
