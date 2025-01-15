//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * A descriptor for a melee attack utilizing an item.
 */
/datum/melee_attack/weapon

/datum/melee_attack/weapon/perform_attack_impact_entrypoint(atom/movable/attacker, atom/target, datum/event_args/actor/clickchain/clickchain)
	return perform_attack_impact(attacker, target, clickchain.using_item, clickchain)

/**
 * Called to perform standard attack effects on a target.
 *
 * @return clickchain flags
 */
/datum/melee_attack/weapon/proc/perform_attack_impact(atom/movable/attacker, atom/target, obj/item/weapon, datum/event_args/actor/clickchain/clickchain)
	PROTECTED_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	if(ismob(target))
		// mob damage is not refactored properly yet
		return
	target.run_damage_instance(
		weapon.damage_force * clickchain.melee_damage_multiplier,
		weapon.damage_type,
		weapon.damage_tier,
		weapon.damage_flag,
		weapon.damage_mode,
		ATTACK_TYPE_MELEE,
		weapon,
		NONE,
		clickchain.target_zone,
		null,
		clickchain,
	)
	return NONE

/datum/melee_attack/weapon/perform_attack_animation(atom/movable/attacker, atom/target, datum/event_args/actor/clickchain/clickchain, missed)
	return ..()

/datum/melee_attack/weapon/perform_attack_sound(atom/movable/attacker, atom/target, datum/event_args/actor/clickchain/clickchain, missed)
	. = ..()
	if(.)
		return
	#warn impl

/datum/melee_attack/weapon/perform_attack_message(atom/movable/attacker, atom/target, datum/event_args/actor/clickchain/clickchain, missed)
	. = ..()
	if(.)
		return
	#warn impl
