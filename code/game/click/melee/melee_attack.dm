//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * A descriptor for a type of melee attack.
 *
 * * Everything is casted to /movable instead of /mob for attacker,
 *   to support things like circuit stabby-stabby's later and similarly
 *   unnecessary fluff.
 */
/datum/melee_attack

/**
 * Called to perform standard attack effects on a target.
 *
 * @return clickchain flags
 */
/datum/melee_attack/proc/perform_attack_impact_entrypoint(atom/movable/attacker, atom/target, datum/event_args/actor/clickchain/clickchain)
	CRASH("base of /datum/melee_attack attack entrypoint reached")

/**
 * @return TRUE if handled
 */
/datum/melee_attack/proc/perform_attack_animation(atom/movable/attacker, atom/target, missed)
	attacker.animate_swing_at_target(target)
	return TRUE

/**
 * @return TRUE if handled
 */
/datum/melee_attack/proc/perform_attack_sound(atom/movable/attacker, atom/target, missed)
	if(missed)
		playsound(attacker, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
		return TRUE
	return FALSE

/**
 * @return TRUE if handled
 */
/datum/melee_attack/proc/perform_attack_message(atom/movable/attacker, atom/target, missed)
	if(missed)
		attacker.visible_message(
			SPAN_WARNING("[src] swings for [target], but misses!"),
			range = MESSAGE_RANGE_COMBAT_LOUD,
		)
		return TRUE
	return FALSE
