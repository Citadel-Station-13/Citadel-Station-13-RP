//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Called when trying to click on someone we can Reachability() to without an item in hand.
 *
 * todo: this should allow passing in a clickchain datum instead.
 * todo: lazy_melee_attack() for when you don't want to.
 *
 * @params
 * - target - thing we're clicking
 * - clickchain_flags - see [code/__DEFINES/procs/clickcode.dm]
 * - params - parameters of click, as list
 */
/mob/proc/melee_interaction_chain(atom/target, clickchain_flags, list/params)
	// todo: refactor cooldown handling
	if(ismob(target))
		setClickCooldownLegacy(get_attack_speed_legacy())
	UnarmedAttack(target, clickchain_flags & CLICKCHAIN_HAS_PROXIMITY)

/**
 * Called when trying to click on someone we can't Reachability() to without an item in hand.
 *
 * @params
 * - target - thing we're clicking
 * - clickchain_flags - see [code/__DEFINES/procs/clickcode.dm]
 * - params - parameters of click, as list
 */
/mob/proc/ranged_interaction_chain(atom/target, clickchain_flags, list/params)
	// todo: NO. MORE. TEXT. PARAMS. WHY. ARE. WE. UNPACKING. THE. LIST. MULTIPLE. TIMES?
	var/stupid_fucking_shim = list2params(params)
	RangedAttack(target, stupid_fucking_shim)

/**
 * construct default event args for what we're doing to a target
 *
 * todo: this is semi-legacy
 */
/mob/proc/default_clickchain_event_args(atom/target)
	var/datum/event_args/actor/clickchain/constructed = new
	constructed.initiator = src
	constructed.performer = src
	constructed.target = target
	constructed.target_zone = zone_sel?.selecting || BP_TORSO
	constructed.click_params = list()
	constructed.using_intent = a_intent
	constructed.using_hand_index = active_hand
	return constructed

/**
 * called once per clickchain
 * todo: there has to be a better way
 */
/mob/proc/legacy_alter_melee_clickchain(datum/event_args/actor/clickchain/clickchain)
	if(IS_PRONE(src))
		clickchain.attack_melee_multiplier *= (2 / 3)
	if(MUTATION_HULK in mutations)
		clickchain.attack_melee_multiplier *= 2
	clickchain.click_cooldown_base = clickchain.performer.get_attack_speed_legacy()

/mob/living/legacy_alter_melee_clickchain(datum/event_args/actor/clickchain/clickchain)
	..()
	for(var/datum/modifier/mod in modifiers)
		if(!isnull(mod.outgoing_melee_damage_percent))
			clickchain.attack_melee_multiplier *= mod.outgoing_melee_damage_percent
