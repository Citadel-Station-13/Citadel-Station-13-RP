//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/obj/item/frame2
	name = "entity frame"
	desc = "Why do you see this? Contact a coder."
	icon = 'icons/modules/frames/base.dmi'
	icon_state = "item"

	/// frame datum - set to typepath for initialization
	var/datum/frame2/frame
	/// our cached image for hover
	var/image/hover_image
	/// viewing clients
	var/list/client/viewing

#warn impl

/obj/item/frame2/Initialize(mapload, datum/frame2/frame)
	. = ..()
	if(!isnull(frame))
		src.frame = frame
	else if(ispath(src.frame))
		src.frame = fetch_frame_datum(src.frame)
	sync_frame(src.frame)
	#warn rotation support

/obj/item/frame2/proc/sync_frame(datum/frame2/frame)
	name = "[frame.name]"
	icon = frame.icon
	icon_state = "item"

/obj/item/frame2/examine(mob/user, dist)
	. = ..()
	if(!frame.item_deploy_requires_tool)
		if(frame.wall_frame)
			. += SPAN_NOTICE("Use it on a wall, window, or other 'wall-like' object to attach the frame.")
		else
			. += SPAN_NOTICE("Use it in hand to deploy it in the direction you are looking at.")
	if(frame.item_deploy_tool)
		. += SPAN_NOTICE("Use a <b>[frame.item_deploy_tool]</b> on it to deploy it in its current direction.")
	if(frame.item_recycle_tool)
		. += SPAN_NOTICE("Use a <b>[frame.item_recycle_tool]</b> on it to deconstruct it back into material sheets.")

/obj/item/frame2/MouseEntered(location, control, params)
	..()
	if(!usr?.client)
		return

/obj/item/frame2/MouseExited(location, control, params)
	if(!usr?.client)
		return

/obj/item/frame2/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	. = ..()

/obj/item/frame2/on_attack_self(datum/event_args/actor/e_args)
	. = ..()

#warn arrow image

/obj/item/frame2/tool_act(obj/item/I, datum/event_args/actor/clickchain/e_args, function, flags, hint)
	if(function == frame.item_recycle_tool)
		if(frame.item_recycle_time)
			e_args.visible_feedback(
				target = src,
				range = MESSAGE_RANGE_CONSTRUCTION,
				visible = SPAN_WARNING("[e_args.performer] starts to recycle [src]."),
				audible = SPAN_WARNING("You hear someone starting to disassemble something."),
				otherwise_self = SPAN_WARNING("You start to recycle [src]."),
			)
			log_construction(e_args, src, "started recycling")
		if(!use_tool(function, I, e_args, flags, frame.item_recycle_time, frame.item_recycle_cost))
			return CLICKCHAIN_DO_NOT_PROPAGATE
		e_args.visible_feedback(
			target = src,
			range = MESSAGE_RANGE_CONSTRUCTION,
			visible = SPAN_WARNING("[e_args.performer] disassembles [src] back into raw material."),
			audible = SPAN_WARNING("You hear something being disassembled back into raw material."),
			otherwise_self = SPAN_WARNING("You recycle [src] back into raw material."),
		)
		log_construction(e_args, src, "recycled")
		new /obj/item/stack/material/steel(drop_location(), frame.material_cost)
		qdel(src)
		return CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE
	if(function == frame.item_deploy_tool)
		if(frame.item_deploy_time)
			e_args.visible_feedback(
				target = src,
				range = MESSAGE_RANGE_CONSTRUCTION,
				visible = SPAN_WARNING("[e_args.performer] starts to deploy [src]."),
				audible = SPAN_WARNING("You hear something being assembled."),
				otherwise_self = SPAN_WARNING("You start to deploy [src]."),
			)
			log_construction(e_args, src, "started deploying")
		if(!use_tool(function, I, e_args, flags, frame.item_deploy_time, frame.item_deploy_cost))
			return CLICKCHAIN_DO_NOT_PROPAGATE
		e_args.visible_feedback(
			target = src,
			range = MESSAGE_RANGE_CONSTRUCTION,
			visible = SPAN_WARNING("[e_args.performer] deploys [src]."),
			audible = SPAN_WARNING("You hear something finish being assembled."),
			otherwise_self = SPAN_WARNING("You deploy [src]."),
		)
		log_construction(e_args, src, "deployed")
		new /obj/item/stack/material/steel(drop_location(), frame.material_cost)
		qdel(src)
		return CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE
	return ..()

/obj/item/frame2/dynamic_tool_query(obj/item/I, datum/event_args/actor/clickchain/e_args, list/hint_images)
	. = list()
	if(frame.item_recycle_tool)
		LAZYSET(.[frame.item_recycle_tool], "recycle", dyntool_image_neutral(frame.item_recycle_tool))
	if(frame.item_deploy_tool)
		LAZYSET(.[frame.item_deploy_tool], "deploy", dyntool_image_neutral(frame.item_deploy_tool))
	return merge_double_lazy_assoc_list(., ..())
