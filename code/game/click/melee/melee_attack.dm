//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * A descriptor for a type of melee attack.
 */
/datum/melee_attack

/**
 * * Casted to movable for future support.
 *
 * @return TRUE if handled
 */
/datum/melee_attack/proc/perform_attack_animation(atom/movable/attacker, atom/target, missed)
	attacker.animate_swing_at_target(target)
	return TRUE

/**
 * * Casted to movable for future support.
 *
 * @return TRUE if handled
 */
/datum/melee_attack/proc/perform_attack_sound(atom/movable/attacker, atom/target, missed)
	if(missed)
		playsound(attacker, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
		return TRUE
	return FALSE

/**
 * * Casted to movable for future support.
 *
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
