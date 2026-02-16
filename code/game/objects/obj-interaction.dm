//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

//* Interaction *//

/obj/using_item_on(obj/item/using, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	if(istype(using, /obj/item/cell) && obj_cell_slot?.insert_via_usage && isnull(obj_cell_slot.cell) && obj_cell_slot.interaction_active(clickchain.performer))
		if(!obj_cell_slot.accepts_cell(using))
			clickchain.chat_feedback(
				span_warning("[src] does not accept [using]."),
				target = src,
			)
			return CLICKCHAIN_DO_NOT_PROPAGATE
		if(!clickchain.performer.transfer_item_to_loc(using, src))
			clickchain.chat_feedback(span_warning("[using] is stuck to your hand!"), target = src)
			return CLICKCHAIN_DO_NOT_PROPAGATE
		clickchain.visible_dual_feedback(
			target = src,
			range_hard = obj_cell_slot.remove_is_discrete? 0 : MESSAGE_RANGE_CONSTRUCTION,
			visible_hard = span_notice("[clickchain.performer] inserts [using] into [src]."),
			audible_hard = span_notice("You hear something being slotted in."),
			visible_self = span_notice("You insert [using] into [src]."),
		)
		obj_cell_slot.user_insert_cell(using, actor = clickchain)
		clickchain.performer.trigger_aiming(TARGET_CAN_CLICK)
		log_construction(clickchain, src, "inserted cell [obj_cell_slot.cell] ([obj_cell_slot.cell.type])")
		return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
	if(!isnull(obj_storage) && using.allow_auto_storage_insert(clickchain, obj_storage) && obj_storage?.auto_handle_interacted_insertion(using, clickchain))
		clickchain.performer.trigger_aiming(TARGET_CAN_CLICK)
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
			visible_hard = span_notice("[clickchain.performer] removes the cell from [src]."),
			audible_hard = span_notice("You hear fasteners falling out and something being removed."),
			visible_self = span_notice("You remove the cell from [src]."),
		)
		log_construction(clickchain, src, "removed cell [obj_cell_slot.cell] ([obj_cell_slot.cell.type])")
		clickchain.performer.put_in_hands_or_drop(obj_cell_slot.user_remove_cell(clickchain.performer, actor = clickchain))
		return CLICKCHAIN_DID_SOMETHING

/obj/tool_act(obj/item/I, datum/event_args/actor/clickchain/e_args, function, flags, hint)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return
	if(obj_cell_slot?.remove_tool_behavior == function)
		if(!obj_cell_slot.interaction_active(e_args.performer))
			return TRUE
		if(!CHECK_MOBILITY(e_args.performer, MOBILITY_CAN_USE))
			e_args.initiator.action_feedback(span_warning("You can't do that right now!"), src)
			return TRUE
		if(isnull(obj_cell_slot.cell))
			e_args.initiator.action_feedback(span_warning("[src] doesn't have a cell installed."))
			return TRUE
		if(!I.tool_check(obj_cell_slot.remove_tool_behavior, e_args, src, NONE, NONE))
			e_args.chat_feedback(
				span_warning("You need to be holding some kind of [tool_behavior_name(obj_cell_slot.remove_tool_behavior)] in your active hand to remove [src]'s cell."),
				target = src,
			)
			return TRUE
		if(!use_tool(obj_cell_slot.remove_tool_behavior, I, e_args, NONE, obj_cell_slot.remove_tool_time))
			return TRUE
		e_args.visible_feedback(
			target = src,
			range = obj_cell_slot.remove_is_discrete? 0 : MESSAGE_RANGE_CONSTRUCTION,
			visible = span_notice("[e_args.performer] removes the cell from [src]."),
			audible = span_notice("You hear fasteners falling out and something being removed."),
			otherwise_self = span_notice("You remove the cell from [src]."),
		)
		log_construction(e_args, src, "removed cell [obj_cell_slot.cell] ([obj_cell_slot.cell.type])")
		var/obj/item/cell/removed = obj_cell_slot.user_remove_cell(src, actor = e_args)
		if(e_args.performer.Reachability(src))
			e_args.performer.put_in_hands_or_drop(removed)
		else
			removed.forceMove(drop_location())
		return TRUE

//* Context *//

/obj/context_menu_query(datum/event_args/actor/e_args)
	. = ..()
	if(obj_cell_slot)
		if(obj_cell_slot.cell)
			if((obj_cell_slot.remove_yank_context || obj_cell_slot.remove_tool_context) && obj_cell_slot.interaction_active(e_args.performer))
				var/image/rendered = image(obj_cell_slot.cell)
				.["obj_cell_slot-remove"] = create_context_menu_tuple("remove cell", rendered, mobility = MOBILITY_CAN_USE, defaultable = TRUE)
		else
			if(obj_cell_slot.insert_via_context && obj_cell_slot.interaction_active(e_args.performer))
				// TODO: proper image
				var/image/rendered = image(src)
				.["obj_cell_slot-insert"] = create_context_menu_tuple("insert cell", rendered, mobility = MOBILITY_CAN_USE, defaultable = TRUE)
	if(obj_storage?.allow_open_via_context_click)
		var/image/rendered = image(src)
		.["obj_storage"] = create_context_menu_tuple("open storage", rendered, mobility = MOBILITY_CAN_STORAGE, defaultable = TRUE)
	if(obj_rotation_flags & OBJ_ROTATION_ENABLED)
		if(obj_rotation_flags & OBJ_ROTATION_BIDIRECTIONAL)
			var/image/rendered = image(src) // todo: sprite
			.["rotate_cw"] = create_context_menu_tuple(
				"Rotate Clockwise",
				rendered,
				1,
				MOBILITY_CAN_USE,
				!!(obj_rotation_flags & OBJ_ROTATION_DEFAULTING),
			)
			rendered = image(src) // todo: sprite
			.["rotate_ccw"] = create_context_menu_tuple(
				"Rotate Counterclockwise",
				rendered,
				1,
				MOBILITY_CAN_USE,
				!!(obj_rotation_flags & OBJ_ROTATION_DEFAULTING),
			)
		else
			var/image/rendered = image(src) // todo: sprite
			.["rotate_[obj_rotation_flags & OBJ_ROTATION_CCW? "ccw" : "cw"]"] = create_context_menu_tuple(
				"Rotate [obj_rotation_flags & OBJ_ROTATION_CCW? "Counterclockwise" : "Clockwise"]",
				rendered,
				1,
				MOBILITY_CAN_USE,
				!!(obj_rotation_flags & OBJ_ROTATION_DEFAULTING),
			)

/obj/context_menu_act(datum/event_args/actor/e_args, key)
	switch(key)
		if("obj_cell_slot-insert")
			var/reachability = e_args.performer.Reachability(src)
			if(!reachability)
				return TRUE
			if(!obj_cell_slot.interaction_active(e_args.performer))
				return TRUE
			if(!CHECK_MOBILITY(e_args.performer, MOBILITY_CAN_USE))
				e_args.initiator.action_feedback(span_warning("You can't do that right now!"), src)
				return TRUE
			if(obj_cell_slot.cell)
				e_args.initiator.action_feedback(span_warning("[src] already has a cell installed."))
				return TRUE
			var/obj/item/cell/cell = e_args.performer.get_active_held_item()
			if(!istype(cell))
				e_args.chat_feedback(
					span_warning("You must be holding a cell in your active hand to insert it into [src]."),
					target = src,
				)
				return TRUE
			if(!e_args.performer.transfer_item_to_loc(cell, src))
				e_args.chat_feedback(
					span_warning("[cell] is stuck to your hand!"),
					target = src,
				)
				return TRUE
			obj_cell_slot.user_insert_cell(cell, actor = e_args)
			e_args.visible_feedback(
				target = src,
				range = obj_cell_slot.remove_is_discrete? 0 : MESSAGE_RANGE_CONSTRUCTION,
				visible = span_notice("[e_args.performer] inserts [cell] into [src]."),
				audible = span_notice("You hear something clicking into place and fasteners being secured."),
				otherwise_self = span_notice("You remove insert [cell] into [src]."),
			)
			log_construction(e_args, src, "inserted cell [obj_cell_slot.cell] ([obj_cell_slot.cell.type])")
			return TRUE
		if("obj_cell_slot-remove")
			var/reachability = e_args.performer.Reachability(src)
			if(!reachability)
				return TRUE
			if(!obj_cell_slot.interaction_active(e_args.performer))
				return TRUE
			if(!CHECK_MOBILITY(e_args.performer, MOBILITY_CAN_USE))
				e_args.initiator.action_feedback(span_warning("You can't do that right now!"), src)
				return TRUE
			if(isnull(obj_cell_slot.cell))
				e_args.initiator.action_feedback(span_warning("[src] doesn't have a cell installed."))
				return TRUE
			if(obj_cell_slot.remove_tool_behavior)
				var/obj/item/held = e_args.performer.get_active_held_item()
				if(!held?.tool_check(obj_cell_slot.remove_tool_behavior, e_args, src, NONE, NONE))
					e_args.chat_feedback(
						span_warning("You need to be holding some kind of [tool_behavior_name(obj_cell_slot.remove_tool_behavior)] in your active hand to remove [src]'s cell."),
						target = src,
					)
					return TRUE
				if(!use_tool(obj_cell_slot.remove_tool_behavior, held, e_args, NONE, obj_cell_slot.remove_tool_time))
					return TRUE
			e_args.visible_feedback(
				target = src,
				range = obj_cell_slot.remove_is_discrete? 0 : MESSAGE_RANGE_CONSTRUCTION,
				visible = span_notice("[e_args.performer] removes the cell from [src]."),
				audible = span_notice("You hear fasteners falling out and something being removed."),
				otherwise_self = span_notice("You remove the cell from [src]."),
			)
			log_construction(e_args, src, "removed cell [obj_cell_slot.cell] ([obj_cell_slot.cell.type])")
			var/obj/item/cell/removed = obj_cell_slot.user_remove_cell(src, actor = e_args)
			if(reachability == REACH_PHYSICAL)
				e_args.performer.put_in_hands_or_drop(removed)
			else
				removed.forceMove(drop_location())
			return TRUE
		if("obj_storage")
			var/reachability = e_args.performer.Reachability(src)
			if(!reachability)
				return TRUE
			obj_storage?.auto_handle_interacted_open(e_args)
			return TRUE
		if("rotate_cw", "rotate_ccw")
			var/clockwise = key == "rotate_cw"
			handle_rotation(e_args, clockwise)
			return TRUE
	return ..()
