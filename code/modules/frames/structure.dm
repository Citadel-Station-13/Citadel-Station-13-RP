//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

// todo: rename to just 'frame' from 'frame2' after all old frames are converted.
/obj/structure/frame2
	name = "construction frame"
	desc = "if you see this, yell at coders"
	icon = 'icons/modules/frames/base.dmi'
	icon_state = "structure"

	climb_knockable = TRUE
	obj_rotation_flags = OBJ_ROTATION_ENABLED

	/// frame datum; set to typepath to default to that on init
	var/datum/frame2/frame

	/// current stage
	var/stage
	/// current context
	// todo: frame context system proper?
	var/list/context

/obj/structure/frame2/Initialize(mapload, dir, datum/frame2/set_frame_to, stage_id, list/context)
	var/datum/frame2/applying_frame = fetch_frame_datum(set_frame_to || src.frame)
	src.context = context || list()
	setDir(dir)
	if(!length(applying_frame.stages))
		applying_frame.finish_frame(src)
		return INITIALIZE_HINT_QDEL
	src.stage = stage_id || applying_frame.stage_starting || stack_trace("no stage...")
	src.frame = applying_frame
	src.frame.apply_to_frame(src)
	return ..()

/obj/structure/frame2/proc/set_context(key, value)
	LAZYSET(context, key, value)

/obj/structure/frame2/proc/get_context(key)
	return context?[key]

/obj/structure/frame2/update_icon_state()
	icon_state = "structure[frame.has_structure_stage_states? "-[stage]" : ""]"
	return ..()

/obj/structure/frame2/update_overlays()
	. = ..()
	. += frame.get_overlays(src)

/obj/structure/frame2/update_name()
	var/datum/frame_stage/frame_stage = frame.stages[stage]
	name = "[frame_stage.name_prepend && "[frame_stage.name_prepend] "][frame_stage.name_override || frame.name][frame_stage.name_append && " [frame_stage.name_append]"]"
	return ..()

/obj/structure/frame2/drop_products(method, atom/where)
	. = ..()
	frame.drop_deconstructed_products(method, where, stage, context)

/obj/structure/frame2/examine(mob/user, dist)
	. = ..()
	frame.on_examine(src, new /datum/event_args/actor(user), ., dist)

/obj/structure/frame2/dynamic_tool_query(obj/item/I, datum/event_args/actor/clickchain/e_args)
	// please don't hurt me lohikar
	. = list()
	if(frame.freely_anchorable && frame.anchor_tool)
		.[frame.anchor_tool] = list(
			"[anchored? "unanchor" : "anchor"]" = anchored? dyntool_image_backward(frame.anchor_tool) : dyntool_image_forward(frame.anchor_tool),
		)
	. = merge_double_lazy_assoc_list(frame.on_tool_query(src, I, e_args), .)
	. = merge_double_lazy_assoc_list(., ..())

/obj/structure/frame2/proc/still_anchored(anchorvalue)
	return anchored == anchorvalue

/obj/structure/frame2/tool_act(obj/item/I, datum/event_args/actor/clickchain/e_args, function, flags, hint)
	if(frame.freely_anchorable && frame.anchor_tool == function)
		var/datum/frame_stage/current_stage = frame.stages[stage]
		// if anchored, and either: current stage allow_unanchor is set to FALSE (not null) OR it's to null
		// and the frame is requiring anchored and the frame's not on its starting stage, do not allow unanchoring.
		if(anchored && (isnull(current_stage.allow_unanchor)? (frame.requires_anchored? frame.stage_starting != stage : FALSE) : !current_stage.allow_unanchor))
			e_args.chat_feedback(
				SPAN_WARNING("[src] cannot be unanchored while in this stage!"),
				target = src,
			)
			return CLICKCHAIN_DO_NOT_PROPAGATE
		if(frame.anchor_time)
			e_args.visible_feedback(
				target = src,
				range = MESSAGE_RANGE_CONSTRUCTION,
				visible = SPAN_NOTICE("[e_args.performer] starts to [anchored? "unbolt" : "bolt"] [src] [anchored? "from" : "to"] the floor."),
				otherwise_self = SPAN_NOTICE("You begin to [anchored? "unbolt" : "bolt"] [src] [anchored? "from" : "to"] the floor."),
			)
			log_construction(e_args, src, "started [anchored? "unanchoring" : "anchoring"]")
			if(!use_tool(function, I, e_args, flags, frame.anchor_time))
				return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
		set_anchored(!anchored)
		log_construction(e_args, src, "[anchored? "anchored" : "unanchored"]")
		e_args.visible_feedback(
			target = src,
			range = MESSAGE_RANGE_CONSTRUCTION,
			visible = SPAN_NOTICE("[e_args.performer] [anchored? "bolts" : "unbolts"] [src] [anchored? "to" : "from"] the floor."),
			audible = SPAN_WARNING("You hear a set of bolts being [anchored? "fastened" : "undone"]."),
			otherwise_self = SPAN_NOTICE("You [anchored? "bolt" : "unbolt"] [src] [anchored? "to" : "from"] the floor."),
		)
		return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
	if(frame.on_tool(src, I, e_args, function, flags, hint))
		// todo: did something might be sent even if we .. didn't do anything successfully.
		return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
	return ..()

/obj/structure/frame2/on_attack_hand(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return
	if(frame.on_interact(src, clickchain))
		return CLICKCHAIN_DID_SOMETHING

/obj/structure/frame2/attackby(obj/item/I, mob/user, list/params, clickchain_flags, damage_multiplier)
	if(user.a_intent == INTENT_HARM)
		return ..()
	if(frame.on_item(src, I, new /datum/event_args/actor/clickchain(user)))
		return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
	return ..()
