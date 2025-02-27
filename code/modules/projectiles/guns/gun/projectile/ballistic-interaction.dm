//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * * The weird proc args is because this technically supports non-clickchain use.
 *
 * @return clickchain flags
 */
/obj/item/gun/projectile/ballistic/proc/user_clickchain_apply_magazine(obj/item/ammo_magazine/magazine, datum/event_args/actor/actor, datum/event_args/actor/clickchain/clickchain, no_sound, no_message)
	if(internal_magazine)
		if(!no_message)
			actor?.chat_feedback(
				SPAN_WARNING("[src] doesn't accept magazines."),
				target = src,
			)
		return CLICKCHAIN_DID_SOMETHING
	if(!accepts_magazine(magazine))
		if(!no_message)
			actor?.chat_feedback(
				SPAN_WARNING("[magazine] cannot fit in [src]."),
				target = src,
			)
		return CLICKCHAIN_DID_SOMETHING
	if(magazine)
		if(interact_allow_tactical_reload)
			switch(clickchain.using_intent)
				if(INTENT_GRAB)
					#warn handle tac reload
				if(INTENT_HARM)
					#warn handle tac reload
		if(!magazine)
			if(!no_message)
				actor?.chat_feedback(
					SPAN_WARNING("[src] already has a magazine inserted."),
					target = src,
				)
			return CLICKCHAIN_DID_SOMETHING
	if(clickchain)
		if(!clickchain.performer.attempt_insert_item_for_installation(magazine, src))
			return CLICKCHAIN_DID_SOMETHING
	if(!insert_magazine(magazine))
		magazine.forceMove(drop_location())
		CRASH("failed to insert magazine after point of no return in clickchain interaction")
	if(!no_message)
		actor?.visible_feedback(
			target = src,
			range = MESSAGE_RANGE_INVENTORY_SOFT,
			visible = "[actor.performer] inserts [magazine] into [src].",
			otherwise_self = SPAN_NOTICE("You insert [magazine] into [src]."),
		)
	return CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE

/**
 * * The weird proc args is because this technically supports non-clickchain use.
 *
 * @return clickchain flags
 */
/obj/item/gun/projectile/ballistic/proc/user_clickchain_apply_casing(obj/item/ammo_casing/casing, datum/event_args/actor/actor, datum/event_args/actor/clickchain/clickchain, no_sound, no_message)
	#warn impl

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
