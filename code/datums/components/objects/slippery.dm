//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station developers.          *//

/**
 * /obj only
 *
 * * too inefficient for /turf
 * * not complex enough for /mob
 */
/datum/component/slippery
	registered_type = /datum/component/slippery

/datum/component/slippery/Initialize()
	if(!isobj(parent))
		return COMPONENT_INCOMPATIBLE
	. = ..()
	if(. == COMPONENT_INCOMPATIBLE)
		return

/datum/component/slippery/RegisterWithParent()
	RegisterSignal(parent, COMSIG_MOVABLE_CROSSED, PROC_REF(on_cross))

/datum/component/slippery/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_MOVABLE_CROSSED)


#warn impl all
