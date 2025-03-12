//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Called to initiate a melee attack as ourselves.
 *
 * * This is a melee attack. This is not a grab, this is not a disarm.
 *   Those should be handled by other parts of the clickchain.
 *   If we are in this proc, it's because we're punching something or someone.
 *
 * todo: how to inject style?
 *
 * @params
 * * e_args - the clickchain data, including who's doing the interaction
 * * clickchain_flags - the clickchain flags given
 *
 * @return CLICKCHAIN_* flags. These are added / interpreted by the caller.
 */
/mob/proc/melee_attack_chain(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	SHOULD_NOT_SLEEP(TRUE)

	if(clickchain_flags & CLICKCHAIN_DO_NOT_ATTACK)
		return clickchain_flags
	if(!clickchain.target.is_melee_targetable(clickchain, clickchain_flags))
		return clickchain_flags

	var/datum/melee_attack/unarmed/using_style = default_unarmed_attack_style()
	if(!using_style)
		return clickchain_flags
	. = clickchain_flags | melee_attack(clickchain, clickchain_flags, using_style)

	#warn this should be modulated by clickchain
	clickchain.performer.setClickCooldownLegacy(clickchain.performer.get_attack_speed_legacy())

/**
 * @return CLICKCHAIN_* flags
 */
/mob/proc/melee_attack(datum/event_args/actor/clickchain/clickchain, clickchain_flags, datum/melee_attack/unarmed/attack_style)
	SHOULD_NOT_SLEEP(TRUE)

	//! Admin Proccall Support
	if(isatom(clickchain))
		clickchain = default_clickchain_event_args(clickchain)
		clickchain_flags = NONE
	//! End

	//! Legacy
	break_cloak()
	if(isnull(attack_style))
		attack_style = default_unarmed_attack_style()
	//! End

	/**
	 * the tl;dr of how the chain of negotiations go here is;
	 *
	 * 1. resolve if we should hit
	 * 2. they react to the `_act()`
	 * 3. we react to what they return, including calling their on_x_act()
	 */

	// -- resolve our side --
	var/missed = FALSE
	legacy_alter_melee_clickchain(clickchain)

	// -- call on them (if we didn't miss / get called off already) --
	if(!missed)
		. |= clickchain.target.unarmed_melee_act(src, attack_style, clickchain.target_zone, clickchain)
		missed = . & CLICKCHAIN_ATTACK_MISSED

	// -- redirection can no longer happen --
	var/atom/fixed_target = clickchain.target

	// -- react to return --
	attack_style.perform_attack_animation(src, fixed_target, clickchain, missed)
	attack_style.perform_attack_sound(src, fixed_target, clickchain, missed)
	attack_style.perform_attack_message(src, fixed_target, clickchain, missed)

	if(!missed)
		fixed_target.animate_hit_by_attack(attack_style.animation_type)
		. |= fixed_target.on_melee_act(src, attack_style, clickchain)

	. |= melee_finalize(fixed_target, clickchain, clickchain_flags, attack_style, missed)

	// -- log --
	log_unarmed_melee(clickchain, attack_style)

/**
 * Called after a melee attack is executed, regardless of if it hit.
 *
 * * Missing is defined as a failure to make contact. Being fully blocked/negated is still a hit.
 *
 * @params
 * * target - The target swung at; at this point it can't be redirected
 * * clickchain - clickchain data
 * * clickchain_flags - clickchain flags
 * * attack_style - unarmed attack style used
 * * missed - did we miss?
 *
 * @return CLICKCHAIN_* flags
 */
/mob/proc/melee_finalize(datum/event_args/actor/clickchain/clickchain, clickchain_flags, datum/melee_attack/weapon/attack_style, atom/fixed_target, mob/fixed_performer, fixed_missed)
	SHOULD_NOT_SLEEP(TRUE)
