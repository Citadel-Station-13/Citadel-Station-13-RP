//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * A descriptor for a type of melee attack.
 */
/datum/melee_attack

/**
 * Casted to movable for future support.
 */
/datum/melee_attack/proc/perform_attack_animation(atom/movable/attacker, atom/target, missed)
	attacker.animate_swing_at_target(target)

/**
 * Casted to movable for future support.
 */
/datum/melee_attack/proc/perform_attack_sound(atom/movable/attacker, atom/target, missed)

/**
 * Casted to movable for future support.
 */
/datum/melee_attack/proc/perform_attack_message(atom/movable/attacker, atom/target, missed)
