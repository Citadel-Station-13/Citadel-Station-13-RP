//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * * The weird proc args is because this technically supports non-clickchain use.
 *
 * @return clickchain flags
 */
/obj/item/gun/projectile/ballistic/proc/user_clickchain_apply_magazine(obj/item/ammo_magazine/magazine, datum/event_args/actor/actor, datum/event_args/actor/clickchain/clickchain, no_sound, no_message)

/**
 * * The weird proc args is because this technically supports non-clickchain use.
 *
 * @return clickchain flags
 */
/obj/item/gun/projectile/ballistic/proc/user_clickchain_apply_casing(obj/item/ammo_casing/casing, datum/event_args/actor/actor, datum/event_args/actor/clickchain/clickchain, no_sound, no_message)

#warn impl all

/**
 * * The weird proc args is because this technically supports non-clickchain use.
 *
 * @return clickchain flags
 */
/obj/item/gun/projectile/ballistic/proc/user_clickchain_unload(datum/event_args/actor/actor, datum/event_args/actor/clickchain/clickchain, no_sound, no_message)
	if(magazine)
		return user_clickchain_unload_magazine(actor, clickchain, no_sound, no_message)
	return user_clickchain_unload_ammo(actor, clickchain, no_sound, no_message)

/**
 * * The weird proc args is because this technically supports non-clickchain use.
 *
 * @return clickchain flags
 */
/obj/item/gun/projectile/ballistic/proc/user_clickchain_unload_ammo(datum/event_args/actor/actor, datum/event_args/actor/clickchain/clickchain, no_sound, no_message)
	var/obj/item/ammo_casing/unloaded = remove_casing(null, no_soud)
	if(!unloaded)
		return NONE
	if(clickchain)
		clickchain.performer.put_in_hands_or_drop(unloaded)
	else
		unloaded.forceMove(drop_location())
	if(!no_message)
		actor?.visible_feedback(
			target = src,
			range = MESSAGE_RANGE_INVENTORY_SOFT,
			visible = "[actor.performer] removes [unlaoded] from [src].",
			otherwise_self = SPAN_NOTICE("You remove [unloaded] from [src]."),
		)
	return CLICKCHAIN_DID_SOMETHING

/**
 * * The weird proc args is because this technically supports non-clickchain use.
 *
 * @return clickchain flags
 */
/obj/item/gun/projectile/ballistic/proc/user_clickchain_unload_magazine(datum/event_args/actor/actor, datum/event_args/actor/clickchain/clickchain, no_sound, no_message)
	var/obj/item/ammo_magazine/unloaded = remove_magazine(null, no_sound)
	if(!unloaded)
		return NONE
	if(clickchain)
		clickchain.performer.put_in_hands_or_drop(unloaded)
	else
		unloaded.forceMove(drop_location())
	if(!no_message)
		actor?.visible_feedback(
			target = src,
			range = MESSAGE_RANGE_INVENTORY_SOFT,
			visible = "[actor.performer] removes [unlaoded] from [src].",
			otherwise_self = SPAN_NOTICE("You remove [unloaded] from [src]."),
		)
	return CLICKCHAIN_DID_SOMETHING

/**
 * * The weird proc args is because this technically supports non-clickchain use.
 *
 * @return clickchain flags
 */
/obj/item/gun/projectile/ballistic/proc/user_clickchain_unload_chamber(datum/event_args/actor/actor, datum/event_args/actor/clickchain/clickchain, no_sound, no_message)
	var/obj/item/ammo_casing/unloaded = eject_chamber(no_sound)
	if(!unloaded)
		return NONE
	if(clickchain)
		clickchain.performer.put_in_hands_or_drop(unloaded)
	else
		unloaded.forceMove(drop_location())
	if(!no_message)
		actor?.visible_feedback(
			target = src,
			range = MESSAGE_RANGE_INVENTORY_SOFT,
			visible = "[actor.performer] removes [unlaoded] from [src].",
			otherwise_self = SPAN_NOTICE("You remove [unloaded] from [src]."),
		)
	return CLICKCHAIN_DID_SOMETHING
