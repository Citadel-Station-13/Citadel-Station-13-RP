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

/obj/structure/frame2/Initialize(mapload, datum/frame2/set_frame_to)
	if(!isnull(set_frame_to))
		frame = set_frame_to
	frame = fetch_frame_datum(frame)
	frame.apply_to_frame(src)
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
	var/datum/frame_stage/stage = frame.stages[stage]
	name = "[stage.name_prepend && "[stage.name_prepend] "][stage.name_override || frame.name][stage.name_append && " [stage.name_append]"]"
	return ..()

/obj/structure/frame2/examine(mob/user, dist)
	. = ..()
	frame.on_examine(src, new /datum/event_args/actor(user), ., dist)

/obj/structure/frame2/dynamic_tool_query(obj/item/I, datum/event_args/actor/clickchain/e_args)
	return merge_double_lazy_assoc_list(frame.on_tool_query(src, I, e_args), ..())

/obj/structure/frame2/tool_act(obj/item/I, datum/event_args/actor/clickchain/e_args, function, flags, hint)
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
