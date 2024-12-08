//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Component added to a mob by the mob themselves to invert themselves horizontally.
 */
/datum/component/mob_self_horizontal_inversion

/datum/component/mob_self_horizontal_inversion/Initialize()
	if(!ismob(parent))
		return COMPONENT_INCOMPATIBLE
	return ..()

/datum/component/mob_self_horizontal_inversion/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_MOVABLE_UPDATE_TRANSFORM, PROC_REF(on_update_transform))

/datum/component/mob_self_horizontal_inversion/UnregisterFromParent()
	. = ..()
	UnregisterSignal(parent, COMSIG_MOVABLE_UPDATE_TRANSFORM)

/datum/component/mob_self_horizontal_inversion/proc/on_update_transform(datum/source, matrix/applying)
	SIGNAL_HANDLER
	applying.Scale(-1, 1)

