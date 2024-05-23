//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

// todo: rename to just 'frame' from 'frame2' after all old frames are converted.
/obj/structure/frame2
	name = "construction frame"
	desc = "if you see this, yell at coders"
	icon = 'icons/modules/frames/base.dmi'
	icon_state = "structure"

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
	src.stage = stage_id || applying_frame.stage_starting || stack_trace("no stage...")
	setDir(dir)
	src.frame = applying_frame
	src.frame.apply_to_frame(src)
	if(!length(applying_frame.stages))
		applying_frame.finish_frame(src)
		return INITIALIZE_HINT_QDEL
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
		if(frame.anchor_time)
			log_construction(e_args, src, "started [anchored? "unanchoring" : "anchoring"]")
			if(!use_tool(function, I, e_args, flags, frame.anchor_time))
				return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
		set_anchored(!anchored)
		log_construction(e_args, src, "[anchored? "anchored" : "unanchored"]")
		return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
	if(frame.on_tool(src, I, e_args, function, flags, hint))
		// todo: did something might be sent even if we .. didn't do anything successfully.
		return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
	return ..()

/obj/structure/frame2/on_attack_hand(datum/event_args/actor/clickchain/e_args)
	. = ..()
	if(.)
		return
	if(frame.on_interact(src, e_args))
		return TRUE

/obj/structure/frame2/attackby(obj/item/I, mob/user, list/params, clickchain_flags, damage_multiplier)
	if(user.a_intent == INTENT_HARM)
		return ..()
	if(frame.on_item(src, I, new /datum/event_args/actor/clickchain(user)))
		return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
	return ..()
