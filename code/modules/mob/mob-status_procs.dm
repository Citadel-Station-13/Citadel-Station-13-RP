//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

//* Impairments *//

// hey! listen
// if you're thinking about find-replacing checks for the var with this
// well fucking don't
//
// the reason this is separate from main vars for these things
// is because people keep abusing vars to implement features that have a
// ton of unintended side effects
//
// these should only be used for the actual effects; it is **not**
// allowed to use for any other effects like xenochimera feral,
// traumatic shock, etc

// todo: /datum/mob_impairment ?

/mob/proc/get_effective_impairment_power_slurring()
	. = slurring
	var/datum/component/mob_feign_impairment/slurring/feigned = GetComponent(/datum/component/mob_feign_impairment/slurring)
	if(feigned)
		. = max(., feigned.power)

/mob/proc/get_effective_impairment_power_jitter()
	. = jitteriness
	var/datum/component/mob_feign_impairment/jitter/feigned = GetComponent(/datum/component/mob_feign_impairment/jitter)
	if(feigned)
		. = max(., feigned.power)

/mob/proc/get_effective_impairment_power_stutter()
	. = stuttering
	var/datum/component/mob_feign_impairment/stutter/feigned = GetComponent(/datum/component/mob_feign_impairment/stutter)
	if(feigned)
		. = max(., feigned.power)
