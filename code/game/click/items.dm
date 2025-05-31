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
	// todo: this should be not overridable but it's not right now for indirection handling. we should just have
	//       an alternative indirection proc.
	// SHOULD_NOT_OVERRIDE(TRUE)

	// wow we have a lot of params
	// if only this was ss14 so we could have the EntityEventArgs :pleading:

	. = clickchain_flags

	var/datum/event_args/actor/clickchain/e_args = new(user)
	e_args.target = target
	e_args.click_params = params

	if(!(. & CLICKCHAIN_FLAGS_INTERACT_ABORT) && ((. |= item_attack_chain(e_args, .)) & CLICKCHAIN_DO_NOT_PROPAGATE))
		return

	// todo: should only have e_args and clickchain_flags as params.
	if(!(. & CLICKCHAIN_FLAGS_INTERACT_ABORT) && ((. |= tool_attack_chain(target, user, ., params)) & CLICKCHAIN_DO_NOT_PROPAGATE))
		return

	// todo: is pre_attack really needed/justified?
	if(!(. & (CLICKCHAIN_FLAGS_INTERACT_ABORT | CLICKCHAIN_FLAGS_ATTACK_ABORT)) && ((. |= pre_attack(target, user, ., params)) & CLICKCHAIN_DO_NOT_PROPAGATE))
		return

	// todo: refactor
	// todo: this should all be split into:
	// - item use & receive item use (item_interaction() on /atom, definiteily)
	// - tool use & receive tool use (we already have tool_interaction() on /atom)
	// - melee attack & receive melee attack (melee_interaction() on /atom? not item_melee_act directly?)
	// - melee attack shouldn't require attackby() to allow it to, it should be automatic on harm intent (?)
	// - the item should have final say but we need a way to allow click redirections so..
	if(!(. & CLICKCHAIN_FLAGS_INTERACT_ABORT) && ((. |= resolve_attackby(target, user, params, null, ., e_args)) & CLICKCHAIN_DO_NOT_PROPAGATE))
		return

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
