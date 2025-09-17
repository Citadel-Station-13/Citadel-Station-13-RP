//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* these have the primary function of calling other procs in public.dm *//

/**
 * dels something or says "x is stuck to your hand"
 *
 * WARNING: DELS THINGS AFTER CURRENT PROC. DO NOT USE IF YOU NEED IMMEDIATE QDEL!
 * This is so procs can still access data.
 */
/mob/proc/attempt_consume_item_for_construction(obj/item/I, flags)
	. = temporarily_remove_from_inventory(I, flags)
	if(!.)
		return FALSE
	. = TRUE
	QDEL_IN(I, 0)

/**
 * standard helper for put something into something else
 */
/mob/proc/attempt_insert_item_for_installation(obj/item/I, atom/newloc, flags)
	. = transfer_item_to_loc(I, newloc, flags)
	if(!.)
		return FALSE
	return TRUE

/**
 * standard helper for put something into something else but it actually nullspaces lmao
 */
/mob/proc/attempt_void_item_for_installation(obj/item/I, flags)
	. = transfer_item_to_nullspace(I, flags)
	if(!.)
		return FALSE
	return TRUE

/**
 * puts item in hand or drops, unless we are using MUTATION_TELEKINESIS, in which case just drops at interacted loc
 * this doesn't actually check if I is in interacted
 * this is intentional.
 */
/mob/proc/grab_item_from_interacted_with(obj/item/I, atom/interacted)
	// TODO: proper MUTATION_TELEKINESIS checks
	if(!Adjacent(interacted))
		I.forceMove(interacted.drop_location())
		return
	put_in_hands_or_drop(I)

/mob/proc/drop_slots_to_ground(list/slots, flags, datum/callback/cb)
	if(islist(slots))
		for(var/slot in slots)
			var/obj/item/I = item_by_slot_id(slot)
			if(I == INVENTORY_SLOT_DOES_NOT_EXIST)
				continue
			. = drop_item_to_ground(I, flags)
			cb?.Invoke(I, .)
	else
		var/obj/item/I = item_by_slot_id(slots)
		if(I == INVENTORY_SLOT_DOES_NOT_EXIST)
			return
		. = drop_item_to_ground(I, flags)
		cb?.Invoke(I, .)

/mob/proc/transfer_slots_to_loc(list/slots, atom/A, flags, datum/callback/cb)
	// todo: handle what happens if dropping something requires a logic thing
	// e.g. dropping jumpsuit makes it impossible to transfer a belt since it
	// de-equipped from the jumpsuit
	if(islist(slots))
		for(var/slot in slots)
			var/obj/item/I = item_by_slot_id(slot)
			if(I == INVENTORY_SLOT_DOES_NOT_EXIST)
				continue
			. = transfer_item_to_loc(I, A, flags)
			cb?.Invoke(I, .)
	else
		var/obj/item/I = item_by_slot_id(slots)
		if(I == INVENTORY_SLOT_DOES_NOT_EXIST)
			return
		. = transfer_item_to_loc(I, A, flags)
		cb?.Invoke(I, .)

/mob/proc/get_equipped_items_in_slots(list/slots)
	. = list()
	var/obj/item/I
	if(islist(slots))
		for(var/slot in slots)
			I = item_by_slot_id(slot)
			if(I && I != INVENTORY_SLOT_DOES_NOT_EXIST)
				. += I
	else
		I = item_by_slot_id(slots)
		if(I && I != INVENTORY_SLOT_DOES_NOT_EXIST)
			. += I

/**
 * equip to slots if possible, in order
 * silent defaults to TRUE, to avoid spam
 *
 * return slot equipped to if success, otherwise null
 */
/mob/proc/equip_to_slots_if_possible(obj/item/I, list/slots, mob/user, flags)
	if(!islist(slots))
		return equip_to_slot_if_possible(I, slots, user, flags)? slots : null
	for(var/slot in slots)
		if(equip_to_slot_if_possible(I, slot, user, flags))
			return slot

/**
 * Attempt to shove an item being held into a storage in a given slot
 */
/mob/proc/attempt_put_held_item_into_storage_in_slot(obj/item/inserting, datum/inventory_slot/slot_like, silent, mob/initiator = src)
	if(isnull(inserting))
		inserting = get_active_held_item()
	if(!is_holding(inserting))
		return
	slot_like = resolve_inventory_slot(slot_like)
	var/obj/item/equipped = item_by_slot_id(slot_like.id)
	if(isnull(equipped))
		if(!silent)
			to_chat(initiator, SPAN_WARNING("There is nothing worn [slot_like.display_preposition] [initiator == src? "your" : "their"] [slot_like.display_name]."))
		return FALSE
	if(!equipped.obj_storage)
		if(!silent)
			to_chat(initiator, SPAN_WARNING("[equipped] doesn't have accessible storage."))
		return FALSE
	if(!equipped.obj_storage.auto_handle_interacted_insertion(inserting, new /datum/event_args/actor(src, initiator), silent))
		return FALSE
	return TRUE

/**
 * Attempt to grab an item from a given slot into hand.
 */
/mob/proc/attempt_grab_item_out_of_storage_in_slot(datum/inventory_slot/slot_like, silent, mob/initiator = src)
	slot_like = resolve_inventory_slot(slot_like)
	var/obj/item/equipped = item_by_slot_id(slot_like.id)
	if(isnull(equipped))
		if(!silent)
			to_chat(initiator, SPAN_WARNING("There is nothing worn [slot_like.display_preposition] [initiator == src? "your" : "their"] [slot_like.display_name]."))
		return FALSE
	if(isnull(equipped.obj_storage))
		if(!silent)
			to_chat(initiator, SPAN_WARNING("[equipped] doesn't have accessible storage."))
			return FALSE
	return attempt_grab_item_out_of_storage(equipped, silent, initiator)

/**
 * Attempt to grab an item from given storage into hand.
 */
/mob/proc/attempt_grab_item_out_of_storage(obj/storage, silent, mob/initiator = src)
	if(get_active_held_item())
		if(!silent)
			to_chat(initiator, SPAN_WARNING("[initiator == src? "You" : "They"] already have something held in [initiator == src? "your" : "their"] hand."))
		return FALSE
	if(isnull(storage.obj_storage))
		return FALSE
	var/obj/item/removing = storage.obj_storage.top_entity_in_contents()
	if(isnull(removing))
		if(!silent)
			to_chat(initiator, SPAN_WARNING("[initiator == src? "Your" : "Their"] [storage] is empty!"))
		return FALSE
	var/datum/event_args/actor/actor = new(src, initiator)
	if(storage.obj_storage.check_on_found_hooks(actor))
		return
	return storage.obj_storage.auto_handle_interacted_removal(removing, actor, silent, put_in_hands = TRUE)

/**
 * Automatically either put in hand object into a storage in a given slot, or
 * draw an item from that storage into hand.
 */
/mob/proc/auto_held_insert_or_draw_via_slot(datum/inventory_slot/slot_like, silent, mob/initiator = src)
	slot_like = resolve_inventory_slot(slot_like)
	var/obj/item/holding = get_active_held_item()
	var/obj/item/in_slot = item_by_slot_id(slot_like.id)
	if(isnull(in_slot) || isnull(in_slot.obj_storage))
		if(isnull(holding))
			if(isnull(in_slot))
				to_chat(initiator, SPAN_WARNING("[initiator == src? "You" : "They"] have nothing held in [slot_like.display_name]!"))
				return FALSE
			if(put_in_active_hand(in_slot))
				to_chat(initiator, SPAN_NOTICE("You draw [in_slot] from your [slot_like.display_name]."))
				return TRUE
			else
				to_chat(initiator, SPAN_WARNING("You fail to draw [in_slot] from your [slot_like.display_name]!"))
				return FALSE
		else
			if(equip_to_slot_if_possible(holding, slot_like, user = initiator))
				to_chat(initiator, SPAN_NOTICE("You tuck [holding] away [slot_like.display_preposition] your [slot_like.display_name]."))
				return TRUE
			else
				return FALSE
	else
		if(isnull(holding))
			return attempt_grab_item_out_of_storage_in_slot(slot_like, silent, initiator)
		else
			return attempt_put_held_item_into_storage_in_slot(holding, slot_like, silent, initiator)
