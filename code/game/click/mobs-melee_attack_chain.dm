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
 * * clickchain - the clickchain data, including who's doing the interaction
 * * clickchain_flags - the clickchain flags given
 *
 * @return CLICKCHAIN_* flags. These are added / interpreted by the caller.
 */
/mob/proc/melee_attack_chain(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	SHOULD_NOT_SLEEP(TRUE)

	//* TODO: this hook should be somewhere at base of melee interaction chain

	if(clickchain_flags & CLICKCHAIN_DO_NOT_ATTACK)
		return clickchain_flags
	if(!clickchain.target?.is_melee_targetable(clickchain, clickchain_flags))
		return clickchain_flags

	var/datum/melee_attack/unarmed/using_style = default_unarmed_attack_style()
	if(!using_style)
		return clickchain_flags
	. = melee_attack(clickchain, clickchain_flags, using_style)

	clickchain.performer.setClickCooldownLegacy(clickchain.click_cooldown_base * clickchain.click_cooldown_multiplier)

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

	// -- call on ourselves --
	legacy_alter_melee_clickchain(clickchain)

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

	return clickchain_flags | CLICKCHAIN_DID_SOMETHING

/**
 * Override hook for melee attacks.
 *
 * * This is the simplified version of [melee_impact], and is useful for one-off interactions with items and whatnot
 *   that don't need complex clickchain interactions.
 * * This is only called if the hit doesn't miss.
 * * Called from [melee_attack]
 * * Called before [melee_finalize]
 *
 * Notes:
 * * Do not `to_chat(src, ...)`. Use `actor.chat_feedback()`.
 * * Please respect `efficiency`, or your item will bypass shields.
 * * The attack animation of the current attack style will be played automatically
 *   upon returning TRUE, with no sound or message to accompany it.
 *
 * @params
 * * target - target being hit
 * * intent - intent the item is being used in.
 * * zone - target zone being hit
 * * efficiency - 1 is a full pass, 0 is a full block.
 * * actor - actor data
 *
 * @return TRUE if handled to abort normal handling.
 */
/mob/proc/melee_override(atom/target, intent, zone, efficiency, datum/event_args/actor/actor)
	return FALSE

/**
 * Performs impact effects of a melee attack.
 *
 * * Do not edit clickchain target / performer at this point; there can be no more redirections.
 * * Missing is the failure to make contact entirely. If it makes contact and is blocked by shieldcall,
 *   that's a different deal.
 * * This does not run if we're qdel'd or the clickchain is terminated early.
 *
 * @params
 * * clickchain - clickchain data
 * * clickchain_flags - clickchain flags
 * * attack_style - attack style being used
 *
 * @return clickchain flags
 */
/mob/proc/melee_impact(datum/event_args/actor/clickchain/clickchain, clickchain_flags, datum/melee_attack/unarmed/attack_style)
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
	fixed_target.animate_hit_by_attack(attack_style.animation_type)
	return clickchain_flags | fixed_target.on_melee_act(src, null, attack_style, clickchain.target_zone, clickchain, clickchain_flags)

/**
 * Called after a melee attack is executed, regardless of if it hit.
 *
 * * Missing is defined as a failure to make contact. Being fully blocked/negated is still a hit.
 *
 * @params
 * * clickchain - clickchain data
 * * clickchain_flags - clickchain flags
 * * attack_style - unarmed attack style used
 *
 * @return CLICKCHAIN_* flags
 */
/mob/proc/melee_finalize(datum/event_args/actor/clickchain/clickchain, clickchain_flags, datum/melee_attack/unarmed/attack_style)
	SHOULD_NOT_SLEEP(TRUE)
