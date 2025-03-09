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
	return melee_attack(clickchain, clickchain_flags, attack_style)

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

	//! Admin Proccall Support
	if(isatom(clickchain) && ismob(clickchain_flags))
		var/mob/proccall_casted_mob = clickchain_flags
		clickchain = proccall_casted_mob.default_clickchain_event_args(clickchain)
		clickchain_flags = NONE
	//! End

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

	//! LEGACY !//
	clickchain.performer.break_cloak()
	if(isliving(clickchain.target))
		var/mob/living/living_target = clickchain.target
		clickchain.performer.lastattacked = living_target
		living_target.lastattacker = clickchain.performer
	if(isnull(attack_style))
		attack_style = new /datum/melee_attack/weapon
	//! END !//

	/**
	 * the tl;dr of how the chain of negotiations go here is;
	 *
	 * 1. resolve if we should hit
	 * 2. they react to the `_act()`
	 * 3. we react to what they return, including calling their on_x_act()
	 */

	// -- resolve our side --
	var/missed = FALSE
	clickchain.performer.legacy_alter_melee_clickchain(clickchain)

	// -- call on them (if we didn't miss / get called off already) --
	if(!missed)
		. |= clickchain.target.item_melee_act(clickchain.performer, attack_style, clickchain.target_zone, clickchain)
		missed = . & CLICKCHAIN_ATTACK_MISSED

	// -- redirection can no longer happen --
	var/atom/fixed_target = clickchain.target
	var/mob/fixed_performer = clickchain.performer

	// -- react to return --
	attack_style.perform_attack_animation(fixed_performer, fixed_target, clickchain, missed)
	attack_style.perform_attack_sound(fixed_performer, fixed_target, clickchain, missed)
	attack_style.perform_attack_message(fixed_performer, fixed_target, clickchain, missed)

	if(!missed)
		fixed_target.animate_hit_by_weapon(fixed_performer, src)
		. |= fixed_target.on_melee_act(fixed_performer, attack_style, clickchain)

	if(!QDELETED(src))
		. |= melee_finalize(fixed_target, clickchain, clickchain_flags, attack_style, missed)

	// -- log --
	log_weapon_melee(clickchain, attack_style, src)

#warn parse below

/obj/item/proc/attack_mob(mob/target, mob/user, clickchain_flags, list/params, mult = 1, target_zone, intent)
	SHOULD_NOT_OVERRIDE(TRUE)
	var/mob/living/L = target
	// resolve accuracy
	var/hit_zone = L.resolve_item_attack(src, user, target_zone)
	if(!hit_zone)
		// missed
		// log
		add_attack_logs(user, L, "missed with [src] DT [damage_type] F [damage_force] I [user.a_intent]")
		return melee_mob_miss(L, user, clickchain_flags, params, mult, target_zone, intent)
	// log
	add_attack_logs(user, L, "attacked with [src] DT [damage_type] F [damage_force] I [user.a_intent]")
	// hit
	return melee_mob_hit(L, user, clickchain_flags, params, mult, target_zone, intent)

/obj/item/proc/melee_mob_hit(mob/target, mob/user, clickchain_flags, list/params, mult = 1, target_zone, intent)
	SHOULD_NOT_OVERRIDE(TRUE)

#warn above

/**
 * Called after we hit something in melee, **whether or not we hit.**
 *
 * * Missing is the failure to make contact entirely. If it makes contact and is blocked by shieldcall,
 *   that's a different deal.
 * * This does not run if we're qdel'd.
 *
 * @params
 * * target - The target swung at; at this point it can't be redirected
 * * clickchain - clickchain data
 * * clickchain_flags - clickchain flags
 * * attack_style - attack style used
 * * missed - Did we miss? Do **not** use clickchain flags to infer this! It's specified explicitly for a reason.
 *
 * @return CLICKCHAIN_* flags
 */
/obj/item/proc/melee_finalize(atom/target, datum/event_args/actor/clickchain/clickchain, clickchain_flags, datum/melee_attack/weapon/attack_style, missed)
	SHOULD_NOT_SLEEP(TRUE)
