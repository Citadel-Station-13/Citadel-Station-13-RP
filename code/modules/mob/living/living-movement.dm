//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/mob/living/movement_delay()
	update_movespeed_modifier(/datum/movespeed_modifier/mob_legacy_slowdown, list(MOVESPEED_PARAM_MOD_HYPERBOLIC_SLOWDOWN = legacy_movement_delay()))
	return ..()

/**
 * adding to this is not allowed.
 */
/mob/living/proc/legacy_movement_delay()
	return 0
