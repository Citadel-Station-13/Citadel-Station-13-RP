//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * called once per clickchain
 * todo: there has to be a better way
 */
/mob/proc/legacy_alter_melee_clickchain(datum/event_args/actor/clickchain/clickchain)
	if(IS_PRONE(src))
		clickchain.melee_damage_multiplier *= (2 / 3)

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
	if(clickchain_flags & CLICKCHAIN_DO_NOT_ATTACK)
		return CLICKCHAIN_DO_NOT_ATTACK
	if(item_flags & ITEM_NO_BLUDGEON)
		return CLICKCHAIN_DO_NOT_ATTACK
	if(!clickchain.target?.is_melee_targetable(clickchain))
		return CLICKCHAIN_DO_NOT_ATTACK

	clickchain.performer.legacy_alter_melee_clickchain(clickchain)

#warn deal with this trainwreck
#warn parse below

/obj/item/proc/standard_melee_attack(atom/target, mob/user, clickchain_flags, list/params, mult = 1, target_zone, intent)
	// is mob, go to that
	// todo: signals for both
	if(ismob(target))
		. |= attack_mob(target, user, clickchain_flags, params, mult, target_zone, intent)
		if(. & CLICKCHAIN_DO_NOT_PROPAGATE)
			return
		return . | finalize_mob_melee(target, user, . | clickchain_flags, params, mult, target_zone, intent)
	// is obj, go to that
	. = attack_object(target, e_args, clickchain_flags, mult)
	if(. & CLICKCHAIN_DO_NOT_PROPAGATE)
		return
	return . | finalize_object_melee(target, e_args, . | clickchain_flags, mult)

/obj/item/proc/attack_mob(mob/target, mob/user, clickchain_flags, list/params, mult = 1, target_zone, intent)
	PROTECTED_PROC(TRUE)	// route via standard_melee_attack please.
	var/mob/living/L = target
	// check intent
	if(user == L)
		if(user.a_intent != INTENT_HARM)
			user.action_feedback(SPAN_WARNING("You refrain from hitting yourself with [src], as your intent is not set to harm."), src)
			return NONE
	else
		if((item_flags & ITEM_CAREFUL_BLUDGEON) && user.a_intent == INTENT_HELP)
			user.action_feedback(SPAN_WARNING("You refrain from hitting [target] with [src], as your intent is set to help."), src)
			return NONE
	//? legacy: decloak
	user.break_cloak()
	// todo: better tracking
	user.lastattacked = L
	L.lastattacker = user
	// click cooldown
	// todo: clickcd rework
	user.setClickCooldownLegacy(user.get_attack_speed_legacy(src))
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
	SHOULD_CALL_PARENT(TRUE)
	var/mob/living/L = target
	// todo: proper weapon sound ranges/rework
	playsound(src, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
	// feedback
	visible_message("<span class='danger'>\The [user] misses [L] with \the [src]!</span>")
	return CLICKCHAIN_ATTACK_MISSED

/obj/item/proc/melee_mob_hit(mob/target, mob/user, clickchain_flags, list/params, mult = 1, target_zone, intent)
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

/obj/item/proc/finalize_mob_melee(mob/target, mob/user, clickchain_flags, list/params, mult = 1, target_zone, intent)
	return NONE

/obj/item/proc/attack_object(atom/target, datum/event_args/actor/clickchain/clickchain, clickchain_flags, mult = 1)
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
	//? legacy: decloak
	clickchain.performer.break_cloak()
	// set mult
	clickchain.melee_damage_multiplier *= mult
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

/obj/item/proc/finalize_object_melee(atom/target, datum/event_args/actor/clickchain/clickchain, clickchain_flags, mult = 1)
	return NONE
