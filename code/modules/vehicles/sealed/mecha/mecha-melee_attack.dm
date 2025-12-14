//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

// TODO: get rid of this when vehicle is mob as mobs have this
/obj/vehicle/sealed/mecha/proc/melee_attack_chain(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	SHOULD_NOT_SLEEP(TRUE)
	#warn MOD THIS FOR VEHICLE
	if(clickchain_flags & CLICKCHAIN_DO_NOT_ATTACK)
		return clickchain_flags
	if(!clickchain.target?.is_melee_targetable(clickchain, clickchain_flags))
		return clickchain_flags

	var/datum/melee_attack/vehicle/mecha/using_style = melee_attack
	if(!using_style)
		return clickchain_flags
	. = melee_attack(clickchain, clickchain_flags, using_style)

/obj/vehicle/sealed/mecha/proc/melee_attack(datum/event_args/actor/clickchain/clickchain, clickchain_flags, datum/melee_attack/vehicle/mecha/attack_style)
	SHOULD_NOT_SLEEP(TRUE)

	// -- write clickchain data --
	if((clickchain.using_melee_attack && clickchain.using_melee_attack != attack_style) || \
		clickchain.using_melee_weapon)
		CRASH("clickchain melee vars were already set + to different values; this shouldn't happen")
	clickchain.using_melee_attack = attack_style

	/**
	 * the tl;dr of how the chain of negotiations go here is;
	 *
	 * 1. resolve if we should hit
	 * 2. they react to the `_act()`
	 * 3. we react to what they return, including calling their on_x_act()
	 */

	// -- call on them (if we didn't miss / get called off already) --
	clickchain_flags |= clickchain.target.melee_act(src, src, attack_style, clickchain.target_zone, clickchain, clickchain_flags)

	// -- call override --
	var/overridden
	if(!(clickchain_flags & CLICKCHAIN_ATTACK_MISSED))
		overridden = melee_override(clickchain.target, clickchain.using_intent, clickchain.target_zone, clickchain.attack_contact_multiplier, clickchain)
		if(QDELETED(src))
			clickchain_flags |= CLICKCHAIN_DO_NOT_PROPAGATE

	// -- execute attack if override didn't run --
	if(!overridden)
		if(!(clickchain_flags & CLICKCHAIN_FLAGS_ATTACK_ABORT))
			clickchain_flags |= melee_impact(clickchain, clickchain_flags, attack_style)
	else
		attack_style.perform_attack_animation(clickchain.performer, clickchain.target, clickchain, clickchain_flags & CLICKCHAIN_ATTACK_MISSED)

	// -- finalize --
	if(!(clickchain_flags & CLICKCHAIN_FLAGS_UNCONDITIONAL_ABORT))
		clickchain_flags |= melee_finalize(clickchain, clickchain_flags, attack_style)

	// -- log --
	log_melee(clickchain, clickchain_flags, attack_style)
	#warn apply cooldown

	return clickchain_flags | CLICKCHAIN_DID_SOMETHING

/obj/vehicle/sealed/mecha/proc/melee_override(atom/target, intent, zone, efficiency, datum/event_args/actor/actor)
	return FALSE

/obj/vehicle/sealed/mecha/proc/melee_impact(datum/event_args/actor/clickchain/clickchain, clickchain_flags, datum/melee_attack/vehicle/mecha/attack_style)
	if(SEND_SIGNAL(src, COMSIG_MOB_MELEE_IMPACT_HOOK, args) & RAISE_MOB_MELEE_IMPACT_SKIP)
		return clickchain_flags

	var/atom/fixed_target = clickchain.target
	var/mob/fixed_performer = clickchain.performer
	var/missed = clickchain_flags & CLICKCHAIN_ATTACK_MISSED

	attack_style.perform_attack_animation(fixed_performer, fixed_target, missed, src, clickchain, clickchain_flags)
	attack_style.perform_attack_sound(fixed_performer, fixed_target, missed, src, clickchain, clickchain_flags)
	attack_style.perform_attack_message(fixed_performer, fixed_target, missed, src, clickchain, clickchain_flags)

	if(missed)
		return clickchain_flags
	if(attack_style.animation_type)
		fixed_target.animate_hit_by_attack(attack_style.animation_type)
	return clickchain_flags | fixed_target.on_melee_act(src, null, attack_style, clickchain.target_zone, clickchain, clickchain_flags)

/obj/vehicle/sealed/mecha/proc/melee_finalize(datum/event_args/actor/clickchain/clickchain, clickchain_flags, datum/melee_attack/vehicle/mecha/attack_style)
	SHOULD_NOT_SLEEP(TRUE)

/**
 * "So I got punched by a gundam"
 */
/datum/melee_attack/vehicle/mecha
	/**
	 * Multiplier to the vehicle's `melee_standard_force`
	 */
	var/attack_force_multiplier = 1
	/**
	 * (Nullable) Overrides the vehicle's `melee_standard_force`
	 */
	var/attack_force_override
	/**
	 * Additive modifier to the vehicle's `melee_standard_tier`
	 */
	var/attack_tier_add = 1
	/**
	 * (Nullable) Overrides the vehicle's `melee_standard_tier`
	 */
	var/attack_tier_override
	/**
	 * Multiplier to the vehicle's `melee_standard_speed`
	 */
	var/attack_cooldown_multiplier = 1
	/**
	 * (Nullable) Overrides the vehicle's `melee_standard_speed`
	 */
	var/attack_cooldown_override

#warn impl

/datum/melee_attack/vehicle/mecha/perform_attack_animation(atom/movable/attacker, atom/target, missed, obj/item/weapon, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()

/datum/melee_attack/vehicle/mecha/perform_attack_impact(atom/movable/attacker, atom/target, missed, obj/item/weapon, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()

/datum/melee_attack/vehicle/mecha/perform_attack_message(atom/movable/attacker, atom/target, missed, obj/item/weapon, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()

/datum/melee_attack/vehicle/mecha/perform_attack_sound(atom/movable/attacker, atom/target, missed, obj/item/weapon, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()

/datum/melee_attack/vehicle/mecha/punch

/datum/melee_attack/vehicle/mecha/kick
