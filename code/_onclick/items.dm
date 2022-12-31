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
		. |= attack_mob(A, user, clickchain_flags, params, mult, target_zone, intent)
		if(. & CLICKCHAIN_DO_NOT_PROPAGATE)
			return
		return . | attacked_mob(A, user, . | clickchain_flags, params, mult, target_zone, intent)
	// is obj, go to that
	. = attack_object(A, user, clickchain_flags, params, mult)
	if(. & CLICKCHAIN_DO_NOT_PROPAGATE)
		return
	return . | attacked_object(A, user, . | clickchain_flags, params, mult)

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
/obj/item/proc/attack_mob(mob/M, mob/user, clickchain_flags, list/params, mult = 1, target_zone = user?.zone_sel?.selecting, intent = user?.a_intent)
	PROTECTED_PROC(TRUE)	// route via standard_melee_attack please.
	// if it's harmless, smack 'em anyways

	#warn impl - oh and check user intent oh and make message even if it's harmless
	#warn apply_melee_effects - generic - DO NOT USE ATTACKED

//I would prefer to rename this attack_as_weapon(), but that would involve touching hundreds of files.
#warn kill this
/obj/item/proc/attack(mob/living/M, mob/living/user, var/target_zone, var/attack_modifier)
	if(!force)
		playsound(src, 'sound/weapons/tap.ogg', 50, 1, -1)
		user.do_attack_animation(M)
		return 0
	if(M == user && user.a_intent != INTENT_HARM)
		return 0

	/////////////////////////
	user.lastattacked = M
	M.lastattacker = user

	if(!no_attack_log)
		add_attack_logs(user,M,"attacked with [name] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(damtype)])")
	/////////////////////////

	user.setClickCooldown(user.get_attack_speed(src))
	user.do_attack_animation(M)

	var/hit_zone = M.resolve_item_attack(src, user, target_zone)
	if(hit_zone)
		apply_hit_effect(M, user, hit_zone, attack_modifier)

	return 1

#warn kill this
//Called when a weapon is used to make a successful melee attack on a mob. Returns the blocked result
/obj/item/proc/apply_hit_effect(mob/living/target, mob/living/user, var/hit_zone, attack_modifier = 1)
	user.break_cloak()
	if(hitsound)
		playsound(loc, hitsound, 50, 1, -1)

	var/power = force
	for(var/datum/modifier/M in user.modifiers)
		if(!isnull(M.outgoing_melee_damage_percent))
			power *= M.outgoing_melee_damage_percent

	if(MUTATION_HULK in user.mutations)
		power *= 2

	power *= attack_modifier

	return target.hit_with_weapon(src, user, power, hit_zone)

/**
 * called at base of attack_mob after standard melee attack resolves
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
/obj/item/proc/attack_mob_effects(mob/M, mob/user, clickchain_flags, list/params, mult = 1, target_zone = user?.zone_sel?.selecting, intent = user?.a_intent)
	SHOULD_CALL_PARENT(TRUE)
	return NONE

/**
 * called after attack_mob, regardless of if standard handling is done
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
/obj/item/proc/attacked_mob(mob/M, mob/user, clickchain_flags, list/params, mult = 1, target_zone = user?.zone_sel?.selecting, intent = user?.a_intent)
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
/obj/item/proc/attack_object(atom/A, mob/user, clickchain_flags, list/params)
	PROTECTED_PROC(TRUE)	// route via standard_melee_attack please.
	if(user.a_intent != INTENT_HARM)
		user.action_feedback(SPAN_WARNING("You refrain from hitting [A] because your intent is not set to harm."), src)
		return
	// sorry, no atom damage
	// ... yet >:)
	visible_message(SPAN_WARNING("[user] bashes [A] with [src]."))
	return attack_object_effects(A, user, clickchain_flags, params)

/**
 * called at base of attack_object after standard melee attack resolves
 *
 * @return clickchain flags to append
 *
 * @params
 * * A - atom being attacked
 * * user - person attacking
 * * clickchain_flags - __DEFINES/procs/clickcode.dm flags
 * * params - list of click params
 */
/obj/item/proc/attack_object_effects(atom/A, mob/user, clickchain_flags, list/params)
	SHOULD_CALL_PARENT(TRUE)
	return NONE

/**
 * called after attack_object, regardless of if standard handling is done
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
/obj/item/proc/attacked_object(atom/A, mob/user, clickchain_flags, list/params, mult = 1)
	return NONE

#warn process melee hit instead of this (?)
