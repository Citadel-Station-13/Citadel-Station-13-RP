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
 * usually triggers attack_obj or attack_mob
 *
 * @params
 * * I - item being used to use/attack us in melee
 * * user - person attacking
 * * clickchain_flags - __DEFINES/procs/clickcode.dm flags
 * * params - list of click params
 *
 * @return clickchain flags to append
 */
/atom/movable/attackby(obj/item/I, mob/user, clickchain_flags, list/params)

/**
 * called when we're used to attack a mob
 *
 * @params
 * * A - atom being attacked
 * * user - person attacking
 * * clickchain_flags - __DEFINES/procs/clickcode.dm flags
 * * params - list of click params
 *
 * @return clickchain flags to append
 */
/obj/item/proc/attack_mob(mob/M, mob/user, clickchain_flags, list/params)
	// todo: signal - is here even the right place? maybe doing it on calling proc is better?
	#warn impl

/**
 * called at base of attack mob for a standard melee hit
 *
 * @params
 * * M - mob being attacked
 * * user - person attacking
 * * clickchain_flags - __DEFINES/procs/clickcode.dm flags
 * * params - list of click params
 * * mult - damage multiplier
 *
 * @return clickchain flags to append
 */
/obj/item/proc/standard_mob_melee(mob/M, mob/user, clickchain_flags, list/params, mult = 1)
	#warn impl

/**
 * called after a standard melee hit
 *
 * @params
 * * M - M being attacked
 * * user - person attacking
 * * clickchain_flags - __DEFINES/procs/clickcode.dm flags
 * * params - list of click params
 * * mult - damage multiplier
 *
 * @return clickchain flags to append
 */
/obj/item/proc/post_mob_melee(mob/M, mob/user, clickchain_flags, list/params, mult = 1)
	#warn impl

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
/obj/item/proc/attack_obj(atom/A, mob/user, clickchain_flags, list/params)
	// todo: signal - is here even the right place? maybe doing it on calling proc is better?
	#warn impl - oh and check user intent

/**
 * called at base of attack obj for a standard melee hit
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
/obj/item/proc/standard_obj_melee(mob/M, mob/user, clickchain_flags, list/params, mult = 1)
	#warn impl

/**
 * called after a standard melee hit
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
/obj/item/proc/post_obj_melee(mob/M, mob/user, clickchain_flags, list/params, mult = 1)
	#warn impl
