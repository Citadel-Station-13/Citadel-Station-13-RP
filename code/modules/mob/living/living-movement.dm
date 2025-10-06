//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/mob/living/movement_delay()
	// TODO: HEY! LISTEN! this is a bad place to put an update, because this means
	//       we don't update cached variables until we actually move.
	//
	//       if anything relies on reading cached variables between moves, it'll get the old value.
	//       this updates on Life() as a backup measure but that's still not good!
	//
	//       if you need to touch slowdown, please move the system you're touching
	//       to the an event-driven update system via modifiers.
	update_movespeed_modifier(/datum/movespeed_modifier/mob_legacy_slowdown, list(MOVESPEED_PARAM_MOD_HYPERBOLIC_SLOWDOWN = legacy_movement_delay()))
	return ..()

/**
 * adding to this is not allowed.
 */
/mob/living/proc/legacy_movement_delay()
	return 0
