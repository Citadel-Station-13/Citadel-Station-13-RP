//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/item/rig/using_item_on(obj/item/using, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return
	if(istype(using, /obj/item/rig_module))
		if(!maint_panel_open)
			#warn impl
		#warn impl
	else
		for(var/obj/item/rig_module/module as anything in get_modules())
	#warn impl

/obj/item/rig/tool_act(obj/item/I, datum/event_args/actor/clickchain/e_args, function, flags, hint)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return
	if(e_args.performer == wearer && !is_maint_panel_self_reachable())
		e_args.chat_feedback(
			SPAN_WARNING("You can't reach the maintenance panel while wearing [src]."),
			target = src,
		)
		return CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE
	var/datum/rig_maint_panel/panel = request_maint()
	panel.ui_interact(e_args.initiator)
	return CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE

/obj/item/rig/context_menu_query(datum/event_args/actor/e_args)
	var/list/tuples = ..()
	if(e_args.performer == wearer)
		tuples[++tuples.len] = create_context_menu_tuple("access controls", image(src), 1, NONE)
	else
		tuples[++tuples.len] = create_context_menu_tuple("maint panel", image(src), 1, MOBILITY_CAN_USE)
	return tuples

/obj/item/rig/context_menu_act(datum/event_args/actor/e_args, key)
	. = ..()
	if(.)
		return
	switch(key)
		if("access controls")
			if(e_args.initiator != wearer)
				return TRUE
			ui_interact(e_args.initiator)
			return TRUE
		if("maint panel")
			if(e_args.performer == wearer && !is_maint_panel_self_reachable())
				e_args.chat_feedback(
					SPAN_WARNING("You can't reach [src]'s maintenance panel while wearing it."),
					target = src,
				)
				return TRUE
			if(!e_args.performer.Reachability(src))
				e_args.chat_feedback(
					SPAN_WARNING("You can't reach that right now."),
					target = src,
				)
				return TRUE
			var/datum/rig_maint_panel/panel = request_maint()
			panel.ui_interact(e_args.initiator)
			return TRUE
