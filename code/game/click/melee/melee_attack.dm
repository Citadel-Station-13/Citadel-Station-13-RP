//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

GLOBAL_LIST_EMPTY(melee_attack_singletons)
/proc/fetch_melee_attack_singleton(datum/melee_attack/specifier)
	if(ispath(specifier))
		if(!GLOB.melee_attack_singletons[specifier])
			GLOB.melee_attack_singletons[specifier] = new specifier
		return GLOB.melee_attack_singletons[specifier]
	else if(istype(specifier))
		return specifier
	else
		return GLOB.melee_attack_singletons[specifier]

/**
 * A descriptor for a type of melee attack.
 *
 * todo: maybe /datum/prototype?
 *
 * * Everything is casted to /movable instead of /mob for attacker,
 *   to support things like circuit stabby-stabby's later and similarly
 *   unnecessary fluff.
 */
/datum/melee_attack

/**
 * Called to perform standard attack effects on a target.
 *
 * @params
 * * attacker - thing doing the attacking
 * * target - thing being attacked
 * * missed - did the attack miss?
 * * weapon - (optional) the weapon used; this can be null
 * * clickchain - (optional) clickchain data
 * * clickchain_flags - (optional) clickchain flags so far
 *
 * @return clickchain flags
 */
/datum/melee_attack/proc/perform_attack_impact(atom/movable/attacker, atom/target, missed, obj/item/weapon, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	SHOULD_NOT_SLEEP(TRUE)
	return clickchain_flags

/**
 * @params
 * * attacker - thing doing the attacking
 * * target - thing being attacked
 * * missed - did the attack miss?
 * * weapon - (optional) the weapon used; this can be null
 * * clickchain - (optional) clickchain data
 * * clickchain_flags - (optional) clickchain flags so far
 *
 * @return TRUE if handled
 */
/datum/melee_attack/proc/perform_attack_animation(atom/movable/attacker, atom/target, missed, obj/item/weapon, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	SHOULD_NOT_SLEEP(TRUE)
	attacker.animate_swing_at_target(target)
	return TRUE

/**
 * @params
 * * attacker - thing doing the attacking
 * * target - thing being attacked
 * * missed - did the attack miss?
 * * weapon - (optional) the weapon used; this can be null
 * * clickchain - (optional) clickchain data
 * * clickchain_flags - (optional) clickchain flags so far
 *
 * @return TRUE if handled
 */
/datum/melee_attack/proc/perform_attack_sound(atom/movable/attacker, atom/target, missed, obj/item/weapon, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	SHOULD_NOT_SLEEP(TRUE)
	if(missed)
		playsound(target, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
		return TRUE
	return FALSE

/**
 * @params
 * * attacker - thing doing the attacking
 * * target - thing being attacked
 * * missed - did the attack miss?
 * * weapon - (optional) the weapon used; this can be null
 * * clickchain - (optional) clickchain data
 * * clickchain_flags - (optional) clickchain flags so far
 *
 * @return TRUE if handled
 */
/datum/melee_attack/proc/perform_attack_message(atom/movable/attacker, atom/target, missed, obj/item/weapon, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	SHOULD_NOT_SLEEP(TRUE)
	if(missed)
		attacker.visible_message(
			SPAN_WARNING("[attacker] swings for [target], but misses!"),
			range = MESSAGE_RANGE_COMBAT_LOUD,
		)
		return TRUE
	return FALSE

/datum/melee_attack/proc/estimate_damage(atom/movable/attacker, atom/target, obj/item/weapon)
	return 0
