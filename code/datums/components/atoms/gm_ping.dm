//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Projects a context tag up to the world for admins to see.
 */
/datum/component/gm_ping
	registered_type = /datum/component/gm_ping
	dupe_mode = COMPONENT_DUPE_ALLOWED
	/// owning datum
	var/datum/gm_ping/owner
	#warn impl

/datum/component/gm_ping/Initialize(datum/gm_ping/owner)
	. = ..()
	if(. == COMPONENT_INCOMPATIBLE)
		return
	if(!isatom(.))
		return COMPONENT_INCOMPATIBLE
	src.owner = owner

/datum/component/gm_ping/RegisterWithParent()
	..()
	construct()
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(on_parent_moved))

/datum/component/gm_ping/UnregisterFromParent()
	..()
	UnregisterSignal(parent, COMSIG_MOVABLE_MOVED)
	teardown()

/datum/component/gm_ping/proc/on_parent_moved(atom/source, atom/old_loc)
	if(source.loc == old_loc)
		return
	teardown(old_loc)
	construct(source.loc)

/datum/component/gm_ping/proc/teardown(atom/root = parent:loc)
	#warn impl

/datum/component/gm_ping/proc/construct(atom/root = parent:loc)
	#warn impl
