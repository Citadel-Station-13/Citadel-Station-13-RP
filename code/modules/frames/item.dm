//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/obj/item/frame2
	name = "entity frame"
	desc = "Why do you see this? Contact a coder."
	icon = 'icons/modules/frames/base.dmi'
	icon_state = "item"

	item_flags = ITEM_NO_BLUDGEON
	obj_rotation_flags = OBJ_ROTATION_ENABLED | OBJ_ROTATION_DEFAULTING

	/// frame datum - set to typepath for initialization
	var/datum/frame2/frame
	/// our cached image for hover
	var/image/hover_image
	/// viewing clients
	var/list/client/viewing

/obj/item/frame2/Initialize(mapload, datum/frame2/frame)
	. = ..()
	if(!isnull(frame))
		src.frame = frame
	if(ispath(src.frame))
		src.frame = fetch_frame_datum(src.frame)
	sync_frame(src.frame)

/obj/item/frame2/Destroy()
	for(var/client/C as anything in viewing)
		hide_frame_image(C)
	return ..()

/obj/item/frame2/proc/sync_frame(datum/frame2/frame)
	name = "[frame.name]"
	icon = frame.icon
	icon_state = "item"
	w_class = frame.item_weight_class
	weight_volume = frame.item_weight_volume

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
	show_frame_image(usr.client)

/obj/item/frame2/MouseExited(location, control, params)
	..()
	if(!usr?.client)
		return
	hide_frame_image(usr.client)

/obj/item/frame2/proc/show_frame_image(client/C)
	LAZYDISTINCTADD(viewing, C)
	C.images += get_hover_image()
	RegisterSignal(C, COMSIG_PARENT_QDELETING, PROC_REF(on_client_delete))

/obj/item/frame2/proc/hide_frame_image(client/C)
	LAZYREMOVE(viewing, C)
	C.images -= get_hover_image()
	UnregisterSignal(C, COMSIG_PARENT_QDELETING)

	if(!length(viewing))
		hover_image = null

/obj/item/frame2/proc/on_client_delete(datum/source)
	hide_frame_image(source)

/obj/item/frame2/proc/get_hover_image()
	if(isnull(hover_image))
		// todo: big/multi-tile frame support
		hover_image = image('icons/modules/frames/base.dmi', "arrow")
		hover_image.loc = src
		hover_image.filters = list(
			filter(type = "outline", size = 1, color = "#aaffaa77"),
		)
	update_hover_image()
	return hover_image

/obj/item/frame2/proc/update_hover_image()
	if(isnull(hover_image))
		return
	hover_image.pixel_x = 0
	hover_image.pixel_y = 0
	switch(dir)
		if(NORTH)
			hover_image.pixel_y = 12
		if(SOUTH)
			hover_image.pixel_y = -12
		if(EAST)
			hover_image.pixel_x = 12
		if(WEST)
			hover_image.pixel_x = -12

/obj/item/frame2/setDir(ndir)
	. = ..()
	if(!.)
		return
	update_hover_image()

/obj/item/frame2/on_attack_self(datum/event_args/actor/e_args)
	. = ..()
	if(.)
		return
	if(frame.item_deploy_requires_tool)
		e_args.chat_feedback(SPAN_WARNING("[src] requires the use of a [frame.item_deploy_tool] to be deployed!"), src)
		return TRUE
	var/use_dir = e_args.performer.dir
	//! shitcode for wallmounts
	if(frame.wall_frame)
		use_dir = turn(use_dir, 180)
	//! end
	if(!can_deploy(e_args, use_dir, e_args.performer.loc))
		return TRUE
	if(frame.item_deploy_time)
		e_args.visible_feedback(
			target = src,
			range = MESSAGE_RANGE_CONSTRUCTION,
			visible = SPAN_WARNING("[e_args.performer] starts to deploy [src]."),
			audible = SPAN_WARNING("You hear something being assembled."),
			otherwise_self = SPAN_WARNING("You start to deploy [src]."),
		)
		log_construction(e_args, src, "started deploying")
	if(!do_after(e_args.performer, frame.item_deploy_time, src, mobility_flags = MOBILITY_CAN_USE))
		return TRUE
	if(!attempt_deploy(e_args, use_dir = use_dir, use_loc = e_args.performer.loc))
		return TRUE
	e_args.visible_feedback(
		target = src,
		range = MESSAGE_RANGE_CONSTRUCTION,
		visible = SPAN_WARNING("[e_args.performer] deploys [src]."),
		audible = SPAN_WARNING("You hear something finish being assembled."),
		otherwise_self = SPAN_WARNING("You deploy [src]."),
	)
	return TRUE

/obj/item/frame2/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	if(!frame.wall_frame)
		return ..()
	if(!user.Adjacent(target))
		return ..()
	var/use_dir = get_dir(user, target)
	var/datum/event_args/actor/e_args = new(user)
	if(IS_DIAGONAL(use_dir))
		e_args.chat_feedback(SPAN_WARNING("You must be standing cardinally to [target] to attempt a deployment there!"), src)
		return CLICKCHAIN_DO_NOT_PROPAGATE
	//! shitcode for wallmounts
	if(frame.wall_frame)
		use_dir = turn(use_dir, 180)
	//! end
	if(frame.item_deploy_requires_tool)
		e_args.chat_feedback(SPAN_WARNING("[src] requires the use of a [frame.item_deploy_tool] to be deployed!"), src)
		return CLICKCHAIN_DO_NOT_PROPAGATE
	if(!can_deploy(e_args, use_dir, e_args.performer.loc))
		return CLICKCHAIN_DO_NOT_PROPAGATE
	if(frame.item_deploy_time)
		e_args.visible_feedback(
			target = src,
			range = MESSAGE_RANGE_CONSTRUCTION,
			visible = SPAN_WARNING("[e_args.performer] starts to deploy [src]."),
			audible = SPAN_WARNING("You hear something being assembled."),
			otherwise_self = SPAN_WARNING("You start to deploy [src]."),
		)
		log_construction(e_args, src, "started deploying")
	if(!do_after(e_args.performer, frame.item_deploy_time, src, mobility_flags = MOBILITY_CAN_USE))
		return CLICKCHAIN_DO_NOT_PROPAGATE
	if(!attempt_deploy(e_args, use_dir, use_loc = e_args.performer.loc))
		return CLICKCHAIN_DO_NOT_PROPAGATE
	e_args.visible_feedback(
		target = src,
		range = MESSAGE_RANGE_CONSTRUCTION,
		visible = SPAN_WARNING("[e_args.performer] deploys [src]."),
		audible = SPAN_WARNING("You hear something finish being assembled."),
		otherwise_self = SPAN_WARNING("You deploy [src]."),
	)
	return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING

/obj/item/frame2/proc/can_deploy(datum/event_args/actor/e_args, use_dir = src.dir, use_loc = src.loc, silent)
	if(!isturf(use_loc))
		if(!silent)
			e_args?.chat_feedback(SPAN_WARNING("[src] must be on the floor to be deployed!"), src)
		return FALSE
	if(!frame.deployment_checks(src, use_loc, use_dir, e_args))
		return FALSE
	return TRUE

/obj/item/frame2/proc/attempt_deploy(datum/event_args/actor/e_args, use_dir = src.dir, use_loc = src.loc, silent)
	if(!can_deploy(e_args, use_dir, use_loc, silent))
		return FALSE
	return deploy(e_args, use_dir, use_loc)

/obj/item/frame2/proc/deploy(datum/event_args/actor/e_args, use_dir = src.dir, use_loc = src.loc)
	if(!isturf(use_loc))
		CRASH("non turf?")
	frame.deploy_frame(src, e_args, use_loc, use_dir)
	log_construction(e_args, src, "deployed")

/obj/item/frame2/context_menu_query(datum/event_args/actor/e_args)
	. = ..()
	.["deploy-frame"] = create_context_menu_tuple("deploy", image(src), 1, MOBILITY_CAN_USE)

/obj/item/frame2/context_menu_act(datum/event_args/actor/e_args, key)
	. = ..()
	if(.)
		return
	switch(key)
		if("deploy-frame")
			if(!e_args.performer.Reachability(src))
				e_args.chat_feedback(SPAN_WARNING("You can't reach [src] right now!"), src)
				return TRUE
			var/use_dir = src.dir
			//! shitcode for wallmounts
			if(frame.wall_frame)
				use_dir = turn(use_dir, 180)
			//! end
			if(frame.item_deploy_requires_tool)
				e_args.chat_feedback(SPAN_WARNING("[src] requires the use of a [frame.item_deploy_tool] to be deployed!"), src)
				return CLICKCHAIN_DO_NOT_PROPAGATE
			if(!can_deploy(e_args, use_dir, loc))
				return CLICKCHAIN_DO_NOT_PROPAGATE
			if(frame.item_deploy_time)
				e_args.visible_feedback(
					target = src,
					range = MESSAGE_RANGE_CONSTRUCTION,
					visible = SPAN_WARNING("[e_args.performer] starts to deploy [src]."),
					audible = SPAN_WARNING("You hear something being assembled."),
					otherwise_self = SPAN_WARNING("You start to deploy [src]."),
				)
				log_construction(e_args, src, "started deploying")
			if(!do_after(e_args.performer, frame.item_deploy_time, src, mobility_flags = MOBILITY_CAN_USE))
				return CLICKCHAIN_DO_NOT_PROPAGATE
			attempt_deploy(e_args, use_dir = use_dir)
			return TRUE

/obj/item/frame2/drop_products(method, atom/where)
	. = ..()
	frame.drop_deconstructed_products(method, where, null, list())

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
		deconstruct(ATOM_DECONSTRUCT_DISASSEMBLED)
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
		if(!attempt_deploy(e_args))
			return CLICKCHAIN_DO_NOT_PROPAGATE
		e_args.visible_feedback(
			target = src,
			range = MESSAGE_RANGE_CONSTRUCTION,
			visible = SPAN_WARNING("[e_args.performer] deploys [src]."),
			audible = SPAN_WARNING("You hear something finish being assembled."),
			otherwise_self = SPAN_WARNING("You deploy [src]."),
		)
		return CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE
	return ..()

/obj/item/frame2/dynamic_tool_query(obj/item/I, datum/event_args/actor/clickchain/e_args, list/hint_images)
	. = list()
	if(frame.item_recycle_tool)
		LAZYSET(.[frame.item_recycle_tool], "recycle", dyntool_image_neutral(frame.item_recycle_tool))
	if(frame.item_deploy_tool)
		LAZYSET(.[frame.item_deploy_tool], "deploy", dyntool_image_neutral(frame.item_deploy_tool))
	return merge_double_lazy_assoc_list(., ..())
