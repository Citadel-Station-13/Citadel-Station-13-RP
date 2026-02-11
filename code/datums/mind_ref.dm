//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

GLOBAL_LIST_EMPTY(mind_ref_weakref_by_id)

/**
 * A layer of indirection to reference a mind.
 *
 * Useful for when you don't need a hard reference but say, a player cryos out.
 */
/datum/mind_ref
	var/id
	var/datum/mind/loaded

	var/static/uid_next

/datum/mind_ref/New(datum/mind/from_mind)
	if(uid_next >= SHORT_REAL_LIMIT)
		uid_next = (-SHORT_REAL_LIMIT) + 1
	src.id = ++uid_next
	GLOB.mind_ref_weakref_by_id[src.id] = WEAKREF(src)

	src.loaded = from_mind

/datum/mind_ref/Destroy()
	GLOB.mind_ref_weakref_by_id -= src.id
	return ..()

/datum/mind_ref/Destroy(force)
	if(!force)
		STACK_TRACE("Tried to qdel a mind_ref; just toss its reference.")
		return QDEL_HINT_LETMELIVE
	if(loaded.mind_ref = src)
		loaded.mind_ref = null
	loaded = null
	return ..()
