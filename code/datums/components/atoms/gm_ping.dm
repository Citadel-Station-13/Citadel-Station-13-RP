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

/datum/component/gm_ping/Initialize(datum/gm_ping/owner)
	. = ..()
	if(. == COMPONENT_INCOMPATIBLE)
		return
	src.owner = owner

/datum/component/gm_ping/Destroy()
	owner.context_component = null
	return ..()

/datum/component/gm_ping/RegisterWithParent()
	..()
	construct()
	if(ismovable(parent))
		RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(update))
	RegisterSignal(parent, COMSIG_PARENT_PREQDELETED, PROC_REF(on_parent_preqdel))

/datum/component/gm_ping/UnregisterFromParent()
	..()
	if(ismovable(parent))
		UnregisterSignal(parent, COMSIG_MOVABLE_MOVED)
	teardown()

/datum/component/gm_ping/proc/update(atom/source, atom/old_loc)
	if(source.loc == old_loc)
		return
	// don't need to re-update if we're going from turf to turf; we register on movable only,
	// unless the component itself is on a turf.
	if(isturf(source.loc) && isturf(old_loc))
		return
	teardown(old_loc)
	construct(source.loc)

/datum/component/gm_ping/proc/on_parent_preqdel(atom/source)
	SIGNAL_HANDLER
	owner.pull_ui_panel_context_data()

/datum/component/gm_ping/proc/teardown(atom/root = parent:loc)
	var/atom/last = parent
	while(ismovable(root))
		UnregisterSignal(root, COMSIG_MOVABLE_MOVED, PROC_REF(update))
		last = root
		root = root.loc
	var/datum/component/gm_ping_topmost/holder = last.LoadComponent(/datum/component/gm_ping_topmost)
	holder.remove_ping(src)

/datum/component/gm_ping/proc/construct(atom/root = parent:loc)
	var/atom/last = parent
	while(ismovable(root))
		RegisterSignal(root, COMSIG_MOVABLE_MOVED, PROC_REF(update))
		last = root
		root = root.loc
	var/datum/component/gm_ping_topmost/holder = last.LoadComponent(/datum/component/gm_ping_topmost)
	holder.add_ping(src)
