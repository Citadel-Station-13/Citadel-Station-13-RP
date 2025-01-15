//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Component added to a mob by the mob themselves to invert themselves horizontally.
 */
/datum/component/mob_self_horizontal_inversion
	registered_type = /datum/component/mob_self_horizontal_inversion

/datum/component/mob_self_horizontal_inversion/Initialize()
	if(!ismob(parent))
		return COMPONENT_INCOMPATIBLE
	return ..()

/datum/component/mob_self_horizontal_inversion/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_MOVABLE_BASE_TRANSFORM, PROC_REF(alter_base_transform))
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(on_move))
	var/mob/target = parent
	var/matrix/to_apply = target.transform
	to_apply.Scale(-1, 1)
	target.set_transform(to_apply)

/datum/component/mob_self_horizontal_inversion/UnregisterFromParent()
	. = ..()
	UnregisterSignal(parent, COMSIG_MOVABLE_BASE_TRANSFORM)
	UnregisterSignal(parent, COMSIG_MOVABLE_MOVED)
	var/mob/target = parent
	var/matrix/to_apply = target.transform
	to_apply.Scale(-1, 1)
	target.set_transform(to_apply)

/datum/component/mob_self_horizontal_inversion/proc/alter_base_transform(datum/source, matrix/applying)
	SIGNAL_HANDLER
	applying.Scale(-1, 1)

/datum/component/mob_self_horizontal_inversion/proc/on_move(datum/source)
	SIGNAL_HANDLER
	qdel(src)
