//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

// todo: rename to just 'frame' from 'frame2' after all old frames are converted.
/obj/structure/frame2
	name = "construction frame"
	desc = "if you see this, yell at coders"
	#warn default sprite

	/// frame datum; set to typepath to default to that on init
	var/datum/frame2/frame

	/// current stage
	var/stage
	/// current context
	var/list/context

#warn impl

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
	. = ..()
	#warn impl
