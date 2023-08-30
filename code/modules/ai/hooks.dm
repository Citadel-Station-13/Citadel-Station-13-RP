//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * React to non-harmful item usage on us (so not bash/melee)
 */
/datum/ai_holder/proc/react_to_tap(mob/user, obj/item/tool, a_intent)
	return

/**
 * React to being hit in melee
 */
/datum/ai_holder/proc/react_to_melee(mob/aggressor, obj/item/weapon, resultant_damage)
	return

/**
 * React to being hit by thrown object
 */
/datum/ai_holder/proc/react_to_throw_impact(atom/movable/impacting, resultant_damage, datum/thrownthing/the_throw)
	return

/**
 * React to being shot
 */
/datum/ai_holder/proc/react_to_projectile(obj/projectile, resultant_damage)
	return

/**
 * React to being pulled
 */
/datum/ai_holder/proc/react_to_pull(atom/movable/puller)
	return

/**
 * React to being grabbed
 */
/datum/ai_holder/proc/react_to_Grab(mob/grabber, grab_state)
	return

#warn hook all
