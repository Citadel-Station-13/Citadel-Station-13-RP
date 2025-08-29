//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Called to initiate a usage as item.
 *
 * * Called before tool_attack_chain()
 * * Called before melee_attack_chain()
 *
 * @params
 * * clickchain - the clickchain data, including who's doing the interaction
 * * clickchain_flags - the clickchain flags given
 *
 * @return CLICKCHAIN_* flags. These are added / interpreted by the caller.
 */
/obj/item/proc/item_attack_chain(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	SHOULD_NOT_OVERRIDE(TRUE)

	. = clickchain_flags

	. |= SEND_SIGNAL(src, COMSIG_ITEM_USING_AS_ITEM, clickchain, clickchain_flags)
	if(. & CLICKCHAIN_DO_NOT_PROPAGATE)
		return
	. |= using_as_item(clickchain.target, clickchain, clickchain_flags)
	if(. & CLICKCHAIN_DO_NOT_PROPAGATE)
		return

	. |= SEND_SIGNAL(clickchain.target, COMSIG_ATOM_USING_ITEM_ON, src, clickchain, clickchain_flags)
	if(. & CLICKCHAIN_DO_NOT_PROPAGATE)
		return
	. |= clickchain.target.using_item_on(src, clickchain, clickchain_flags)
	if(. & CLICKCHAIN_DO_NOT_PROPAGATE)
		return

/**
 * Called when being used as an item.
 *
 * * If handled, return CLICKCHAIN_DO_NOT_PROPAGATE
 *
 * @params
 * * target - thing we're being used on; use this target, do not resolve from clickchain.target!
 * * clickchain - the clickchain data, including who's doing the interaction
 * * clickchain_flags - the clickchain flags given
 *
 * @return CLICKCHAIN_* flags. These are added / interpreted by the caller.
 */
/obj/item/proc/using_as_item(atom/target, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	return NONE

/**
 * Called when an item is being used on us as an item.
 *
 * * If handled, return CLICKCHAIN_DO_NOT_PROPAGATE
 * * item's `item_attack_chain`, and then `used_as_item` are called first.
 *
 * @params
 * * using - the item; use this item, do not resolve from clickchain.using_item!
 * * clickchain - the clickchain data, including who's doing the interaction
 * * clickchain_flags - the clickchain flags given
 *
 * @return CLICKCHAIN_* flags. These are added / interpreted by the caller.
 */
/atom/proc/using_item_on(obj/item/using, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	return NONE
