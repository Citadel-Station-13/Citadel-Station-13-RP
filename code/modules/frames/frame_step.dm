//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * a transition from one stage to another
 */
/datum/frame_step
	/// step name for tool radials & more
	var/name
	/// "use a [whatever] on [frame] to [action_descriptor: "unscrew the panel"]"
	var/action_descriptor
	/// "you start [x -> 'unscrewing the panel on'][src] ..."
	/// add a space after!
	/// please don't put pronouns in this, it doesn't get interpolated properly.
	var/action_text_leading
	/// "you start ... [src][x -> ', removing the screws in the process.']"
	/// don't forget punctuation at the end.
	/// please don't put pronouns in this, it doesn't get interpolated properly.
	var/action_text_trailing
	/// stage key this moves us to
	/// * [STAGE_DECONSTRUCT] to deconstruct
	/// * [STAGE_FINISH] to finish
	var/stage
	/// direction: [TOOL_DIRECTION_FORWARDS] or [TOOL_DIRECTION_BACKWARDS] or [TOOL_DIRECTION_NEUTRAL]
	/// * this is used as a hint for tool graphics
	/// * this is used as a hint for other visual / textual feedback
	var/direction = TOOL_DIRECTION_NEUTRAL

	/// FRAME_REQUEST_TYPE_* define
	var/request_type
	/// ergo: stack type, item type, tool function, etc. what this is depends on [step_type]
	/// limited autodetection is allowed.
	var/request
	/// * stacks: amount
	/// * items: amount; if 0, we just apply the item to it
	/// * rest: unused.
	var/request_amount
	/// * tools: this is cost
	/// * rest: unused
	var/request_cost

	/// time needed to do this
	/// note that for tool steps, this might impact the total cost!
	var/time = 0 SECONDS

	// todo: request_store: null for default, context key to store under context

	/// what to drop when undertaking this step
	/// can either be:
	/// * /obj/item/stack typepath
	/// * /datum/material typepath
	/// * /obj/item typepath
	/// todo: text for 'drop context key'
	var/drop
	/// amount to drop
	var/drop_amount = 1

	/// use custom text?
	var/use_custom_feedback = FALSE
	/// list of tokens to concat into a string to display when beginning the step.
	/// will not be shown if the step is fast enough.
	/// null for default.
	///
	/// FRAME_TEXT_TOKEN_* defines are allowed, and will be automatically replaced during execution to the relevant text.
	var/list/visible_text_begin
	/// list of tokens to concat into a string to display when beginning the step.
	/// will not be shown if the step is fast enough.
	/// null for default.
	///
	/// FRAME_TEXT_TOKEN_* defines are allowed, and will be automatically replaced during execution to the relevant text.
	var/list/audible_text_begin
	/// list of tokens to concat into a string to display when beginning the step.
	/// will not be shown if the step is fast enough.
	/// null for default.
	///
	/// FRAME_TEXT_TOKEN_* defines are allowed, and will be automatically replaced during execution to the relevant text.
	var/list/self_text_begin
	/// list of tokens to concat into a string to display when finishing the step.
	/// null for default.
	///
	/// FRAME_TEXT_TOKEN_* defines are allowed, and will be automatically replaced during execution to the relevant text.
	var/list/visible_text_end
	/// list of tokens to concat into a string to display when finishing the step.
	/// null for default.
	///
	/// FRAME_TEXT_TOKEN_* defines are allowed, and will be automatically replaced during execution to the relevant text.
	var/list/audible_text_end
	/// list of tokens to concat into a string to display when finishing the step.
	/// null for default.
	///
	/// FRAME_TEXT_TOKEN_* defines are allowed, and will be automatically replaced during execution to the relevant text.
	var/list/self_text_end

/datum/frame_step/New()
	if(isnull(request_type))
		// autodetect
		var/detected
		if(ispath(request, /datum/material))
			request_type = FRAME_REQUEST_TYPE_MATERIAL
		else if(ispath(request, /obj/item/stack))
			request_type = FRAME_REQUEST_TYPE_STACK
		else if(ispath(request, /obj/item))
			request_type = FRAME_REQUEST_TYPE_ITEM
		else if(istext(request))
			if(request in global.all_tool_functions)
				request_type = FRAME_REQUEST_TYPE_TOOL
				detected = TRUE
		else if(!detected)
			CRASH("failed to autodetect request")

/datum/frame_step/proc/examine(obj/structure/frame2/frame, datum/event_args/actor/actor)
	var/rendered_action = action_descriptor || SPAN_BOLD(name)
	switch(request_type)
		if(FRAME_REQUEST_TYPE_INTERACT)
			. = "<b>Interact</b> with [frame] using an empty hand to [rendered_action]."
		if(FRAME_REQUEST_TYPE_ITEM)
			var/rendered_item
			var/obj/item/casted = request
			rendered_item = initial(casted.name)
			// todo: support amounts
			. = "Use an <b>[rendered_item]</b> on [frame] to [rendered_action]."
		if(FRAME_REQUEST_TYPE_MATERIAL)
			var/rendered_material
			var/rendered_stack_name
			var/datum/material/resolved = SSmaterials.resolve_material(request)
			rendered_material = resolved.display_name
			rendered_stack_name = resolved.sheet_plural_name
			. = "Apply [request_amount || 0] [rendered_stack_name] of <b>[rendered_material]</b> to [rendered_action]."
		if(FRAME_REQUEST_TYPE_PROC)
		if(FRAME_REQUEST_TYPE_STACK)
			var/rendered_stack
			var/rendered_stack_name
			var/obj/item/stack/casted = request
			rendered_stack = initial(casted.name)
			rendered_stack_name = initial(casted.name) || "sheets"
			. = "Use [request_amount || 0] [rendered_stack_name] of <b>[rendered_stack]</b> to [rendered_action]."
		if(FRAME_REQUEST_TYPE_TOOL)
			var/rendered_tool = request
			. = "Use a <b>[rendered_tool]</b> to [rendered_action]."
	return SPAN_NOTICE(.)

/datum/frame_step/proc/tool_image()
	switch(direction)
		if(TOOL_DIRECTION_BACKWARDS)
			return dyntool_image_backward(request)
		if(TOOL_DIRECTION_FORWARDS)
			return dyntool_image_forward(request)
		if(TOOL_DIRECTION_NEUTRAL)
			return dyntool_image_neutral(request)

/datum/frame_step/proc/feedback_begin(datum/event_args/actor/actor, datum/frame2/frame_datum, obj/structure/frame2/frame, obj/item/tool, time_needed)
	// don't bother if it's that fast
	if(time_needed <= 0.5 SECONDS)
		return
	if(use_custom_feedback)
		// custom
		actor.visible_feedback(
			target = frame,
			visible = frame_datum.template_action_string(visible_text_begin, actor.performer, frame, tool),
			audible = frame_datum.template_action_string(audible_text_begin, actor.performer, frame, tool),
			otherwise_self = frame_datum.template_action_string(self_text_begin, actor.performer, frame, tool),
		)
	else
		// default
		standard_feedback_handling(actor, frame_datum, frame, tool, time_needed, TRUE)

/datum/frame_step/proc/feedback_finish(datum/event_args/actor/actor, datum/frame2/frame_datum, obj/structure/frame2/frame, obj/item/tool, time_taken)
	if(use_custom_feedback)
		// custom
		actor.visible_feedback(
			target = frame,
			visible = frame_datum.template_action_string(visible_text_end, actor.performer, frame, tool),
			audible = frame_datum.template_action_string(audible_text_end, actor.performer, frame, tool),
			otherwise_self = frame_datum.template_action_string(self_text_end, actor.performer, frame, tool),
		)
	else
		// default
		standard_feedback_handling(actor, frame_datum, frame, tool, time_taken, FALSE)

/datum/frame_step/proc/standard_feedback_handling(datum/event_args/actor/actor, datum/frame2/frame_datum, obj/structure/frame2/frame, obj/item/tool, time, beginning)
	switch(request_type)
		if(FRAME_REQUEST_TYPE_INTERACT)
			if(beginning)
				actor.visible_feedback(
					target = frame,
					range = MESSAGE_RANGE_CONSTRUCTION,
					visible = "[actor.performer] starts [action_text_leading || "tinkering with "][frame][action_text_trailing || "."]",
					audible = "You hear something being tinkered with.",
					otherwise_self = "You start [action_text_leading || "tinkering with "][frame][action_text_trailing || "."]",
				)
			else
				actor.visible_feedback(
					target = frame,
					range = MESSAGE_RANGE_CONSTRUCTION,
					visible = "[actor.performer] finishes [action_text_leading || "tinkering with "][frame][action_text_trailing || "."]",
					audible = "You hear something being tinkered with.",
					otherwise_self = "You finish [action_text_leading || "tinkering with "][frame][action_text_trailing || "."]",
				)
		if(FRAME_REQUEST_TYPE_ITEM)
			if(beginning)
				actor.visible_feedback(
					target = frame,
					range = MESSAGE_RANGE_CONSTRUCTION,
					visible = "[actor.performer] starts [action_text_leading || "tinkering with "][frame][action_text_trailing || " using [tool]."]",
					audible = "You hear something being tinkered with.",
					otherwise_self = "You start [action_text_leading || "tinkering with "][frame][action_text_trailing || " using [tool]."]",
				)
			else
				actor.visible_feedback(
					target = frame,
					range = MESSAGE_RANGE_CONSTRUCTION,
					visible = "[actor.performer] finishes [action_text_leading || "tinkering with "][frame][action_text_trailing || " using [tool]."]",
					audible = "You hear something being tinkered with.",
					otherwise_self = "You finish [action_text_leading || "tinkering with "][frame][action_text_trailing || " using [tool]."]",
				)
		if(FRAME_REQUEST_TYPE_MATERIAL, FRAME_REQUEST_TYPE_STACK)
			var/name_to_use
			if(request_type == FRAME_REQUEST_TYPE_MATERIAL)
				var/datum/material/resolved_material = SSmaterials.resolve_material(request)
				name_to_use = "[resolved_material.name || resolved_material.display_name] [resolved_material.sheet_plural_name]"
			else
				var/obj/item/stack/casted_stack = request
				name_to_use = casted_stack.name
			if(beginning)
				actor.visible_feedback(
					target = frame,
					range = MESSAGE_RANGE_CONSTRUCTION,
					visible = "[actor.performer] starts [action_text_leading || "inserting some [name_to_use] into "][frame][action_text_trailing || "."]",
					audible = "You hear something being tinkered with.",
					otherwise_self = "You start [action_text_leading || "inserting some [name_to_use] into "][frame][action_text_trailing || "."]",
				)
			else
				actor.visible_feedback(
					target = frame,
					range = MESSAGE_RANGE_CONSTRUCTION,
					visible = "[actor.performer] finishes [action_text_leading || "inserting some [name_to_use] into "][frame][action_text_trailing || "."]",
					audible = "You hear something being tinkered with.",
					otherwise_self = "You finish [action_text_leading || "inserting some [name_to_use] into "][frame][action_text_trailing || "."]",
				)
		if(FRAME_REQUEST_TYPE_TOOL)
			if(beginning)
				actor.visible_feedback(
					target = frame,
					range = MESSAGE_RANGE_CONSTRUCTION,
					visible = "[actor.performer] starts [action_text_leading || "tinkering with "][frame][action_text_trailing || " with [tool]."]",
					audible = "You hear something being tinkered with.",
					otherwise_self = "You start [action_text_leading || "tinkering with "][frame][action_text_trailing || " with [tool]."]",
				)
			else
				actor.visible_feedback(
					target = frame,
					range = MESSAGE_RANGE_CONSTRUCTION,
					visible = "[actor.performer] finishes [action_text_leading || "tinkering with "][frame][action_text_trailing || " with [tool]."]",
					audible = "You hear something being tinkered with.",
					otherwise_self = "You finish [action_text_leading || "tinkering with "][frame][action_text_trailing || " with [tool]."]",
				)
