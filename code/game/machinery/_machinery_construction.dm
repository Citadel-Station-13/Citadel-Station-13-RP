//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/obj/machinery/dynamic_tool_functions(obj/item/I, mob/user)
	. = list()
	if(tool_deconstruct && !isnull(default_deconstruct) && panel_open)
		LAZYADD(.[tool_panel], "deconstruct")
	if(tool_unanchor && !isnull(default_unanchor))
		LAZYADD(.[tool_panel], anchored? "unanchor" : "anchor")
	if(tool_panel && !isnull(default_panel))
		LAZYADD(.[tool_panel], panel_open? "close panel" : "open panel")
	return merge_double_lazy_assoc_list(., ..())

/obj/machinery/dynamic_tool_image(function, hint)
	switch(hint)
		if("anchor", "close panel")
			return dyntool_image_backward(function)
		if("unanchor", "open panel", "deconstruct")
			return dyntool_image_backward(function)
	return ..()

/obj/machinery/tool_act(obj/item/I, mob/user, function, flags, hint)
	if(INTERACTING_WITH_FOR(user, src, INTERACTING_FOR_CONSTRUCTION))
		return CLICKCHAIN_DO_NOT_PROPAGATE
	START_INTERACTING_WITH(user, src, INTERACTING_FOR_CONSTRUCTION)
	if(function == tool_deconstruct && !isnull(default_deconstruct))
		if(default_deconstruction_dismantle(I, user, flags = flags))
			. = CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE
		. = CLICKCHAIN_DO_NOT_PROPAGATE
	else if(function == tool_unanchor && !isnull(default_unanchor))
		if(default_deconstruction_anchor(I, user, flags = flags))
			. = CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE
		. = CLICKCHAIN_DO_NOT_PROPAGATE
	else if(function == tool_panel && !isnull(default_panel))
		if(default_deconstruction_panel(I, user, flags = flags))
			. = CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE
		. = CLICKCHAIN_DO_NOT_PROPAGATE
	STOP_INTERACTING_WITH(user, src,INTERACTING_FOR_CONSTRUCTION)
	if(isnull(.))
		return ..()

// todo: better verb/message support
/obj/machinery/proc/default_deconstruction_panel(obj/item/tool, mob/user, speed_mult = 1, flags)
	var/needed_time = default_panel * speed_mult * (isnull(tool)? 1 : tool.tool_speed)
	if(needed_time)
		user.visible_action_feedback(
			target = src,
			soft_range = MESSAGE_RANGE_CONSTRUCTION,
			visible_soft = SPAN_WARNING("[user] starts to [panel_open? "close" : "open"] [src]'s maintenance panel."),
			audible_soft = SPAN_WARNING("You hear something being (un)fastened."),
		)
	if(!use_tool(tool_panel, tool, user, flags, needed_time))
		return FALSE
	user.visible_action_feedback(
		target = src,
		soft_range = MESSAGE_RANGE_CONSTRUCTION,
			visible_soft = SPAN_WARNING("[user] [panel_open? "closes" : "opens"] [src]'s maintenance panel."),
		audible_soft = SPAN_WARNING("You hear something being (un)fastened."),
	)
	set_panel_open(!panel_open)
	return TRUE

// todo: better verb/message support
/obj/machinery/proc/default_deconstruction_dismantle(obj/item/tool, mob/user, speed_mult = 1, flags)
	var/needed_time = default_deconstruct * speed_mult * (isnull(tool)? 1 : tool.tool_speed)
	if(needed_time)
		user.visible_action_feedback(
			target = src,
			soft_range = MESSAGE_RANGE_CONSTRUCTION,
			visible_soft = SPAN_WARNING("[user] starts to dismantle [src]."),
			audible_soft = SPAN_WARNING("You hear a series of small parts being removed from something."),
		)
	if(!use_tool(tool_deconstruct, tool, user, flags, needed_time))
		return FALSE
	user.visible_action_feedback(
		target = src,
		soft_range = MESSAGE_RANGE_CONSTRUCTION,
		visible_soft = SPAN_WARNING("[user] dismantles [src]."),
		audible_soft = SPAN_WARNING("You hear something getting dismantled."),
	)
	dismantle()
	return TRUE

// todo: better verb/message support
/obj/machinery/proc/default_deconstruction_anchor(obj/item/tool, mob/user, speed_mult = 1, flags)
	var/needed_time = default_unanchor * speed_mult * (isnull(tool)? 1 : tool.tool_speed)
	if(needed_time)
		user.visible_action_feedback(
			target = src,
			soft_range = MESSAGE_RANGE_CONSTRUCTION,
			visible_soft = SPAN_WARNING("[user] starts to [anchored? "unbolt" : "bolt"] [src] [anchored? "from" : "to"] the floor."),
			audible_soft = SPAN_WARNING("You hear something heavy being (un)fastened."),
		)
	if(!use_tool(tool_unanchor, tool, user, flags, needed_time))
		return FALSE
	user.visible_action_feedback(
		target = src,
		soft_range = MESSAGE_RANGE_CONSTRUCTION,
		visible_soft = SPAN_WARNING("[user] [anchored? "bolts" : "unbolts"] [src] [anchored? "to" : "from"] from the floor."),
		audible_soft = SPAN_WARNING("You hear something heavy being (un)fastened."),
	)
	set_anchored(!anchored)
	return TRUE
