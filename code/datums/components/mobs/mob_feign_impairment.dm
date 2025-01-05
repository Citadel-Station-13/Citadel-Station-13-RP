//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

// todo: datumize impairments; the way this works right now is pretty stupid
//       it's because we're using different components since i was too
//       lazy to do a single tracking component

/**
 * Component added to a mob by the mob themselves to feign an impairment
 */
/datum/component/mob_feign_impairment
	var/power
	var/feign_impairment_type

/datum/component/mob_feign_impairment/Initialize(power)
	if(!ismob(parent))
		return COMPONENT_INCOMPATIBLE
	. = ..()
	if(. == COMPONENT_INCOMPATIBLE)
		return
	src.power = power

/datum/component/mob_feign_impairment/RegisterWithParent()
	. = ..()
	// todo: on update stat
	RegisterSignal(parent, COMSIG_MOB_ON_UPDATE_MOBILITY, PROC_REF(recheck_stat))
	var/mob/mob_parent = parent
	LAZYSET(mob_parent.impairments_feigned, feign_impairment_type, src)

/datum/component/mob_feign_impairment/UnregisterFromParent()
	. = ..()
	// todo: on update stat
	UnregisterSignal(parent, COMSIG_MOB_ON_UPDATE_MOBILITY)
	var/mob/mob_parent = parent
	LAZYREMOVE(mob_parent.impairments_feigned, feign_impairment_type)

/datum/component/mob_feign_impairment/proc/recheck_stat(mob/source)
	SIGNAL_HANDLER
	if(IS_CONSCIOUS(source))
		return
	qdel(src)

/datum/component/mob_feign_impairment/slurring
	// this must be set
	registered_type = /datum/component/mob_feign_impairment/slurring
	feign_impairment_type = /datum/feign_impairment/slurring

/datum/component/mob_feign_impairment/stutter
	// this must be set
	registered_type = /datum/component/mob_feign_impairment/stutter
	feign_impairment_type = /datum/feign_impairment/stutter

/datum/component/mob_feign_impairment/jitter
	// this must be set
	registered_type = /datum/component/mob_feign_impairment/jitter
	feign_impairment_type = /datum/feign_impairment/jitter

/datum/component/mob_feign_impairment/jitter/RegisterWithParent()
	. = ..()
	// shitcode but whatever
	var/mob/mob_parent = parent
	mob_parent.make_jittery(0)
