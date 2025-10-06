//* If you change any of these procs, you better find/replace *every single* proc signature to match
//* Obviously you don't need to do this for default arguments, because that'd insert a lot of compiled in isnull()'s
//* But the whole point of this refactor is to standardize.
//* All PRs that breach convention will be held until in compliance.

//? Click-Chain system - using an item in hand to "attack", whether in melee or ranged.

/obj/item/proc/lazy_melee_interaction_chain(atom/target, mob/user, clickchain_flags, list/click_params)
	var/datum/event_args/actor/clickchain/clickchain = new
	clickchain.performer = clickchain.initiator = user
	clickchain.using_intent = user.a_intent
	clickchain.click_params = click_params || list()
	clickchain.target = target
	clickchain.target_zone = user.zone_sel?.selecting || BP_TORSO
	return melee_interaction_chain(clickchain, clickchain_flags)

/**
 * Called when trying to click something that the user can Reachability() to.
 *
 * @params
 * * clickchain - clickchain data
 * * clickchain_flags - see [code/__DEFINES/procs/clickcode.dm]
 */
/obj/item/proc/melee_interaction_chain(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	// wow we have a lot of params
	// if only this was ss14 so we could have the EntityEventArgs :pleading:

	. = clickchain_flags
	if(!(. & CLICKCHAIN_FLAGS_INTERACT_ABORT) && ((. |= item_attack_chain(clickchain, .)) & CLICKCHAIN_DO_NOT_PROPAGATE))
		return

	if(!(. & CLICKCHAIN_FLAGS_INTERACT_ABORT) && ((. |= tool_attack_chain(clickchain, .)) & CLICKCHAIN_DO_NOT_PROPAGATE))
		return

	// todo: is pre_attack really needed/justified?
	if(!(. & (CLICKCHAIN_FLAGS_INTERACT_ABORT | CLICKCHAIN_FLAGS_ATTACK_ABORT)) && ((. |= pre_attack(clickchain.target, clickchain.performer, ., clickchain.click_params)) & CLICKCHAIN_DO_NOT_PROPAGATE))
		return

	// todo: refactor
	// todo: this should all be split into:
	// - item use & receive item use (item_interaction() on /atom, definiteily)
	// - tool use & receive tool use (we already have tool_interaction() on /atom)
	// - melee attack & receive melee attack (melee_interaction() on /atom? not item_melee_act directly?)
	// - melee attack shouldn't require attackby() to allow it to, it should be automatic on harm intent (?)
	// - the item should have final say but we need a way to allow click redirections so..
	if(!(. & CLICKCHAIN_FLAGS_INTERACT_ABORT) && ((. |= resolve_attackby(clickchain.target, clickchain.performer, clickchain.click_params, null, ., clickchain)) & CLICKCHAIN_DO_NOT_PROPAGATE))
		return

	// todo: signal for afterattack here
	var/result = afterattack(clickchain.target, clickchain.performer, clickchain_flags, clickchain.click_params)
	if(result)
		clickchain.performer.trigger_aiming(TARGET_CAN_CLICK)
	return . | result

// TODO: lazy_ranged_interaction_chain

/**
 * Called when trying to click something that the user can't Reachability() to.
 *
 * @params
 * * clickchain - clickchain data
 * * clickchain_flags - see [code/__DEFINES/procs/clickcode.dm]
 */
/obj/item/proc/ranged_interaction_chain(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	// todo: signal for afterattack here
	. = afterattack(clickchain.target, clickchain.performer, clickchain_flags, clickchain.click_params)
	if(.)
		clickchain.performer.trigger_aiming(TARGET_CAN_CLICK)
	return clickchain_flags | .

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
