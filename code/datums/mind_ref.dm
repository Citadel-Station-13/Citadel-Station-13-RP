//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * A layer of indirection to reference a mind.
 *
 * Useful for when you don't need a hard reference but say, a player cryos out.
 */
/datum/mind_ref
	var/datum/mind/loaded

/datum/mind_ref/New(datum/mind/from_mind)
	src.loaded = from_mind

/datum/mind_ref/Destroy(force)
	if(!force)
		STACK_TRACE("Tried to qdel a mind_ref; just toss its reference.")
		return QDEL_HINT_LETMELIVE
	if(loaded.mind_ref == src)
		loaded.mind_ref = null
	loaded = null
	return ..()

/datum/mind_ref/proc/resolve() as /datum/mind
	return loaded
