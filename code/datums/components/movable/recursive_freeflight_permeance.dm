//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/datum/component/recursive_freeflight_permeance
	dupe_mode = COMPONENT_DUPE_SELECTIVE
	registered_type = /datum/component/recursive_freeflight_permeance

/datum/component/recursive_freeflight_permeance/Initialize()
	. = ..()
	if(. == COMPONENT_INCOMPATIBLE)
		return
	if(!ismovable(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/recursive_freeflight_permeance/RegisterWithParent()
	construct()

/datum/component/recursive_freeflight_permeance/UnregisterFromParent()
	teardown()

/datum/component/recursive_freeflight_permeance/proc/construct(atom/root = parent)
	var/atom/movable/last = root
	while(ismovable(root))
		RegisterSignal(root, COMSIG_MOVABLE_MOVED, PROC_REF(update))
		last = root
		root = root.loc
	ADD_TRAIT(last, TRAIT_MOVABLE_FREEFLIGHT_PERMEANCE, TRAIT_SOURCE_LAZY_REF(src, "component"))

/datum/component/recursive_freeflight_permeance/proc/teardown(atom/root = parent)
	var/atom/movable/last = root
	while(ismovable(root))
		UnregisterSignal(root, COMSIG_MOVABLE_MOVED)
		last = root
		root = root.loc
	REMOVE_TRAIT(last, TRAIT_MOVABLE_FREEFLIGHT_PERMEANCE, TRAIT_SOURCE_LAZY_REF(src, "component"))

w/datum/component/recursive_freeflight_permeance/proc/update(atom/movable/source, atom/oldloc)
	var/atom/newloc = source.loc
	if(newloc == oldloc)
		return
	if(isturf(oldloc) && isturf(newloc) && (oldloc.z == newloc.z))
		// turf --> turf, don't do anything as we don't care about the turf
	else
		// turf --> somewhere else or somewhere else --> turf or somewhere else --> somewhere else, do full cycle
		teardown(oldloc)
		construct(newloc)
