//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Component added to a mob by the mob themselves to invert themselves vertically.
 */
/datum/component/mob_self_vertical_inversion
	registered_type = /datum/component/mob_self_vertical_inversion

/datum/component/mob_self_vertical_inversion/Initialize()
	if(!ismob(parent))
		return COMPONENT_INCOMPATIBLE
	return ..()

/datum/component/mob_self_vertical_inversion/RegisterWithParent()
	. = ..()
	// todo: allow it if they're being moved by an external source; MOB_SLEFMOVE?
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(on_move))
	RegisterSignal(parent, COMSIG_MOVABLE_BASE_TRANSFORM, PROC_REF(alter_base_transform))
	var/mob/target = parent
	var/matrix/to_apply = target.transform
	to_apply.Scale(1, -1)
	target.set_transform(to_apply)

/datum/component/mob_self_vertical_inversion/UnregisterFromParent()
	. = ..()
	UnregisterSignal(parent, COMSIG_MOVABLE_BASE_TRANSFORM)
	UnregisterSignal(parent, COMSIG_MOVABLE_MOVED)
	var/mob/target = parent
	var/matrix/to_apply = target.transform
	to_apply.Scale(1, -1)
	target.set_transform(to_apply)

/datum/component/mob_self_vertical_inversion/proc/alter_base_transform(datum/source, matrix/applying)
	SIGNAL_HANDLER
	applying.Scale(1, -1)

/datum/component/mob_self_vertical_inversion/proc/on_move(datum/source)
	SIGNAL_HANDLER
	qdel(src)
