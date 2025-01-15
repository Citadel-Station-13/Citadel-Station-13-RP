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
	switch((legacy_retval = legacy_mob_melee_hook_wrapper(clickchain.target, clickchain.performer, clickchain_flags, clickchain.click_params, clickchain.melee_damage_multiplier, clickchain.target_zone, clickchain.using_intent)))
		if("use_new")
		if("slept")
			return CLICKCHAIN_DID_SOMETHING
		else
			return legacy_retval

	// todo: set this on item maybe?
	var/datum/melee_attack/weapon/attack_style = new
	return melee_attack(clickchain, clickchain_flags, attack_style)

/**
 * called once per clickchain
 * todo: there has to be a better way
 */
/mob/proc/legacy_alter_melee_clickchain(datum/event_args/actor/clickchain/clickchain)
	if(IS_PRONE(src))
		clickchain.melee_damage_multiplier *= (2 / 3)

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

	. |= melee_finalize(fixed_target, clickchain, clickchain_flags, attack_style, missed)

	// -- log --
	log_weapon_melee(clickchain, attack_style, src)


/**
 * Low level proc handling the actual melee attack's effects.
 *
 * * You probably shouldn't be messing with this unless you know what you're doing.
 * * This is only called if we did not miss.
 *
 * @return clickchain flags to return to caller
 */
/obj/item/proc/melee_attack_impact(datum/event_args/actor/clickchain/clickchain, clickchain_flags, datum/melee_attack/weapon/attack_style)
	SHOULD_NOT_SLEEP(TRUE)

#warn parse below

#warn audit calls
/obj/item/proc/attack_mob(mob/target, mob/user, clickchain_flags, list/params, mult = 1, target_zone, intent)
	SHOULD_NOT_SLEEP(TRUE)
	PROTECTED_PROC(TRUE)	// route via standard_melee_attack please.
	var/mob/living/L = target
	// animation
	user.animate_swing_at_target(L)
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

/obj/item/proc/melee_mob_miss(mob/target, mob/user, clickchain_flags, list/params, mult = 1, target_zone, intent)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)
	var/mob/living/L = target
	// todo: proper weapon sound ranges/rework
	playsound(src, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
	// feedback
	visible_message("<span class='danger'>\The [user] misses [L] with \the [src]!</span>")
	return CLICKCHAIN_ATTACK_MISSED

#warn audit calls
/obj/item/proc/melee_mob_hit(mob/target, mob/user, clickchain_flags, list/params, mult = 1, target_zone, intent)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)
	// harmless, just tap them and leave
	if(!damage_force)
		// todo: proper weapon sound ranges/rework
		playsound(src, 'sound/weapons/tap.ogg', 50, 1, -1)
		// feedback
		user.visible_message(SPAN_WARNING("[user] harmlessly taps [target] with [src]."))
		return NONE
	var/mob/living/L = target
	// todo: proper weapon sound ranges/rework
	if(attack_sound)
		playsound(src, attack_sound, 50, 1, -1)
	// feedback
	visible_message(SPAN_DANGER("[L] has been [length(attack_verb)? pick(attack_verb) : attack_verb] with [src] by [user]!"))

	//? legacy code start
	var/power = damage_force
	if(isliving(user))
		var/mob/living/attacker = user
		for(var/datum/modifier/mod in attacker.modifiers)
			if(!isnull(mod.outgoing_melee_damage_percent))
				power *= mod.outgoing_melee_damage_percent
	if(MUTATION_HULK in user.mutations)
		power *= 2
	power *= mult
	L.hit_with_weapon(src, user, power, target_zone)
	//? legacy code end

	// animate
	L.animate_hit_by_weapon(user, src)

	// todo: better logging
	// todo: entity ids?
	var/newhp
	if(isliving(target))
		var/mob/living/casted = target
		newhp = casted.health
	log_attack(key_name(src), key_name(target), "attacked with [src] [src.damage_type]-[src.damage_force]=[src.damage_tier] newhp ~[newhp || "unknown"]")

	return NONE


/obj/item/proc/attack_object(atom/target, datum/event_args/actor/clickchain/clickchain, clickchain_flags, mult = 1)
	SHOULD_NOT_SLEEP(TRUE)
	PROTECTED_PROC(TRUE)	// route via standard_melee_attack please.
	// todo: move this somewhere else
	if(!target.integrity_enabled)
		// no targeting
		return NONE
	if(isobj(target))
		var/obj/casted = target
		if(!(casted.obj_flags & OBJ_MELEE_TARGETABLE))
			// no targeting
			return NONE
	// check intent
	if((item_flags & ITEM_CAREFUL_BLUDGEON) && clickchain.using_intent == INTENT_HELP)
		clickchain.initiator.action_feedback(SPAN_WARNING("You refrain from hitting [target] because your intent is set to help."), src)
		return CLICKCHAIN_DO_NOT_PROPAGATE
	// click cooldown
	// todo: clickcd rework
	clickchain.performer.setClickCooldownLegacy(clickchain.performer.get_attack_speed_legacy(src))
	// animation
	clickchain.performer.animate_swing_at_target(target)
	// perform the hit
	. = melee_object_hit(target, clickchain, clickchain_flags)

/obj/item/proc/melee_object_miss(atom/target, datum/event_args/actor/clickchain/clickchain, clickchain_flags, mult = 1)
	SHOULD_CALL_PARENT(TRUE)
	playsound(clickchain.performer, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
	clickchain.visible_feedback(
		target = target,
		range = MESSAGE_RANGE_COMBAT_LOUD,
		visible = SPAN_WARNING("[clickchain.performer] swings for [target], but misses!"),
	)
	return CLICKCHAIN_ATTACK_MISSED

/obj/item/proc/melee_object_hit(atom/target, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	SHOULD_CALL_PARENT(TRUE)

	// harmless, just tap them and leave
	if(!damage_force)
		// todo: proper weapon sound ranges/rework
		playsound(clickchain.performer, 'sound/weapons/tap.ogg', 50, 1, -1)
		// feedback
		clickchain.visible_feedback(
			target = target,
			range = MESSAGE_RANGE_COMBAT_LOUD,
			visible = SPAN_WARNING("[clickchain.performer] harmlessly taps [target] with [src]."),
			visible_them = SPAN_WARNING("[clickchain.performer] harmlessly taps you with [src]."),
			visible_self = SPAN_WARNING("You harmlessly tap [target] with [src].")
		)
		return NONE
	// sound
	var/resolved_sound = target.hitsound_melee(src)
	if(!isnull(resolved_sound))
		playsound(target, resolved_sound, 50, TRUE)
	// feedback
	// todo: grammar
	clickchain.visible_feedback(
		target = target,
		range = MESSAGE_RANGE_COMBAT_LOUD,
		visible = SPAN_DANGER("[target] has been [islist(attack_verb)? pick(attack_verb) : attack_verb] with [src] by [clickchain.performer]!")
	)
	// damage
	target.item_melee_act(clickchain.performer, src, null, clickchain)
	// animate
	target.animate_hit_by_weapon(clickchain.performer, src)

	// todo: better logging
	// todo: entity ids?
	var/newhp = target.integrity
	log_attack(key_name(src), "[target] ([ref(target)])", "attacked with [src] [src.damage_type]-[src.damage_force]=[src.damage_tier] newhp ~[newhp || "unknown"]")

	return NONE

#warn above

/**
 * Called after we hit something in melee, **whether or not we hit.**
 *
 * * Missing is the failure to make contact entirely. If it makes contact and is blocked by shieldcall,
 *   that's a different deal.
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
