//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/using_item_on(obj/item/using, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	if(istype(using, /obj/item/cell) && !isnull(obj_cell_slot) && isnull(obj_cell_slot.cell) && obj_cell_slot.interaction_active(user))
		if(!user.transfer_item_to_loc(using, src))
			user.action_feedback(SPAN_WARNING("[using] is stuck to your hand!"), src)
			return CLICKCHAIN_DO_NOT_PROPAGATE
		if(!obj_cell_slot.accepts_cell(using))
			user.action_feedback(
				SPAN_WARNING("[src] do,es not accept [using]."),
				target = src,
			)
			return CLICKCHAIN_DO_NOT_PROPAGATE
		user.visible_action_feedback(
			target = src,
			hard_range = obj_cell_slot.remove_is_discrete? 0 : MESSAGE_RANGE_CONSTRUCTION,
			visible_hard = SPAN_NOTICE("[user] inserts [using] into [src]."),
			audible_hard = SPAN_NOTICE("You hear something being slotted in."),
			visible_self = SPAN_NOTICE("You insert [using] into [src]."),
		)
		obj_cell_slot.insert_cell(using)
		user.trigger_aiming(TARGET_CAN_CLICK)
		return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
	var/datum/event_args/actor/actor = new(user)
	if(!isnull(obj_storage) && using.allow_auto_storage_insert(actor, obj_storage) && obj_storage?.auto_handle_interacted_insertion(using, actor))
		user.trigger_aiming(TARGET_CAN_CLICK)
		return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
	return ..()

/obj/on_attack_hand(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return
	if(!isnull(obj_cell_slot?.cell) && obj_cell_slot.remove_yank_offhand && clickchain.performer.is_holding_inactive(src) && obj_cell_slot.interaction_active(clickchain.performer))
		clickchain.performer.visible_action_feedback(
			target = src,
			hard_range = obj_cell_slot.remove_is_discrete? 0 : MESSAGE_RANGE_CONSTRUCTION,
			visible_hard = SPAN_NOTICE("[clickchain.performer] removes the cell from [src]."),
			audible_hard = SPAN_NOTICE("You hear fasteners falling out and something being removed."),
			visible_self = SPAN_NOTICE("You remove the cell from [src]."),
		)
		log_construction(clickchain, src, "removed cell [obj_cell_slot.cell] ([obj_cell_slot.cell.type])")
		clickchain.performer.put_in_hands_or_drop(obj_cell_slot.remove_cell(clickchain.performer))
		return CLICKCHAIN_DID_SOMETHING
