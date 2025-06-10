//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/item/gun/projectile/ballistic/should_unique_action_rack_chamber()
	return chamber_simulation

/obj/item/gun/projectile/ballistic/auto_inhand_rack_chamber(datum/event_args/actor/e_args)
	return user_clickchain_cycle_chamber(e_args)

/**
 * * The weird proc args is because this supports non-clickchain use.
 *
 * @params
 * * actor - actor data
 * * clickchain - (optional) clickchain did, if from clickchain
 * * no_sound - suppress default sounds
 * * no_message - suppress default messages
 *
 * @return clickchain flags
 */
/obj/item/gun/projectile/ballistic/proc/user_clickchain_cycle_chamber(datum/event_args/actor/actor, datum/event_args/actor/clickchain/clickchain, no_sound, no_message)
	if(!chamber_simulation)
		return NONE
	if(!chamber_manual_cycle)
		return NONE
	if(bolt_simulation)
		if(!COOLDOWN_FINISHED(src, CD_INDEX_GUN_BOLT_ACTION))
			return CLICKCHAIN_DID_SOMETHING
		COOLDOWN_START(src, CD_INDEX_GUN_BOLT_ACTION, bolt_cooldown)
		if(bolt_closed)
			open_bolt()
			if(!no_message)
				actor.visible_feedback(
					target = src,
					visible = SPAN_WARNING("[actor.performer] slides [src]'s bolt back."),
					otherwise_self = SPAN_WARNING("You slide [src]'s bolt back."),
				)
		else
			close_bolt()
			if(!no_message)
				actor.visible_feedback(
					target = src,
					visible = SPAN_WARNING("[actor.performer] slides [src]'s bolt forwards."),
					otherwise_self = SPAN_WARNING("You slide [src]'s bolt forwards."),
				)
	else
		if(!COOLDOWN_FINISHED(src, CD_INDEX_GUN_RACK_CHAMBER))
			return CLICKCHAIN_DID_SOMETHING
		COOLDOWN_START(src, CD_INDEX_GUN_RACK_CHAMBER, chamber_manual_cycle_cooldown)
		cycle_chamber()
		if(!no_message)
			actor.visible_feedback(
				target = src,
				visible = SPAN_WARNING("[actor.performer] racks [src]'s slide."),
				otherwise_self = SPAN_WARNING("You rack [src]'s slide."),
			)
	update_icon()
	return CLICKCHAIN_DID_SOMETHING

/**
 * * The weird proc args is because this supports non-clickchain use.
 *
 * @params
 * * magazine - the magazine
 * * actor - actor data
 * * clickchain - (optional) clickchain did, if from clickchain
 * * no_sound - suppress default sounds
 * * no_message - suppress default messages
 *
 * @return clickchain flags
 */
/obj/item/gun/projectile/ballistic/proc/user_clickchain_apply_magazine(obj/item/ammo_magazine/magazine, datum/event_args/actor/actor, datum/event_args/actor/clickchain/clickchain, no_sound, no_message)
	if(internal_magazine)
		// check for speedloader accept before overriding default behavior,
		// unless default behavior allows speedloader-type'd magazines anyways
		if(speedloader_allowed && (magazine.magazine_type & MAGAZINE_TYPE_SPEEDLOADER) && (accepts_speedloader(magazine) || !(magazine.magazine_type & magazine_type)))
			return user_clickchain_speedload_from_magazine(magazine, actor, clickchain, no_sound, no_message)
		// clip just always runs unless gun accepts it as magazine
		else if((magazine.magazine_type & MAGAZINE_TYPE_CLIP) && !accepts_magazine(magazine))
			return user_clickchain_load_from_magazine(magazine, actor, clickchain, no_sound, no_message)
	if(magazine.magazine_type & magazine_type)
		return user_clickchain_insert_magazine(magazine, actor, clickchain, no_sound, no_message)

/obj/item/gun/projectile/ballistic/proc/user_clickchain_speedload_from_magazine(obj/item/ammo_magazine/magazine, datum/event_args/actor/actor, datum/event_args/actor/clickchain/clickchain, no_sound, no_message)
	if(!internal_magazine)
		return CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE

	if(!accepts_speedloader(magazine))
		if(!no_message)
			actor.chat_feedback(
				SPAN_WARNING("[magazine] doesn't fit [src] for speedloading."),
				target = src,
			)
		return CLICKCHAIN_DID_SOMETHING

	if(bolt_simulation && bolt_closed && bolt_blocks_internal_magazine)
		if(!no_message)
			actor.chat_feedback(
				SPAN_WARNING("[src]'s bolt must be open to access its internal magazine."),
				target = src,
			)
		return CLICKCHAIN_DID_SOMETHING

	if(is_internal_magazine_full())
		if(!no_message)
			actor?.chat_feedback(
				SPAN_WARNING("[src] is full!"),
				target = src,
			)
		return CLICKCHAIN_DID_SOMETHING
	if(!magazine.get_amount_remaining())
		if(!no_message)
			actor?.chat_feedback(
				SPAN_WARNING("[magazine] is empty!"),
				target = src,
			)
		return CLICKCHAIN_DID_SOMETHING

	if(!do_after(actor.performer, speedloader_delay + magazine.speedloader_delay, src, mobility_flags = MOBILITY_CAN_USE))
		return CLICKCHAIN_DID_SOMETHING

	var/loaded = insert_speedloader(magazine, no_sound)

	if(!no_message)
		if(loaded)
			actor.visible_feedback(
				target = src,
				range = MESSAGE_RANGE_INVENTORY_SOFT,
				visible = SPAN_NOTICE("[actor.performer] reloads [src] with [magazine]."),
				otherwise_self = SPAN_NOTICE("You load [loaded] rounds from [magazine] into [src]."),
			)
		else
			actor.chat_feedback(
				SPAN_WARNING("You fail to load any rounds from [magazine] into [src]."),
				target = src,
			)

	return CLICKCHAIN_DID_SOMETHING

/obj/item/gun/projectile/ballistic/proc/user_clickchain_load_from_magazine(obj/item/ammo_magazine/magazine, datum/event_args/actor/actor, datum/event_args/actor/clickchain/clickchain, no_sound, no_message)
	if(!internal_magazine)
		return CLICKCHAIN_DID_SOMETHING

	if(bolt_simulation && bolt_closed && bolt_blocks_internal_magazine)
		if(!no_message)
			actor.chat_feedback(
				SPAN_WARNING("[src]'s bolt must be open to access its internal magazine."),
				target = src,
			)
		return CLICKCHAIN_DID_SOMETHING

	if(is_internal_magazine_full())
		if(!no_message)
			actor.chat_feedback(
				SPAN_WARNING("[src] is full!"),
				target = src,
			)
		return CLICKCHAIN_DID_SOMETHING

	if(!magazine.get_amount_remaining())
		if(!no_message)
			actor.chat_feedback(
				SPAN_WARNING("[magazine] is empty!"),
				target = src,
			)
		return CLICKCHAIN_DID_SOMETHING

	var/loaded = 0
	var/safety = 100
	do
		if(--safety < 0)
			CRASH("ran out of safety on clip autoload")
		if(!do_after(actor.performer, single_load_delay, src, mobility_flags = MOBILITY_CAN_USE))
			break
		if(bolt_simulation && bolt_closed && bolt_blocks_internal_magazine)
			if(!no_message)
				actor.chat_feedback(
					SPAN_WARNING("[src]'s bolt must be open to access its internal magazine."),
					target = src,
				)
			break
		var/obj/item/ammo_casing/peeking = magazine.peek()
		if(!peeking || !accepts_casing(peeking))
			break
		if(!insert_casing(peeking, no_sound))
			break
		ASSERT(magazine.pop() == peeking)
		loaded++
	while(TRUE)

	if(!no_message)
		if(loaded)
			actor.visible_feedback(
				target = src,
				range = MESSAGE_RANGE_INVENTORY_SOFT,
				visible = SPAN_NOTICE("[actor.performer] loads some rounds into [src] with [magazine]."),
				otherwise_self = SPAN_NOTICE("You load [loaded] rounds from [magazine] into [src]."),
			)
		else
			actor.chat_feedback(
				SPAN_WARNING("You fail to load any rounds from [magazine] into [src]."),
				target = src,
			)

	return CLICKCHAIN_DID_SOMETHING

/obj/item/gun/projectile/ballistic/proc/user_clickchain_insert_magazine(obj/item/ammo_magazine/magazine, datum/event_args/actor/actor, datum/event_args/actor/clickchain/clickchain, no_sound, no_message)
	if(internal_magazine)
		if(!no_message)
			actor.chat_feedback(
				SPAN_WARNING("[src] doesn't accept magazines."),
				target = src,
			)
		return CLICKCHAIN_DID_SOMETHING
	if(!accepts_magazine(magazine))
		if(!no_message)
			actor.chat_feedback(
				SPAN_WARNING("[magazine] cannot fit in [src]."),
				target = src,
			)
		return CLICKCHAIN_DID_SOMETHING
	var/obj/item/ammo_magazine/put_back_in_hand
	var/tactical_reload_append
	if(src.magazine)
		if(interact_allow_tactical_reload && clickchain)
			switch(clickchain.using_intent)
				if(INTENT_GRAB)
					if(do_after(actor.performer, interact_tactical_reload_delay, src, mobility_flags = MOBILITY_CAN_USE))
						put_back_in_hand = remove_magazine(silent = TRUE)
						tactical_reload_append = ", swapping out the old magazine in the process"
					else
						return CLICKCHAIN_DID_SOMETHING
				if(INTENT_HARM)
					if(do_after(actor.performer, interact_tactical_reload_delay, src, mobility_flags = MOBILITY_CAN_USE))
						remove_magazine(drop_location(), silent = TRUE)
						tactical_reload_append = ", dropping the old magazine in the process"
					else
						return CLICKCHAIN_DID_SOMETHING
	if(src.magazine)
		if(!no_message)
			actor.chat_feedback(
				SPAN_WARNING("[src] already has a magazine inserted."),
				target = src,
			)
		put_back_in_hand?.forceMove(drop_location())
		return CLICKCHAIN_DID_SOMETHING
	if(!actor.performer.attempt_insert_item_for_installation(magazine, src))
		put_back_in_hand?.forceMove(drop_location())
		return CLICKCHAIN_DID_SOMETHING
	if(!insert_magazine(magazine))
		magazine.forceMove(drop_location())
		put_back_in_hand?.forceMove(drop_location())
		CRASH("failed to insert magazine after point of no return in clickchain interaction")
	if(!no_message)
		actor.visible_feedback(
			target = src,
			range = MESSAGE_RANGE_INVENTORY_SOFT,
			visible = "[actor.performer] inserts [magazine] into [src][tactical_reload_append].",
			otherwise_self = SPAN_NOTICE("You insert [magazine] into [src][tactical_reload_append]."),
		)
	if(put_back_in_hand)
		if(actor)
			actor.performer.put_in_hands_or_drop(put_back_in_hand)
		else
			put_back_in_hand.forceMove(drop_location())
	return CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE

/**
 * * The weird proc args is because this supports non-clickchain use.
 *
 * @return clickchain flags
 */
/obj/item/gun/projectile/ballistic/proc/user_clickchain_apply_casing(obj/item/ammo_casing/casing, datum/event_args/actor/actor, datum/event_args/actor/clickchain/clickchain, no_sound, no_message)
	if(internal_magazine)
		// todo: better way to handle one-shot guns and internal mags..
		if(!internal_magazine_size)
			return user_clickchain_apply_casing_to_chamber(casing, actor, clickchain, no_sound, no_message)
		return user_clickchain_apply_casing_to_internal_magazine(casing, actor, clickchain, no_sound, no_message)
	else
		return user_clickchain_apply_casing_to_chamber(casing, actor, clickchain, no_sound, no_message)

/**
 * * The weird proc args is because this supports non-clickchain use.
 *
 * @return clickchain flags
 */
/obj/item/gun/projectile/ballistic/proc/user_clickchain_apply_casing_to_internal_magazine(obj/item/ammo_casing/casing, datum/event_args/actor/actor, datum/event_args/actor/clickchain/clickchain, no_sound, no_message)
	if(!internal_magazine)
		if(!no_message)
			actor.chat_feedback(
				SPAN_WARNING("[src] doesn't have an internal magazine."),
				target = src,
			)
		return CLICKCHAIN_DID_SOMETHING
	if(bolt_simulation && bolt_closed && bolt_blocks_internal_magazine)
		if(!no_message)
			actor.chat_feedback(
				SPAN_WARNING("[src]'s bolt must be open to access its internal magazine."),
				target = src,
			)
		return CLICKCHAIN_DID_SOMETHING
	if(!accepts_casing(casing))
		if(!no_message)
			actor.chat_feedback(
				SPAN_WARNING("[casing] doesn't fit into [src]."),
				target = src,
			)
		return CLICKCHAIN_DID_SOMETHING
	if(is_internal_magazine_full())
		if(!no_message)
			actor.chat_feedback(
				SPAN_WARNING("[src]'s internal magazine is full."),
				target = src,
			)
		return CLICKCHAIN_DID_SOMETHING
	if(!actor.performer.attempt_insert_item_for_installation(magazine, src))
		return CLICKCHAIN_DID_SOMETHING
	if(!insert_casing(casing))
		casing.forceMove(drop_location())
		CRASH("failed to insert casing after point of no return in clickchain interaction")
	if(!no_message)
		actor.visible_feedback(
			target = src,
			range = MESSAGE_RANGE_COMBAT_SUBTLE,
			visible = SPAN_NOTICE("[actor.performer] loads a round into [src]."),
			otherwise_self = SPAN_NOTICE("You load [casing] ."),
		)
	return CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE

/**
 * * The weird proc args is because this supports non-clickchain use.
 *
 * @return clickchain flags
 */
/obj/item/gun/projectile/ballistic/proc/user_clickchain_apply_casing_to_chamber(obj/item/ammo_casing/casing, datum/event_args/actor/actor, datum/event_args/actor/clickchain/clickchain, no_sound, no_message)
	if(!chamber_simulation)
		return NONE
	if(chamber)
		if(!no_message)
			actor.chat_feedback(
				SPAN_WARNING("[src]'s chamber is full."),
				target = src,
			)
		return CLICKCHAIN_DID_SOMETHING
	if(bolt_simulation && bolt_closed)
		if(!no_message)
			actor.chat_feedback(
				SPAN_WARNING("[src]'s bolt must be open to access its chamber."),
				target = src,
			)
		return CLICKCHAIN_DID_SOMETHING
	if(!actor.performer.attempt_insert_item_for_installation(magazine, src))
		return CLICKCHAIN_DID_SOMETHING
	swap_chambered(casing, TRUE)
	if(!no_message)
		actor.visible_feedback(
			target = src,
			range = MESSAGE_RANGE_COMBAT_SUBTLE,
			visible = SPAN_NOTICE("[actor.performer] loads a round into [src]."),
			otherwise_self = SPAN_NOTICE("You load [casing] into [src]."),
		)
	return CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE

/**
 * * The weird proc args is because this supports non-clickchain use.
 *
 * @return clickchain flags
 */
/obj/item/gun/projectile/ballistic/proc/user_clickchain_unload(datum/event_args/actor/actor, datum/event_args/actor/clickchain/clickchain, no_sound, no_message)
	if(magazine)
		return user_clickchain_unload_magazine(actor, clickchain, no_sound, no_message)
	return user_clickchain_unload_ammo(actor, clickchain, no_sound, no_message, TRUE)

/**
 * * The weird proc args is because this supports non-clickchain use.
 *
 * @return clickchain flags
 */
/obj/item/gun/projectile/ballistic/proc/user_clickchain_unload_ammo(datum/event_args/actor/actor, datum/event_args/actor/clickchain/clickchain, no_sound, no_message, remove_chamber_if_empty)
	if(bolt_simulation && bolt_closed && bolt_blocks_internal_magazine)
		return NONE
	var/obj/item/ammo_casing/unloaded = remove_casing(null, no_sound)
	if(!unloaded)
		if(remove_chamber_if_empty)
			return user_clickchain_unload_chamber(actor, clickchain, no_sound, no_message)
		return NONE
	actor.performer.put_in_hands_or_drop(unloaded)
	if(!no_message)
		actor.visible_feedback(
			target = src,
			range = MESSAGE_RANGE_INVENTORY_SOFT,
			visible = "[actor.performer] removes [unloaded] from [src].",
			otherwise_self = SPAN_NOTICE("You remove [unloaded] from [src]."),
		)
	return CLICKCHAIN_DID_SOMETHING

/**
 * * The weird proc args is because this supports non-clickchain use.
 *
 * @return clickchain flags
 */
/obj/item/gun/projectile/ballistic/proc/user_clickchain_unload_magazine(datum/event_args/actor/actor, datum/event_args/actor/clickchain/clickchain, no_sound, no_message)
	var/obj/item/ammo_magazine/unloaded = remove_magazine(null, no_sound)
	if(!unloaded)
		return NONE
	actor.performer.put_in_hands_or_drop(unloaded)
	if(!no_message)
		actor.visible_feedback(
			target = src,
			range = MESSAGE_RANGE_INVENTORY_SOFT,
			visible = "[actor.performer] removes [unloaded] from [src].",
			otherwise_self = SPAN_NOTICE("You remove [unloaded] from [src]."),
		)
	return CLICKCHAIN_DID_SOMETHING

/**
 * * The weird proc args is because this supports non-clickchain use.
 *
 * @return clickchain flags
 */
/obj/item/gun/projectile/ballistic/proc/user_clickchain_unload_chamber(datum/event_args/actor/actor, datum/event_args/actor/clickchain/clickchain, no_sound, no_message)
	var/obj/item/ammo_casing/unloaded = eject_chamber(no_sound)
	if(!unloaded)
		return NONE
	actor.performer.put_in_hands_or_drop(unloaded)
	if(!no_message)
		actor.visible_feedback(
			target = src,
			range = MESSAGE_RANGE_INVENTORY_SOFT,
			visible = "[actor.performer] removes [unloaded] from [src].",
			otherwise_self = SPAN_NOTICE("You remove [unloaded] from [src]."),
		)
	return CLICKCHAIN_DID_SOMETHING

/**
 * * The weird proc args is because this supports non-clickchain use
 *
 * @return clickchain flags
 */
/obj/item/gun/projectile/ballistic/proc/user_clickchain_spin_chamber(datum/event_args/actor/actor, datum/event_args/actor/clickchain/clickchain, no_sound, no_message)
	if(!internal_magazine || !internal_magazine_revolver_mode)
		return NONE
	if(!COOLDOWN_FINISHED(src, CD_INDEX_GUN_SPIN_CHAMBER))
		return CLICKCHAIN_DID_SOMETHING
	COOLDOWN_START(src, CD_INDEX_GUN_SPIN_CHAMBER, chamber_spin_cooldown)
	unsafe_spin_chamber_to_random()
	if(!no_message)
		actor.visible_feedback(
			target = src,
			visible = SPAN_WARNING("[actor.performer] spins the chamber of \the [src]!"),
			audible = SPAN_WARNING("You hear something metallic spin and click."),
			otherwise_self = SPAN_WARNING("You spin [src]'s chamber."),
		)
	if(!no_sound)
		// todo: variable for this somewhere
		playsound(src, 'sound/weapons/revolver_spin.ogg', 75, TRUE)
	return CLICKCHAIN_DID_SOMETHING
