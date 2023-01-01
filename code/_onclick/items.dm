//? If you change any of these procs, you better find/replace *every single* proc signature to match
//? Obviously you don't need to do this for default arguments, because that'd insert a lot of compiled in isnull()'s
//? But the whole point of this refactor is to standardize.
//? All PRs that breach convention will be held until in compliance.

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

	// todo: NO. MORE. LIST. PARAMS. WHY. ARE. WE. UNPACKING. THE. LIST. MULTIPLE. TIMES?
	var/stupid_fucking_shim = list2params(params)

	// todo: refactor
	if(resolve_attackby(target, user, stupid_fucking_shim))
		return CLICKCHAIN_DO_NOT_PROPAGATE

	// todo: signal for afterattack here & anywhere that calls afterattack
	afterattack(target, user, clickchain_flags & CLICKCHAIN_HAS_PROXIMITY, stupid_fucking_shim)

/**
 * Called when trying to click something that the user can't Reachability() to.
 *
 * @params
 * - target - thing hitting
 * - user - user using us
 * - clickchain_flags - see [code/__DEFINES/procs/clickcode.dm]
 * - params - params as list.
 */
/obj/item/proc/ranged_attack_chain(atom/target, mob/user, clickchain_flags, params)
	. = clickchain_flags

	// todo: NO. MORE. LIST. PARAMS. WHY. ARE. WE. UNPACKING. THE. LIST. MULTIPLE. TIMES?
	var/stupid_fucking_shim = list2params(params)

	// todo: signal for afterattack here & anywhere that calls afterattack
	afterattack(target, user, clickchain_flags & CLICKCHAIN_HAS_PROXIMITY, stupid_fucking_shim)

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
 * * A - atom being attacked
 * * user - person attacking
 * * clickchain_flags - __DEFINES/procs/clickcode.dm flags
 * * params - list of click params
 *
 * @return clickchain flags to add, halting the chain if CLICKCHAIN_DO_NOT_PROPAGATE is returned
 */
/obj/item/proc/pre_attack(atom/A, mob/user, clickchain_flags, list/params)
	// todo: signal
	return NONE

/**
 * called when someone hits us with an item while in Reachability() range
 *
 * usually triggers process_object_melee or process_mob_melee
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
 * standard proc for engaging a target in melee
 *
 * @params
 * * A - atom being attacked
 * * user - person attacking
 * * clickchain_flags - __DEFINES/procs/clickcode.dm flags
 * * params - list of click params
 * * mult - damage/force multiplier
 * * target_zone - zone to target
 * * intent - action intent to use
 */
/obj/item/proc/standard_melee_attack(atom/A, mob/user, clickchain_flags, list/params, mult = 1, target_zone = user?.zone_zel?.selecting, intent = user?.a_intent)
	if(item_flags & ITEM_NOBLUDGEON)
		return NONE
	// is mob, go to that
	// todo: signals for both
	if(ismob(A))
		. |= process_mob_melee(A, user, clickchain_flags, params, mult, target_zone, intent)
		if(. & CLICKCHAIN_DO_NOT_PROPAGATE)
			return
		return . | finalize_mob_melee(A, user, . | clickchain_flags, params, mult, target_zone, intent)
	// is obj, go to that
	. = process_object_melee(A, user, clickchain_flags, params, mult)
	if(. & CLICKCHAIN_DO_NOT_PROPAGATE)
		return
	return . | finalize_object_melee(A, user, . | clickchain_flags, params, mult)

/**
 * called when we're used to attack a mob
 *
 * @params
 * * A - atom being attacked
 * * user - person attacking
 * * clickchain_flags - __DEFINES/procs/clickcode.dm flags
 * * params - list of click params
 * * mult - damage/force multiplier
 * * target_zone - zone to target
 * * intent - action intent to use
 *
 * @return clickchain flags to append
 */
/obj/item/proc/process_mob_melee(mob/M, mob/user, clickchain_flags, list/params, mult = 1, target_zone = user?.zone_sel?.selecting, intent = user?.a_intent)
	PROTECTED_PROC(TRUE)	// route via standard_melee_attack please.
	//! legacy: for now no attacking nonliving
	if(!isliving(M))
		return
	var/mob/living/L = M
	// if it's harmless, smack 'em anyways
	if(!force)
		// todo: proper weapon sound ranges/rework
		playsound(src, 'sound/weapons/tap.ogg', 50, 1, -1)
		// feedback
		user.visible_message(SPAN_WARNING("[user] harmlessly taps [L] with [src]."))
		user.do_attack_animation(L)
		// todo: clickcd rework
		user.setClickCooldown(user.get_attack_speed(src))
		return NONE
	// check intent
	if(user == L)
		if(user.a_intent != INTENT_HARM)
			user.action_feedback(SPAN_WARNING("You refrain from hitting yourself with [src], as your intent is not set to harm."), src)
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
		add_attack_logs(user, L, "missed with [src] DT [damtype] F [force] I [user.a_intent]")
		return melee_mob_miss(L, user, clickchain_flags, params, mult, target_zone, intent)
	// log
	add_attack_logs(user, L, "attacked with [src] DT [damtype] F [force] I [user.a_intent]")
	// hit
	return melee_mob_hit(L, user, clickchain_flags, params, mult, target_zone, intent)



#warn kill this
//Called when a weapon is used to make a successful melee attack on a mob. Returns the blocked result
/obj/item/proc/apply_hit_effect(mob/living/target, mob/living/user, var/hit_zone, attack_modifier = 1)

/**
 * called at base of process_mob_melee after standard melee attack misses
 *
 * @return clickchain flags to append
 *
 * @params
 * * A - atom being attacked
 * * user - person attacking
 * * clickchain_flags - __DEFINES/procs/clickcode.dm flags
 * * params - list of click params
 * * mult - damage multiplier that would have been used
 * * target_zone - zone that user tried to target
 * * intent - action intent that was attempted
 */
/obj/item/proc/melee_mob_miss(mob/M, mob/user, clickchain_flags, list/params, mult = 1, target_zone = user?.zone_sel?.selecting, intent = user?.a_intent)
	//! legacy: decloak
	user.break_cloak()
	//! legacy: for now no attacking nonliving
	if(!isliving(M))
		return
	var/mob/living/L = M
	// todo: proper weapon sound ranges/rework
	playsound(src, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
	// feedback
	visible_message("<span class='danger'>\The [user] misses [L] with \the [src]!</span>")
	return NONE

/**
 * called at base of process_mob_melee after standard melee attack resolves
 *
 * @return clickchain flags to append
 *
 * @params
 * * A - atom being attacked
 * * user - person attacking
 * * clickchain_flags - __DEFINES/procs/clickcode.dm flags
 * * params - list of click params
 * * mult - damage/force multiplier
 * * target_zone - zone to target
 * * intent - action intent to use
 */
/obj/item/proc/melee_mob_hit(mob/M, mob/user, clickchain_flags, list/params, mult = 1, target_zone = user?.zone_sel?.selecting, intent = user?.a_intent)
	SHOULD_CALL_PARENT(TRUE)
	//! legacy: decloak
	user.break_cloak()
	//! legacy: for now no attacking nonliving
	if(!isliving(M))
		return
	var/mob/living/L = M
	// todo: proper weapon sound ranges/rework
	if(hitsound)
		playsound(src, hitsound, 50, 1, -1)
	// feedback
	visible_message(SPAN_DANGER("[L] has been [length(attack_verb)? pick(attack_verb) : attack_verb] with [src] by [user]!"))

	//! legacy code start
	var/power = force
	if(isliving(user))
		var/mob/living/attacker = user
		for(var/datum/modifier/L in attacker.modifiers)
			if(!isnull(L.outgoing_melee_damage_percent))
				power *= L.outgoing_melee_damage_percent
	if(MUTATION_HULK in user.mutations)
		power *= 2
	power *= mult
	L.hit_with_weapon(src, user, power, target_zone)
	//! legacy code end

	return NONE

/**
 * called after process_mob_melee, regardless of if standard handling is done
 * this is currently called even if the attacker missed!
 *
 * @params
 * * A - atom being attacked
 * * user - person attacking
 * * clickchain_flags - __DEFINES/procs/clickcode.dm flags
 * * params - list of click params
 * * mult - damage/force multiplier
 * * target_zone - zone to target
 * * intent - action intent to use
 *
 * @return clickchain flags to append
 */
/obj/item/proc/finalize_mob_melee(mob/M, mob/user, clickchain_flags, list/params, mult = 1, target_zone = user?.zone_sel?.selecting, intent = user?.a_intent)
	return NONE

/**
 * called when we're used to attack a non-mob
 * this doesn't actually need to be an obj.
 *
 * @params
 * * A - atom being attacked
 * * user - person attacking
 * * clickchain_flags - __DEFINES/procs/clickcode.dm flags
 * * params - list of click params
 *
 * @return clickchain flags to append
 */
/obj/item/proc/process_object_melee(atom/A, mob/user, clickchain_flags, list/params)
	PROTECTED_PROC(TRUE)	// route via standard_melee_attack please.
	if(user.a_intent != INTENT_HARM)
		user.action_feedback(SPAN_WARNING("You refrain from hitting [A] because your intent is not set to harm."), src)
		return
	// sorry, no atom damage
	// ... yet >:)
	visible_message(SPAN_WARNING("[user] bashes [A] with [src]."))
	return melee_object_hit(A, user, clickchain_flags, params)

/**
 * called at base of process_object_melee after standard melee attack resolves
 *
 * @return clickchain flags to append
 *
 * @params
 * * A - atom being attacked
 * * user - person attacking
 * * clickchain_flags - __DEFINES/procs/clickcode.dm flags
 * * params - list of click params
 */
/obj/item/proc/melee_object_hit(atom/A, mob/user, clickchain_flags, list/params)
	SHOULD_CALL_PARENT(TRUE)
	return NONE

/**
 * called after process_object_melee, regardless of if standard handling is done
 * this is currently called even if the attacker missed!
 *
 * @params
 * * A - atom being attacked
 * * user - person attacking
 * * clickchain_flags - __DEFINES/procs/clickcode.dm flags
 * * params - list of click params
 * * mult - damage multiplier
 *
 * @return clickchain flags to append
 */
/obj/item/proc/finalize_object_melee(atom/A, mob/user, clickchain_flags, list/params, mult = 1)
	return NONE

#warn process melee hit instead of this (?)
