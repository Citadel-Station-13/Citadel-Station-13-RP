//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * registers a /movable in a spatial grid
 */
/datum/component/recursive_freeflight_permeance
	registered_type = /datum/component/recursive_freeflight_permeance

/datum/component/recursive_freeflight_permeance/Initialize(datum/recursive_freeflight_permeance/grid)
	. = ..()
	if(. == COMPONENT_INCOMPATIBLE)
		return
	if(!ismovable(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/recursive_freeflight_permeance/RegisterWithParent()
	..()

/datum/component/recursive_freeflight_permeance/UnregisterFromParent()
	..()

#warn impl; traits maybe?
