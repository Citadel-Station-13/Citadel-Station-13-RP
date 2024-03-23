//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/obj/item/frame2
	name = "entity frame"
	desc = "Why do you see this? Contact a coder."
	icon_state = "item"

	/// frame datum - set to typepath for initialization
	var/datum/frame2/frame
	/// our cached image for hover
	var/image/hover_image
	/// viewing clients
	var/list/client/viewing

#warn impl

/obj/item/frame2/MouseEntered(location, control, params)
	..()
	if(!usr?.client)
		return

/obj/item/frame2/MouseExited(location, control, params)
	if(!usr?.client)
		return

#warn arrow image

/obj/item/frame2/tool_act(obj/item/I, datum/event_args/actor/clickchain/e_args, function, flags, hint)
	. = ..()

/obj/item/frame2/dynamic_tool_query(obj/item/I, datum/event_args/actor/clickchain/e_args, list/hint_images)
	. = ..()

#warn decon
