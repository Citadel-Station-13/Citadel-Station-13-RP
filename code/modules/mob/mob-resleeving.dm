//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* helpers / API for the resleeving module *//

/**
 * Checks for API support for mirrors
 * * Any mob that returns TRUE for this should implement all `resleeving_x_mirror` procs.
 */
/mob/proc/resleeving_supports_mirrors()
	return FALSE

/**
 * Ensures the target has a mirror.
 */
/mob/proc/resleeving_create_mirror() as /obj/item/organ/internal/mirror
	return null

/**
 * Gets the target's mirror, if any
 */
/mob/proc/resleeving_get_mirror() as /obj/item/organ/internal/mirror
	return null

/**
 * transfers the target's mirror out, if any, returning it
 */
/mob/proc/resleeving_remove_mirror(atom/new_loc) as /obj/item/organ/internal/mirror
	return null

/**
 * inserts the given mirror
 */
/mob/proc/resleeving_insert_mirror(obj/item/organ/internal/mirror/mirror)
	return FALSE

/**
 * * Accepts a `/datum/mind` or `/datum/mind_ref`
 *
 * Sets `mind_resleeving_lock` to a specific mind ref.
 */
/mob/proc/resleeving_place_mind_lock(use_mind)
	var/datum/mind_ref/mind_ref
	if(istype(use_mind, /datum/mind_ref))
		mind_ref = use_mind
	else if(istype(use_mind, /datum/mind))
		var/datum/mind/casted_mind = use_mind
		mind_ref = casted_mind.get_mind_ref()
	else if(!use_mind)
		mind_ref = null
	else
		CRASH("invalid argument [use_mind] for mind.")
	mind_resleeving_lock = mind_ref
	return TRUE

/**
 * Checks if a mind should be accepted.
 */
/mob/proc/resleeving_check_mind_belongs(datum/mind/use_mind)
	if(!mind_resleeving_lock)
		return TRUE
	return use_mind.mind_ref == mind_resleeving_lock
