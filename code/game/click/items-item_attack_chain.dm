//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Code for interacting as an item. *//

/**
 * Called to initiate a usage as item.
 *
 * * Called before tool_attack_chain()
 * * Called before melee_attack_chain()
 *
 * @params
 * * target - thing we're being used on
 * * e_args - the clickchain data, including who's doing the interaction
 * * clickchain_flags - the clickchain flags given
 * * reachability_check - a callback used for reachability checks. if none, defaults to mob.Reachability when in clickcode, can always reach otherwise.
 *
 * @return CLICKCHAIN_* flags. These are added / interpreted the caller.
 */
/obj/item/proc/item_attack_chain(atom/target, datum/event_args/actor/clickchain/e_args, clickchain_flags, datum/callback/reachability_check)
	SHOULD_NOT_OVERRIDE(TRUE)

	. = clickchain_flags

	. |= SEND_SIGNAL(src, COMSIG_ITEM_USING_AS_ITEM, target, e_args, clickchain_flags, reachability_check)
	if(. & CLICKCHAIN_DO_NOT_PROPAGATE)
		return
	. |= using_as_item(target, e_args, clickchain_flags, reachability_check)
	if(. & CLICKCHAIN_DO_NOT_PROPAGATE)
		return

	. |= SEND_SIGNAL(src, COMSIG_ATOM_USING_ITEM_ON, src, e_args, clickchain_flags, reachability_check)
	if(. & CLICKCHAIN_DO_NOT_PROPAGATE)
		return
	. |= target.using_item_on(src, e_args, clickchain_flags, reachability_check)
	if(. & CLICKCHAIN_DO_NOT_PROPAGATE)
		return

/**
 * Called when being used as an item.
 *
 * * If handled, return CLICKCHAIN_DO_NOT_PROPAGATE
 *
 * @params
 * * target - thing we're being used on
 * * e_args - the clickchain data, including who's doing the interaction
 * * clickchain_flags - the clickchain flags given
 * * reachability_check - a callback used for reachability checks. if none, defaults to mob.Reachability when in clickcode, can always reach otherwise.
 *
 * @return CLICKCHAIN_* flags. These are added / interpreted by the caller.
 */
/obj/item/proc/using_as_item(atom/target, datum/event_args/actor/clickchain/e_args, clickchain_flags, datum/callback/reachability_check)
	return NONE

/**
 * Called when an item is being used on us as an item.
 *
 * * If handled, return CLICKCHAIN_DO_NOT_PROPAGATE
 * * item's `item_attack_chain`, and then `used_as_item` are called first.
 *
 * @params
 * * using - the item
 * * e_args - the clickchain data, including who's doing the interaction
 * * clickchain_flags - the clickchain flags given
 * * reachability_check - a callback used for reachability checks. if none, defaults to mob.Reachability when in clickcode, can always reach otherwise.
 *
 * @return CLICKCHAIN_* flags. These are added / interpreted by the caller.
 */
/atom/proc/using_item_on(obj/item/using, datum/event_args/actor/clickchain/e_args, clickchain_flags, datum/callback/reachability_check)
	return NONE
