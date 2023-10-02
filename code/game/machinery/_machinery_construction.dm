//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/obj/machinery/dynamic_tool_query(obj/item/I, datum/event_args/actor/clickchain/e_args, list/hint_images = list())
	. = list()
	if(tool_deconstruct && !isnull(default_deconstruct) && panel_open)
		LAZYSET(.[tool_deconstruct], "deconstruct", dyntool_image_backward(tool_deconstruct))
	if(tool_unanchor && !isnull(default_unanchor))
		LAZYSET(.[tool_unanchor], anchored? "unanchor" : "anchor", anchored? dyntool_image_backward(tool_unanchor) : dyntool_image_forward(tool_unanchor))
	if(tool_panel && !isnull(default_panel))
		LAZYSET(.[tool_panel], panel_open? "close panel" : "open panel", panel_open? dyntool_image_forward(tool_panel) : dyntool_image_backward(tool_panel))
	return merge_double_lazy_assoc_list(., ..())

/obj/machinery/tool_act(obj/item/I, datum/event_args/actor/clickchain/e_args, function, flags, hint)
	if(INTERACTING_WITH_FOR(e_args.performer, src, INTERACTING_FOR_CONSTRUCTION))
		return CLICKCHAIN_DO_NOT_PROPAGATE
	START_INTERACTING_WITH(e_args.performer, src, INTERACTING_FOR_CONSTRUCTION)
	if(function == tool_deconstruct && !isnull(default_deconstruct))
		if(default_deconstruction_dismantle(I, e_args, flags = flags))
			. = CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE
		. = CLICKCHAIN_DO_NOT_PROPAGATE
	else if(function == tool_unanchor && !isnull(default_unanchor))
		if(default_deconstruction_anchor(I, e_args, flags = flags))
			. = CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE
		. = CLICKCHAIN_DO_NOT_PROPAGATE
	else if(function == tool_panel && !isnull(default_panel))
		if(default_deconstruction_panel(I, e_args, flags = flags))
			. = CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE
		. = CLICKCHAIN_DO_NOT_PROPAGATE
	STOP_INTERACTING_WITH(e_args.performer, src,INTERACTING_FOR_CONSTRUCTION)
	if(isnull(.))
		return ..()

// todo: better verb/message support
/obj/machinery/proc/default_deconstruction_panel(obj/item/tool, datum/event_args/actor/clickchain/e_args, speed_mult = 1, flags)
	var/needed_time = default_panel * speed_mult * (isnull(tool)? 1 : tool.tool_speed)
	if(needed_time)
		e_args.visible_feedback(
			target = src,
			range = MESSAGE_RANGE_CONSTRUCTION,
			visible = SPAN_WARNING("[e_args.performer] starts to [panel_open? "close" : "open"] [src]'s maintenance panel."),
			audible = SPAN_WARNING("You hear something being (un)fastened."),
			otherwise_self = SPAN_WARNING("You start to [panel_open? "close" : "open"] [src]'s panel."),
		)
	if(!use_tool(tool_panel, tool, e_args, flags, needed_time))
		return FALSE
	e_args.visible_feedback(
		target = src,
		range = MESSAGE_RANGE_CONSTRUCTION,
		visible = SPAN_WARNING("[e_args.performer] [panel_open? "closes" : "opens"] [src]'s maintenance panel."),
		audible = SPAN_WARNING("You hear something being (un)fastened."),
		otherwise_self = SPAN_WARNING("You [panel_open? "close" : "open"] [src]'s panel."),
	)
	set_panel_open(!panel_open)
	return TRUE

// todo: better verb/message support
/obj/machinery/proc/default_deconstruction_dismantle(obj/item/tool, datum/event_args/actor/clickchain/e_args, speed_mult = 1, flags)
	var/needed_time = default_deconstruct * speed_mult * (isnull(tool)? 1 : tool.tool_speed)
	if(needed_time)
		e_args.visible_feedback(
			target = src,
			range = MESSAGE_RANGE_CONSTRUCTION,
			visible = SPAN_WARNING("[e_args.performer] starts to dismantle [src]."),
			audible = SPAN_WARNING("You hear a series of small parts being removed from something."),
			otherwise_self = SPAN_WARNING("You start to dismantle [src]."),
		)
	if(!use_tool(tool_deconstruct, tool, e_args, flags, needed_time))
		return FALSE
	e_args.visible_feedback(
		target = src,
		range = MESSAGE_RANGE_CONSTRUCTION,
		visible = SPAN_WARNING("[e_args.performer] dismantles [src]."),
		audible = SPAN_WARNING("You hear something getting dismantled."),
		otherwise_self = SPAN_WARNING("You dismantle [src]."),
	)
	dismantle()
	return TRUE

// todo: better verb/message support
/obj/machinery/proc/default_deconstruction_anchor(obj/item/tool, datum/event_args/actor/clickchain/e_args, speed_mult = 1, flags)
	var/needed_time = default_unanchor * speed_mult * (isnull(tool)? 1 : tool.tool_speed)
	if(needed_time)
		e_args.visible_feedback(
			target = src,
			range = MESSAGE_RANGE_CONSTRUCTION,
			visible = SPAN_WARNING("[e_args.performer] starts to [anchored? "unbolt" : "bolt"] [src] [anchored? "from" : "to"] the floor."),
			audible = SPAN_WARNING("You hear something heavy being (un)fastened."),
			otherwise_self = SPAN_WARNING("You start to [anchored? "unbolt" : "bolt"] [src] [anchored? "from" : "to"] the floor."),
		)
	if(!use_tool(tool_unanchor, tool, e_args, flags, needed_time))
		return FALSE
	e_args.visible_feedback(
		target = src,
		range = MESSAGE_RANGE_CONSTRUCTION,
		visible = SPAN_WARNING("[e_args.performer] [anchored? "bolts" : "unbolts"] [src] [anchored? "to" : "from"] from the floor."),
		audible = SPAN_WARNING("You hear something heavy being (un)fastened."),
		otherwise_self = SPAN_WARNING("You [anchored? "unbolt" : "bolt"] [src] [anchored? "from" : "to"] the floor."),
	)
	set_anchored(!anchored)
	return TRUE
