//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/component/shadekin_phasing_handler

/datum/component/shadekin_phasing_handler/Initialize()
	if(!ismovable(parent))
		return COMPONENT_INCOMPATIBLE
	. = ..()
	if(. == COMPONENT_INCOMPATIBLE)
		return


/datum/component/shadekin_phasing_handler/RegisterWithParent()
	..()
	START_PROCESSING(SSprocess_5fps, src)
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(on_move))

	var/atom/movable/movable_parent = parent

/datum/component/shadekin_phasing_handler/UnregisterFromParent()
	..()
	STOP_PROCESSING(SSprocess_5fps, src)
	UnregisterSignal(parent, COMSIG_MOVABLE_MOVED)

	var/atom/movable/movable_parent = parent

/datum/component/shadekin_phasing_handler/proc/on_move(atom/movable/source)

/datum/component/shadekin_phasing_handler

#warn impl
