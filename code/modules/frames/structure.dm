//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

// todo: rename to just 'frame' from 'frame2' after all old frames are converted.
/obj/structure/frame2
	name = "construction frame"
	desc = "if you see this, yell at coders"
	icon = 'icons/modules/frames/base.dmi'
	icon_state = "structure"

	/// frame datum; set to typepath to default to that on init
	var/datum/frame2/frame

	/// current stage
	var/stage
	/// current context
	// todo: context system proper?
	var/list/context

#warn impl

/obj/structure/frame2/Initialize(mapload, datum/frame2/set_frame_to)
	if(!isnull(set_frame_to))
		frame = set_frame_to
	frame = fetch_frame_datum(frame)
	frame.apply_to_frame(src)
	#warn /obj rotation system
	return ..()

/obj/structure/frame2/proc/set_context(key, value)
	LAZYSET(context, key, value)

/obj/structure/frame2/proc/get_context(key)
	return context?[key]

/obj/structure/frame2/update_icon_state()
	. = ..()
	#warn impl

/obj/structure/frame2/examine(mob/user, dist)
	. = ..()
	frame.on_examine(src, new /datum/event_args/actor(user), .)

/obj/structure/frame2/dynamic_tool_query(obj/item/I, datum/event_args/actor/clickchain/e_args)
	return merge_double_lazy_assoc_list(frame.on_tool_query(src, I, e_args), ..())

/obj/structure/frame2/tool_act(obj/item/I, datum/event_args/actor/clickchain/e_args, function, flags, hint)
	. = ..()



#warn tool system integration
