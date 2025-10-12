//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Projects a context tag up to the world for admins to see.
 */
/datum/component/gm_ping
	/// owning datum
	var/datum/gm_ping/owner
	#warn impl

/datum/component/gm_ping/Initialize()
	. = ..()
	if(. == COMPONENT_INCOMPATIBLE)
		return
	if(!isatom(.))
		return COMPONENT_INCOMPATIBLE

/datum/component/gm_ping/RegisterWithParent()

/datum/component/gm_ping/UnregisterFromParent()

/datum/component/gm_ping/proc/on_parent_moved(atom/source, atom/old_loc)
	if(source.loc == oldloc)
		return
	teardown(oldloc)
	construct(source.loc)

/datum/component/gm_ping/proc/teardown(atom/root = parent:loc)

/datum/component/gm_ping/proc/construct(atom/root = parent:loc)
