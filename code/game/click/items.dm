//* If you change any of these procs, you better find/replace *every single* proc signature to match
//* Obviously you don't need to do this for default arguments, because that'd insert a lot of compiled in isnull()'s
//* But the whole point of this refactor is to standardize.
//* All PRs that breach convention will be held until in compliance.

//? Click-Chain system - using an item in hand to "attack", whether in melee or ranged.

/**
 * Called when trying to click something that the user can Reachability() to.
 *
 * @params
 * - target - thing hitting
 * - user - user using us
 * - clickchain_flags - see [code/__DEFINES/procs/clickcode.dm]
 * - params - params as list.
 */
/obj/item/proc/melee_attack_chain(atom/target, mob/user, clickchain_flags, list/params)
	// wow we have a lot of params
	// if only this was ss14 so we could have the EntityEventArgs :pleading:

	. = clickchain_flags

	if((. |= tool_attack_chain(target, user, ., params)) & CLICKCHAIN_DO_NOT_PROPAGATE)
		return

	if((. |= pre_attack(target, user, ., params)) & CLICKCHAIN_DO_NOT_PROPAGATE)
		return

	// todo: refactor
	if(resolve_attackby(target, user, params, null, clickchain_flags))
		return CLICKCHAIN_DO_NOT_PROPAGATE

	// todo: signal for afterattack here
	return clickchain_flags | afterattack(target, user, clickchain_flags, params)

/**
 * Called when trying to click something that the user can't Reachability() to.
 *
 * @params
 * - target - thing hitting
 * - user - user using us
 * - clickchain_flags - see [code/__DEFINES/procs/clickcode.dm]
 * - params - params as list.
 */
/obj/item/proc/ranged_attack_chain(atom/target, mob/user, clickchain_flags, list/params)
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
	return target.tool_interaction(src, user, clickchain_flags | CLICKCHAIN_TOOL_ACT)

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
	if(item_flags & ITEM_NOBLUDGEON)
		return NONE
	if(clickchain_flags & CLICKCHAIN_DO_NOT_ATTACK)
		return NONE
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
	. = attack_object(target, user, clickchain_flags, params, mult)
	if(. & CLICKCHAIN_DO_NOT_PROPAGATE)
		return
	return . | finalize_object_melee(target, user, . | clickchain_flags, params, mult)

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
	// too complciated to be put in proc header
	if(isnull(target_zone))
		target_zone = user.zone_sel?.selecting
	if(isnull(intent))
		intent = user.a_intent
	// end
	//? legacy: for now no attacking nonliving
	if(!isliving(target))
		return
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
	// todo: better tracking
	user.lastattacked = L
	L.lastattacker = user
	// click cooldown
	// todo: clickcd rework
	user.setClickCooldown(user.get_attack_speed(src))
	// animation
	user.do_attack_animation(L)
	// resolve accuracy
	var/hit_zone = L.resolve_item_attack(src, user, target_zone)
	if(!hit_zone)
		// missed
		// log
		add_attack_logs(user, L, "missed with [src] DT [damtype] F [damage_force] I [user.a_intent]")
		return melee_mob_miss(L, user, clickchain_flags, params, mult, target_zone, intent)
	// log
	add_attack_logs(user, L, "attacked with [src] DT [damtype] F [damage_force] I [user.a_intent]")
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
	// too complciated to be put in proc header
	if(isnull(target_zone))
		target_zone = user.zone_sel?.selecting
	if(isnull(intent))
		intent = user.a_intent
	// end
	//? legacy: decloak
	user.break_cloak()
	//? legacy: for now no attacking nonliving
	if(!isliving(target))
		return
	var/mob/living/L = target
	// todo: proper weapon sound ranges/rework
	playsound(src, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
	// feedback
	visible_message("<span class='danger'>\The [user] misses [L] with \the [src]!</span>")
	return NONE

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
	// too complciated to be put in proc header
	if(isnull(target_zone))
		target_zone = user.zone_sel?.selecting
	if(isnull(intent))
		intent = user.a_intent
	// end
	//? legacy: decloak
	user.break_cloak()
	//? legacy: for now no attacking nonliving
	if(!isliving(target))
		return
	// harmless, just tap them and leave
	if(!damage_force)
		// todo: proper weapon sound ranges/rework
		playsound(src, 'sound/weapons/tap.ogg', 50, 1, -1)
		// feedback
		user.visible_message(SPAN_WARNING("[user] harmlessly taps [target] with [src]."))
		return NONE
	var/mob/living/L = target
	// todo: proper weapon sound ranges/rework
	if(hitsound)
		playsound(src, hitsound, 50, 1, -1)
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
	// too complciated to be put in proc header
	if(isnull(target_zone))
		target_zone = user.zone_sel?.selecting
	if(isnull(intent))
		intent = user.a_intent
	// end
	return NONE

/**
 * called when we're used to attack a non-mob
 * this doesn't actually need to be an obj.
 *
 * @params
 * * target - atom being attacked
 * * user - person attacking
 * * clickchain_flags - __DEFINES/procs/clickcode.dm flags
 * * params - list of click params
 *
 * @return clickchain flags to append
 */
/obj/item/proc/attack_object(atom/target, mob/user, clickchain_flags, list/params)
	PROTECTED_PROC(TRUE)	// route via standard_melee_attack please.
	if((item_flags & ITEM_CAREFUL_BLUDGEON) && user.a_intent == INTENT_HELP)
		user.action_feedback(SPAN_WARNING("You refrain from hitting [target] because your intent is set to help."), src)
		return
	// sorry, no atom damage
	// ... yet >:)
	visible_message(SPAN_WARNING("[user] bashes [target] with [src]."))
	return melee_object_hit(target, user, clickchain_flags, params, 1)

/**
 * called at base of attack_object after standard melee attack resolves
 *
 * @return clickchain flags to append
 *
 * @params
 * * target - atom being attacked
 * * user - person attacking
 * * clickchain_flags - __DEFINES/procs/clickcode.dm flags
 * * params - list of click params
 * * mult - damage multiplier
 */
/obj/item/proc/melee_object_hit(atom/target, mob/user, clickchain_flags, list/params, mult = 1)
	SHOULD_CALL_PARENT(TRUE)
	return NONE

/**
 * called after attack_object, regardless of if standard handling is done
 * this is currently called even if the attacker missed!
 *
 * @params
 * * target - atom being attacked
 * * user - person attacking
 * * clickchain_flags - __DEFINES/procs/clickcode.dm flags
 * * params - list of click params
 * * mult - damage multiplier
 *
 * @return clickchain flags to append
 */
/obj/item/proc/finalize_object_melee(atom/target, mob/user, clickchain_flags, list/params, mult = 1)
	return NONE
