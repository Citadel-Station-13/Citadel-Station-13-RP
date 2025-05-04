//* If you change any of these procs, you better find/replace *every single* proc signature to match
//* Obviously you don't need to do this for default arguments, because that'd insert a lot of compiled in isnull()'s
//* But the whole point of this refactor is to standardize.
//* All PRs that breach convention will be held until in compliance.

//? Click-Chain system - using an item in hand to "attack", whether in melee or ranged.

// todo: refactor attack object/mob to just melee_attack_chain and a single melee attack system or something
// todo: yeah most of this file needs re-evaluated again, especially for event_args/actor/clickchain support & right clicks

/**
 * Called when trying to click something that the user can Reachability() to.
 *
 * todo: this should allow passing in a clickchain datum instead.
 * todo: lazy_melee_attack() for when you don't want to.
 *
 * @params
 * - target - thing hitting
 * - user - user using us
 * - clickchain_flags - see [code/__DEFINES/procs/clickcode.dm]
 * - params - params as list.
 */
/obj/item/proc/melee_interaction_chain(atom/target, mob/user, clickchain_flags, list/params)
	// wow we have a lot of params
	// if only this was ss14 so we could have the EntityEventArgs :pleading:

	. = clickchain_flags

	// todo: inject something here for 'used as item' much like /tg/, to get rid of attackby pattern

	var/datum/event_args/actor/clickchain/e_args = new(user)
	e_args.click_params = params

	if((. |= item_attack_chain(target, e_args, ., params)) & CLICKCHAIN_DO_NOT_PROPAGATE)
		return

	if((. |= tool_attack_chain(target, user, ., params)) & CLICKCHAIN_DO_NOT_PROPAGATE)
		return

	if((. |= pre_attack(target, user, ., params)) & CLICKCHAIN_DO_NOT_PROPAGATE)
		return

	// todo: refactor
	// todo: this should all be split into:
	// - item use & receive item use (item_interaction() on /atom, definiteily)
	// - tool use & receive tool use (we already have tool_interaction() on /atom)
	// - melee attack & receive melee attack (melee_interaction() on /atom? not melee_act directly?)
	// - melee attack shouldn't require attackby() to allow it to, it should be automatic on harm intent (?)
	// - the item should have final say but we need a way to allow click redirections so..
	if(resolve_attackby(target, user, params, null, .))
		return CLICKCHAIN_DO_NOT_PROPAGATE

	// todo: signal for afterattack here
	return . | afterattack(target, user, clickchain_flags, params)

/**
 * Called when trying to click something that the user can't Reachability() to.
 *
 * todo: this should allow passing in a clickchain datum instead.
 * todo: lazy_ranged_attack() for when you don't want to.
 *
 * @params
 * - target - thing hitting
 * - user - user using us
 * - clickchain_flags - see [code/__DEFINES/procs/clickcode.dm]
 * - params - params as list.
 */
/obj/item/proc/ranged_interaction_chain(atom/target, mob/user, clickchain_flags, list/params)
	// todo: signal for afterattack here
	return clickchain_flags | afterattack(target, user, clickchain_flags, params)

/**
 * Called when trying to click something that the user can Reachability() to,
 * to allow for the tool system to intercept the attack as a tool action.
 */
/obj/item/proc/tool_attack_chain(atom/target, mob/user, clickchain_flags, list/params)
	// are we on harm intent? if so, lol no
	if(user && (user.a_intent == INTENT_HARM))
		return NONE
	return target.tool_interaction(src, new /datum/event_args/actor/clickchain(user, target = target, params = params), clickchain_flags | CLICKCHAIN_TOOL_ACT)

/**
 * called at the start of melee attack chains
 * only called if proximate (ranged skips)
 *
 * @params
 * * target - atom being attacked
 * * user - person attacking
 * * clickchain_flags - __DEFINES/procs/clickcode.dm flags
 * * params - list of click params
 *
 * @return clickchain flags to add, halting the chain if CLICKCHAIN_DO_NOT_PROPAGATE is returned
 */
/obj/item/proc/pre_attack(atom/target, mob/user, clickchain_flags, list/params)
	// todo: signal
	return NONE

/**
 * called when someone hits us with an item while in Reachability() range
 *
 * usually triggers attack_object or attack_mob
 *
 * @params
 * * I - item being used to use/attack us in melee
 * * user - person attacking
 * * clickchain_flags - __DEFINES/procs/clickcode.dm flags
 * * params - list of click params
 *
 * @return clickchain flags to append
 */
// todo: we still use old attackby; convert when possible.
// /atom/movable/attackby(obj/item/I, mob/user, clickchain_flags, list/params)

/**
 * Called after attacking something/someone if CLICKCHAIN_DO_NOT_PROPAGATE was not raised.
 *
 * @params
 * * target - target atom
 * * user - attacking mob
 * * clickchain_flags - flags
 * * list/params - click parameters
 *
 * @return clickchain flags to append
 */
/obj/item/proc/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	return NONE

/**
 * standard proc for engaging a target in melee
 *
 * @params
 * * target - atom being attacked
 * * user - person attacking
 * * clickchain_flags - __DEFINES/procs/clickcode.dm flags
 * * params - list of click params
 * * mult - damage/force multiplier
 * * target_zone - zone to target
 * * intent - action intent to use
 */
/obj/item/proc/standard_melee_attack(atom/target, mob/user, clickchain_flags, list/params, mult = 1, target_zone, intent)
	// too complciated to be put in proc header
	if(isnull(target_zone))
		target_zone = user.zone_sel?.selecting
	if(isnull(intent))
		intent = user.a_intent
	// end
	if(item_flags & ITEM_NO_BLUDGEON)
		return NONE
	if(clickchain_flags & CLICKCHAIN_DO_NOT_ATTACK)
		return NONE
	var/datum/event_args/actor/clickchain/e_args = new(user, target = target, intent = intent, params = params)
	// todo: not hardcoding this
	if(IS_PRONE(user))
		mult *= 0.66
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

//? todo: melee_special
//? todo: combine mob/obj procs

/**
 * called when we're used to attack a mob
 *
 * @params
 * * target - atom being attacked
 * * user - person attacking
 * * clickchain_flags - __DEFINES/procs/clickcode.dm flags
 * * params - list of click params
 * * mult - damage/force multiplier
 * * target_zone - zone to target
 * * intent - action intent to use
 *
 * @return clickchain flags to append
 */
/obj/item/proc/attack_mob(mob/target, mob/user, clickchain_flags, list/params, mult = 1, target_zone, intent)
	PROTECTED_PROC(TRUE)	// route via standard_melee_attack please.
	//? legacy: for now no attacking nonliving
	if(!isliving(target))
		return CLICKCHAIN_ATTACK_MISSED
	// too complciated to be put in proc header
	if(isnull(target_zone))
		target_zone = user.zone_sel?.selecting
	if(isnull(intent))
		intent = user.a_intent
	// end
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

/**
 * called at base of attack_mob after standard melee attack misses
 *
 * @return clickchain flags to append
 *
 * @params
 * * target - atom being attacked
 * * user - person attacking
 * * clickchain_flags - __DEFINES/procs/clickcode.dm flags
 * * params - list of click params
 * * mult - damage multiplier that would have been used
 * * target_zone - zone that user tried to target
 * * intent - action intent that was attempted
 */
/obj/item/proc/melee_mob_miss(mob/target, mob/user, clickchain_flags, list/params, mult = 1, target_zone, intent)
	SHOULD_CALL_PARENT(TRUE)
	var/mob/living/L = target
	// todo: proper weapon sound ranges/rework
	playsound(src, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
	// feedback
	visible_message("<span class='danger'>\The [user] misses [L] with \the [src]!</span>")
	return CLICKCHAIN_ATTACK_MISSED

/**
 * called at base of attack_mob after standard melee attack resolves
 *
 * @return clickchain flags to append
 *
 * @params
 * * target - atom being attacked
 * * user - person attacking
 * * clickchain_flags - __DEFINES/procs/clickcode.dm flags
 * * params - list of click params
 * * mult - damage/force multiplier
 * * target_zone - zone to target
 * * intent - action intent to use
 */
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

/**
 * called after attack_mob, regardless of if standard handling is done
 * this is currently called even if the attacker missed!
 *
 * @params
 * * target - atom being attacked
 * * user - person attacking
 * * clickchain_flags - __DEFINES/procs/clickcode.dm flags
 * * params - list of click params
 * * mult - damage/force multiplier
 * * target_zone - zone to target
 * * intent - action intent to use
 *
 * @return clickchain flags to append
 */
/obj/item/proc/finalize_mob_melee(mob/target, mob/user, clickchain_flags, list/params, mult = 1, target_zone, intent)
	return NONE

/**
 * called when we're used to attack a non-mob
 * this doesn't actually need to be an obj.
 *
 * todo: purge mult
 *
 * @params
 * * target - atom being attacked
 * * clickchain - the /datum/event_args/actor/clickchain arguments included
 * * clickchain_flags - __DEFINES/procs/clickcode.dm flags
 * * mult - damage multiplier
 *
 * @return clickchain flags to append
 */
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

/**
 * called at base of attack_object after standard melee attack misses
 *
 * todo: purge mult
 *
 * @return clickchain flags to append
 *
 * @params
 * * target - atom being attacked
 * * clickchain - the /datum/event_args/actor/clickchain arguments included
 * * clickchain_flags - __DEFINES/procs/clickcode.dm flags
 * * mult - damage multiplier
 */
/obj/item/proc/melee_object_miss(atom/target, datum/event_args/actor/clickchain/clickchain, clickchain_flags, mult = 1)
	SHOULD_CALL_PARENT(TRUE)
	playsound(clickchain.performer, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
	clickchain.visible_feedback(
		target = target,
		range = MESSAGE_RANGE_COMBAT_LOUD,
		visible = SPAN_WARNING("[clickchain.performer] swings for [target], but misses!"),
	)
	return CLICKCHAIN_ATTACK_MISSED

/**
 * called at base of attack_object after standard melee attack resolves
 *
 * @return clickchain flags to append
 *
 * @params
 * * target - atom being attacked
 * * clickchain - the /datum/event_args/actor/clickchain arguments included
 * * clickchain_flags - __DEFINES/procs/clickcode.dm flags
 * * mult - damage multiplier
 */
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
	target.melee_act(clickchain.performer, src, null, clickchain)
	// animate
	target.animate_hit_by_weapon(clickchain.performer, src)

	// todo: better logging
	// todo: entity ids?
	var/newhp = target.integrity
	log_attack(key_name(src), "[target] ([ref(target)])", "attacked with [src] [src.damage_type]-[src.damage_force]=[src.damage_tier] newhp ~[newhp || "unknown"]")

	return NONE

/**
 * called after attack_object, regardless of if standard handling is done
 * this is currently called even if the attacker missed!
 *
 * @params
 * * target - atom being attacked
 * * clickchain - the /datum/event_args/actor/clickchain arguments included
 * * clickchain_flags - __DEFINES/procs/clickcode.dm flags
 * * mult - damage multiplier
 *
 * @return clickchain flags to append
 */
/obj/item/proc/finalize_object_melee(atom/target, datum/event_args/actor/clickchain/clickchain, clickchain_flags, mult = 1)
	return NONE
