//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Called to initiate a melee attack with this item.
 *
 * * Called after item_attack_chain()
 * * Called after tool_attack_chain()
 *
 * @params
 * * e_args - the clickchain data, including who's doing the interaction
 * * clickchain_flags - the clickchain flags given
 *
 * @return CLICKCHAIN_* flags. These are added / interpreted by the caller.
 */
/obj/item/proc/melee_attack_chain(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	SHOULD_NOT_SLEEP(TRUE)
	if(clickchain_flags & CLICKCHAIN_DO_NOT_ATTACK)
		return CLICKCHAIN_DO_NOT_ATTACK
	if(item_flags & ITEM_NO_BLUDGEON)
		return CLICKCHAIN_DO_NOT_ATTACK
	if(!clickchain.target?.is_melee_targetable(clickchain))
		return CLICKCHAIN_DO_NOT_ATTACK

	clickchain.performer.legacy_alter_melee_clickchain(clickchain)

	var/legacy_retval
	switch((legacy_retval = legacy_mob_melee_hook_wrapper(clickchain.target, clickchain.performer, clickchain_flags, clickchain.click_params, clickchain.attack_melee_multiplier, clickchain.target_zone, clickchain.using_intent)))
		if("use_new")
		if("slept")
			return CLICKCHAIN_DID_SOMETHING
		else
			return legacy_retval

	// todo: set this on item maybe?
	var/datum/melee_attack/weapon/attack_style = new
	. = melee_attack(clickchain, clickchain_flags, attack_style)

	clickchain.performer.setClickCooldownLegacy(clickchain.click_cooldown_base * clickchain.click_cooldown_multiplier)

/obj/item/proc/legacy_mob_melee_hook_wrapper(atom/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	PRIVATE_PROC(TRUE)
	if(!ismob(target))
		return "use_new"
	// if it sleeps, the caller will know.
	return legacy_mob_melee_hook_call_wrapper(arglist(args))

/obj/item/proc/legacy_mob_melee_hook_call_wrapper(...)
	PRIVATE_PROC(TRUE)
	set waitfor = FALSE
	. = "slept"
	return legacy_mob_melee_hook(arglist(args))

/**
 * this is here to allow legacy behaviors to work
 *
 * majority of melee attack hooks need to be refactored to item attack handling, tool attack handling,
 * or refactored in general to use new melee system
 *
 * the default behavior of this is to return a nonsensical value that is detected and used to determine that
 * we should use the new melee system
 *
 * @return clickchain flags, or, the exact string `"use_new"`
 */
/obj/item/proc/legacy_mob_melee_hook(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	return "use_new"

/**
 * Low level proc handling the actual melee attack / impact.
 *
 * * You probably shouldn't be messing with this unless you know what you're doing.
 *
 * @return clickchain flags to return to caller
 */
/obj/item/proc/melee_attack(datum/event_args/actor/clickchain/clickchain, clickchain_flags, datum/melee_attack/weapon/attack_style)
	SHOULD_NOT_SLEEP(TRUE)

	// Admin Proccall Support
	if(isatom(clickchain) && ismob(clickchain_flags))
		var/mob/proccall_casted_mob = clickchain_flags
		clickchain = proccall_casted_mob.default_clickchain_event_args(clickchain)
		clickchain_flags = NONE
	// End

	//*                     -- intent checks --                       *//
	//*          these should not be here, but the presence of        *//
	//* melee_hook_for_legacy_mob_behaviors() forces this to be here. *//
	if(clickchain.target == clickchain.performer && clickchain.using_intent != INTENT_HARM)
		clickchain.chat_feedback(
			SPAN_WARNING("You refrain from hitting yourself with [src], as your intent is not set to harm."),
			src,
		)
		return NONE
	if((item_flags & ITEM_CAREFUL_BLUDGEON) && clickchain.using_intent == INTENT_HELP)
		clickchain.chat_feedback(
			SPAN_WARNING("You refrain from hitting [clickchain.target] with [src], as your intent is set to help."),
			src,
		)
		return NONE

	SEND_SIGNAL(clickchain.performer, COMSIG_MOB_ON_ITEM_MELEE_ATTACK, clickchain, clickchain_flags)
	// LEGACY
	clickchain.performer.break_cloak()
	if(isliving(clickchain.target))
		var/mob/living/living_target = clickchain.target
		clickchain.performer.lastattacked = living_target
		living_target.lastattacker = clickchain.performer
	if(isnull(attack_style))
		attack_style = new /datum/melee_attack/weapon
	// END

	// -- write clickchain data --
	if((clickchain.using_melee_attack && clickchain.using_melee_attack != attack_style) || \
		(clickchain.using_melee_weapon && clickchain.using_melee_weapon != src))
		CRASH("clickchain melee vars were already set + to different values; this shouldn't happen")
	clickchain.using_melee_attack = attack_style
	clickchain.using_melee_weapon = src

	/**
	 * the tl;dr of how the chain of negotiations go here is;
	 *
	 * 1. resolve if we should hit
	 * 2. they react to the `_act()`
	 * 3. we react to what they return, including calling their on_x_act()
	 *
	 * some of these are in melee_impact for overrides.
	 */

	// -- call on ourselves --
	clickchain.performer.legacy_alter_melee_clickchain(clickchain)

	// -- call on them --
	clickchain_flags = clickchain.target.melee_act(clickchain.performer, src, attack_style, clickchain.target_zone, clickchain, clickchain_flags)

	// -- call override --
	var/overridden
	if(!(clickchain_flags & CLICKCHAIN_ATTACK_MISSED))
		overridden = melee_override(clickchain.target, clickchain.performer, clickchain.using_intent, clickchain.target_zone, clickchain.attack_contact_multiplier, clickchain)
		if(QDELETED(src))
			clickchain_flags |= CLICKCHAIN_DO_NOT_PROPAGATE

	// -- execute attack if override didn't run --
	if(!overridden)
		if(!(clickchain_flags & CLICKCHAIN_FLAGS_ATTACK_ABORT))
			clickchain_flags = melee_impact(clickchain, clickchain_flags, attack_style)
	else
		attack_style.perform_attack_animation(clickchain.performer, clickchain.target, clickchain, clickchain_flags & CLICKCHAIN_ATTACK_MISSED, src)

	// -- finalize --
	if(!(clickchain_flags & CLICKCHAIN_FLAGS_UNCONDITIONAL_ABORT))
		clickchain_flags = melee_finalize(clickchain, clickchain_flags, attack_style)

	// -- log --
	log_melee(clickchain, clickchain_flags, attack_style, src)

	return clickchain_flags

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
 * * Do not `to_chat(user, ...)`. Use `actor.chat_feedback()`.
 * * Please respect `efficiency`, or your item will bypass shields.
 * * The attack animation of the current attack style will be played automatically
 *   upon returning TRUE, with no sound or message to accompany it.
 *
 * @params
 * * target - target being hit
 * * user - person doing the hitting
 * * intent - intent the item is being used in.
 * * zone - target zone being hit
 * * efficiency - 1 is a full pass, 0 is a full block.
 * * actor - actor data
 *
 * @return TRUE if handled to abort normal handling.
 */
/obj/item/proc/melee_override(atom/target, mob/user, intent, zone, efficiency, datum/event_args/actor/actor)
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
/obj/item/proc/melee_impact(datum/event_args/actor/clickchain/clickchain, clickchain_flags, datum/melee_attack/weapon/attack_style)
	if(SEND_SIGNAL(src, COMSIG_ITEM_MELEE_IMPACT_HOOK, args) & RAISE_ITEM_MELEE_IMPACT_SKIP)
		return clickchain_flags

	var/atom/fixed_target = clickchain.target
	var/mob/fixed_performer = clickchain.performer
	var/missed = clickchain_flags & CLICKCHAIN_ATTACK_MISSED

	attack_style.perform_attack_animation(fixed_performer, fixed_target, missed, src, clickchain, clickchain_flags)
	attack_style.perform_attack_sound(fixed_performer, fixed_target, missed, src, clickchain, clickchain_flags)
	attack_style.perform_attack_message(fixed_performer, fixed_target, missed, src, clickchain, clickchain_flags)

	if(missed)
		return clickchain_flags
	return fixed_target.on_melee_act(fixed_performer, src, attack_style, clickchain.target_zone, clickchain, clickchain_flags)

/**
 * Called after we hit something in melee, **whether or not we hit.**
 *
 * * Do not edit clickchain target / performer at this point; there can be no more redirections.
 * * Missing is the failure to make contact entirely. If it makes contact and is blocked by shieldcall,
 *   that's a different deal.
 * * This does not run if we're qdel'd or the clickchain is terminated early.
 *
 * @params
 * * clickchain - clickchain data
 * * clickchain_flags - clickchain flags
 * * attack_style - attack style used
 *
 * @return CLICKCHAIN_* flags
 */
/obj/item/proc/melee_finalize(datum/event_args/actor/clickchain/clickchain, clickchain_flags, datum/melee_attack/weapon/attack_style)
	SHOULD_NOT_SLEEP(TRUE)
	return clickchain_flags
