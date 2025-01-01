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
#warn audit calls
/mob/proc/melee_attack_chain(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
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

#warn deal with this trainwreck

/**
 * @return CLICKCHAIN_* flags
 */
/mob/proc/melee_attack(datum/event_args/actor/clickchain/clickchain, clickchain_flags, datum/melee_attack/unarmed/style)
	SHOULD_CALL_PARENT(TRUE)

	//! Admin Proccall Support
	if(isatom(clickchain))
		clickchain = default_clickchain_event_args(clickchain)
	//! End

	//! Legacy
	break_cloak()
	if(isnull(style))
		style = default_unarmed_attack_style()
	//! End

	/**
	 * the tl;dr of how the chain of negotiations go here is;
	 *
	 * 1. resolve if we should hit
	 * 2. they react to the `_act()`
	 * 3. we react to what they return
	 */

	// -- resolve our side --

	sort_of_legacy_imprint_upon_melee_clickchain(clickchain)

	// -- call on them --
	. = clickchain.target.unarmed_melee_act(src, style, clickchain.target_zone, clickchain)
	var/missed = . & CLICKCHAIN_ATTACK_MISSED

	// -- react to return --
	style.perform_attack_animation(src, clickchain.target, missed)
	style.perform_attack_sound(src, clickchain.target, missed)
	style.perform_attack_message(src, clickchain.target, missed)

	// -- call animation on them --
	clickchain.target.animate_hit_by_attack(style.animation_type)

	// -- log --
	log_unarmed_melee(clickchain, style)

	return on_melee_attack(clickchain, clickchain_flags, style) | .

/**
 * For future use.
 *
 * @return CLICKCHAIN_* flags
 */
/mob/proc/on_melee_attack(datum/event_args/actor/clickchain/clickchain, clickchain_flags, datum/melee_attack/unarmed/style)
	return
