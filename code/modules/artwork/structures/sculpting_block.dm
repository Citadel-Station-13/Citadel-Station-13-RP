//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * Dynamic sculpting!
 *
 * Later to replace statues entirely.
 *
 * Sprites generously 'borrowed' from /tg/station.
 * Idea is from /tg/station, but entirely reimplemented here.
 *
 * stay awesome tg (:
 *
 * todo: add in a way to preload a template so it starts out sculpted, and an initialize() override for such
 * todo: de/serialization
 * todo: sculpting with shit tools should result in a bad image
 * todo: the full white alpha masks should be cached
 */
/obj/structure/sculpting_block
	name = "material block"
	desc = "A block of material. You can sculpt this with appropriate tools, like a screwdriver."
	icon = 'icons/modules/artwork/sculpting.dmi'
	icon_state = "block"
	density = TRUE
	anchored = FALSE

	/// finished base state
	var/sculpture_base_state = "base"
	/// material ref
	var/datum/prototype/material/material = /datum/prototype/material/steel

	icon_x_dimension = 32
	icon_y_dimension = 32
	bound_width = 32
	bound_height = 32

	/// is this sculpture finished?
	var/finished = FALSE
	/// sculpture x alignment offset
	var/alignment = 0

	/// currently being sculpted
	var/sculpting = FALSE
	/// current icon being sculpted
	var/icon/sculpting_buffer
	/// y start; this is set to sculpting_line at the start of an operation
	var/sculpting_line_start
	/// y end; this is set after end of sculpting right before we blend it into our icon
	var/sculpting_line_end
	/// is the model overlaid yet? for ones that get aligned to bottom, we don't overlay immediately.
	var/sculpting_overlay_active
	/// scultping user, if any
	var/mob/sculpting_user
	/// sculpting target
	var/atom/movable/sculpting_target

	/// current icon for sculpting; every operation flushes to this, this begins at a x by y blank.
	/// we don't flush directly to our icon only because icon might get fucked with
	/// list(north, east, south, west)
	var/list/icon/sculpting_slates
	/// current combined slates
	var/icon/sculpting_built
	/// sculpting block is assumed to be a certain size
	/// store the current line being sculpted
	/// this starts at the topmost y
	/// if we're done sculpting, this should be nulled for consistency
	var/sculpting_line
	/// virtual vis contents holder for buffer
	var/atom/movable/sculpting_render/sculpting_renderer
	/// slate dimension y
	var/slate_dimension_y
	/// slate dimension x
	var/slate_dimension_x
	/// amount of time it takes to sculpt one line at 1x toolspeed
	var/sculpting_hardness = 0.5 SECONDS
	/// sculpting mask for our slate
	var/icon/sculpting_mask
	/// sculpting mask for our block
	var/icon/sculpting_rolldown_mask

/obj/structure/sculpting_block/Initialize(mapload, datum/prototype/material/material_like)
	// todo: materials system
	if(!isnull(material_like))
		var/resolved_material = RSmaterials.fetch_or_defer(material_like)
		switch(resolved_material)
			if(REPOSITORY_FETCH_DEFER)
				// todo: handle
			else
				src.material = resolved_material || RSmaterials.fetch_local_or_throw(/datum/prototype/material/steel)
	// todo: if it autoinit'd, don't do this
	reset_sculpting()
	return ..()

/obj/structure/sculpting_block/Destroy()
	QDEL_NULL(sculpting_renderer)
	sculpting_mask = null
	sculpting_rolldown_mask = null
	sculpting_buffer = null
	sculpting_built = null
	sculpting_slates = null
	return ..()

/obj/structure/sculpting_block/examine(mob/user, dist)
	. = ..()
	. += SPAN_NOTICE("It is made out of <b>[isnull(material)? "nothing?!": "[material.display_name]."]</b>")
	. += SPAN_NOTICE("Use a <b>wrench</b> to un/fasten the anchoring bolts.")
	. += SPAN_NOTICE("Use a <b>welder</b> to slice it apart.")

/obj/structure/sculpting_block/proc/reset_sculpting()
	sculpting_line = icon_y_dimension
	finished = FALSE
	remove_filter("top_erasure")
	update_appearance()

/obj/structure/sculpting_block/update_icon(updates)
	if(length(underlays))
		underlays.len = 0
	cut_overlays()
	if(sculpting_built)
		var/image/render = new
		render.icon = sculpting_built
		render.appearance_flags = KEEP_APART | RESET_COLOR
		add_overlay(render)
	. = ..()
	var/image/stand = image(initial(icon), icon_state = sculpture_base_state)
	stand.appearance_flags = KEEP_APART | RESET_COLOR
	stand.pixel_x = -alignment
	underlays += stand

/obj/structure/sculpting_block/attackby(obj/item/I, mob/living/user, list/params, clickchain_flags, damage_multiplier)
	if(user.a_intent == INTENT_HARM)
		return ..()
	if(user.a_intent == INTENT_HELP)
		initiate_sculpting(user, tool = I)
		return CLICKCHAIN_DO_NOT_PROPAGATE

/obj/structure/sculpting_block/wrench_act(obj/item/I, datum/event_args/actor/clickchain/e_args, flags, hint)
	. = ..()
	if(.)
		return
	e_args.visible_feedback(
		target = src,
		range = MESSAGE_RANGE_CONSTRUCTION,
		visible = SPAN_NOTICE("[e_args.performer] starts [anchored? "unbolting [src] from the floor" : "bolting [src] to the floor"]."),
		audible = SPAN_WARNING("You hear bolts being [anchored? "unfastened" : "fastened"]."),
		otherwise_self = SPAN_NOTICE("You start [anchored? "unbolting [src] from the floor" : "bolting [src] to the floor"]."),
	)
	log_construction(e_args, src, "started [anchored? "unanchoring" : "anchoring"]")
	if(!use_wrench(I, e_args, flags, 3 SECONDS))
		return TRUE
	e_args.visible_feedback(
		target = src,
		range = MESSAGE_RANGE_CONSTRUCTION,
		visible = SPAN_NOTICE("[e_args.performer] finishes [anchored? "unbolting [src] from the floor" : "bolting [src] to the floor"]."),
		audible = SPAN_WARNING("You hear bolts [anchored? "falling out" : "clicking into place"]."),
		otherwise_self = SPAN_NOTICE("You finish [anchored? "unbolting [src] from the floor" : "bolting [src] to the floor"]."),
	)
	log_construction(e_args, src, "[anchored? "unanchored" : "anchored"]")
	set_anchored(!anchored)
	return TRUE

/obj/structure/sculpting_block/welder_act(obj/item/I, datum/event_args/actor/clickchain/e_args, flags, hint)
	. = ..()
	if(.)
		return
	e_args.visible_feedback(
		target = src,
		range = MESSAGE_RANGE_CONSTRUCTION,
		visible = SPAN_NOTICE("[e_args.performer] starts slicing [src] apart."),
		audible = SPAN_WARNING("You hear the sound of a welding torch being used on something metallic."),
		otherwise_self = SPAN_NOTICE("You start slicing [src] apart."),
	)
	log_construction(e_args, src, "started deconstructing")
	if(!use_welder(I, e_args, flags, 7 SECONDS))
		return TRUE
	e_args.visible_feedback(
		target = src,
		range = MESSAGE_RANGE_CONSTRUCTION,
		visible = SPAN_NOTICE("[e_args.performer] slices [src] apart."),
		audible = SPAN_WARNING("You hear the sound of a welding torch moving back into open air, and a few pieces of metal falling apart."),
		otherwise_self = SPAN_NOTICE("You slice [src] apart."),
	)
	log_construction(e_args, src, "deconstructed")
	set_anchored(!anchored)
	deconstruct(ATOM_DECONSTRUCT_DISASSEMBLED)
	return TRUE

/obj/structure/sculpting_block/drop_products(method)
	. = ..()
	material.place_sheet(drop_location(), 10)

/obj/structure/sculpting_block/dynamic_tool_query(obj/item/I, datum/event_args/actor/clickchain/e_args, list/hint_images = list())
	. = list()
	LAZYSET(.[TOOL_WRENCH], anchored? "unanchor" : "anchor", anchored? dyntool_image_backward(TOOL_WRENCH) : dyntool_image_forward(TOOL_WRENCH))
	LAZYSET(.[TOOL_WELDER], "deconstruct", dyntool_image_backward(TOOL_WELDER))
	return merge_double_lazy_assoc_list(., ..())

/**
 * returns speed multiplier, or null if not tool
 */
/obj/structure/sculpting_block/proc/is_sculpting_tool(obj/item/tool, mob/user)
	// todo: well fucking obviously we don't want to just have only screwdrivers usable, right gang? ~silicons
	if(tool.is_screwdriver())
		return tool.tool_speed
	return null

/obj/structure/sculpting_block/proc/initiate_sculpting(mob/user, silent, atom/movable/forced_target, obj/item/tool)
	if(TIMER_COOLDOWN_CHECK(src, CD_INDEX_SCULPTING_COOLDOWN))
		if(!silent)
			user?.action_feedback(SPAN_WARNING("[src] was worked on too recently.."), src)
		return FALSE
	if(finished)
		if(!silent)
			user?.action_feedback(SPAN_WARNING("[src] is finished."), src)
		return FALSE
	if(sculpting)
		if(!silent)
			user?.action_feedback(SPAN_WARNING("Someone's already working on [src]."), src)
		return FALSE
	if(isnull(tool))
		tool = user.get_active_held_item()
	var/tool_multiplier = is_sculpting_tool(tool)
	if(isnull(tool_multiplier))
		if(!silent)
			user?.action_feedback(SPAN_WARNING("You must be holding a valid sculpting tool."), src)
		return FALSE
	var/atom/movable/target = isnull(forced_target)? ask_for_target(user) : forced_target
	if(isnull(target))
		return FALSE
	if(tool != user.get_active_held_item())
		return FALSE
	if(finished)
		if(!silent)
			user?.action_feedback(SPAN_WARNING("[src] is finished."), src)
		return FALSE
	if(sculpting)
		if(!silent)
			user?.action_feedback(SPAN_WARNING("Someone's already working on [src]."), src)
		return FALSE
	if(!user.Adjacent(src))
		return FALSE

	sculpting = TRUE

	var/list/model_tuple = get_model_tuple(target)
	TIMER_COOLDOWN_START(src, CD_INDEX_SCULPTING_COOLDOWN, 1 SECONDS)
	var/icon/model = model_tuple[1]
	var/model_width = model.Width()
	var/model_height = model.Height()
	if(model_height > icon_y_dimension)
		if(!silent)
			user.action_feedback(SPAN_WARNING("[target] is too tall."), src)
		sculpting = FALSE
		return FALSE
	// align
	var/model_x_align = 0
	if(isnull(slate_dimension_x))
		slate_dimension_x = icon_x_dimension
	if(isnull(slate_dimension_y))
		slate_dimension_y = icon_y_dimension
	// align to bottom, center width
	if(model_width != slate_dimension_x)
		model_x_align = FLOOR((slate_dimension_x - model_width) / 2, 1)

	sculpting_buffer = model
	sculpting_user = user
	sculpting_target = target
	sculpting_line_start = sculpting_line
	sculpting_overlay_active = model_height >= sculpting_line

	var/lines = 0

	if(isnull(sculpting_rolldown_mask))
		sculpting_rolldown_mask = icon('icons/system/color_32x32.dmi', "white")
	if(sculpting_rolldown_mask.Width() != icon_x_dimension || sculpting_rolldown_mask.Height() != icon_y_dimension)
		sculpting_rolldown_mask.Scale(icon_x_dimension, icon_y_dimension)

	if(isnull(sculpting_renderer))
		sculpting_renderer = new
		vis_contents += sculpting_renderer

	sculpting_renderer.icon = sculpting_buffer
	sculpting_renderer.pixel_x = model_x_align
	sculpting_renderer.alpha = sculpting_overlay_active? initial(sculpting_renderer.alpha) : 0

	if(isnull(sculpting_mask))
		sculpting_mask = icon('icons/system/color_32x32.dmi', "white")
	if(sculpting_mask.Width() != model_width || sculpting_mask.Height() != model_height)
		sculpting_mask.Scale(model_width, model_height)

	if(sculpting_overlay_active)
		sculpting_renderer.add_filter("slate", 0, alpha_mask_filter(0, sculpting_line - model_height, sculpting_mask, flags = MASK_INVERSE))
		sculpting_renderer.add_filter("cut_excess", 0, alpha_mask_filter(0, sculpting_line, sculpting_mask, flags = MASK_INVERSE))

	// todo: actual chisels wit htoolsounds, screwdrivers are dogshit
	playsound(src, 'sound/effects/break_stone.ogg', vary = TRUE, vol = 50)
	user.visible_action_feedback(
		target = src,
		hard_range = MESSAGE_RANGE_CONSTRUCTION,
		visible_hard = SPAN_NOTICE("[user] starts chiselling at [src]..."),
	)

	// deciseconds progress
	var/progress = 0
	var/time_per_line = sculpting_hardness * tool_multiplier
	var/finished_progress = sculpting_line_start * time_per_line
	var/last = world.time
	var/last_line = 0

	var/datum/progressbar/progressbar = new(user, sculpting_line, src)

	while(progress < finished_progress)
		if(QDELETED(src))
			progressbar.end_progress()
			return
		if(!do_after(user, time_per_line, src, DO_AFTER_NO_PROGRESS))
			break
		var/should_be_at = sculpting_line - FLOOR(progress / time_per_line, 1)
		if(should_be_at != last_line)
			last_line = should_be_at
			if(last_line > model_height)
			else
				if(!sculpting_overlay_active)
					sculpting_overlay_active = TRUE
					sculpting_renderer.alpha = 255
					sculpting_renderer.add_filter("cut_excess", 0, alpha_mask_filter(0, sculpting_line, sculpting_mask, flags = MASK_INVERSE))
				sculpting_renderer.add_filter("slate", 0, alpha_mask_filter(0, should_be_at - model_height, sculpting_mask, flags = MASK_INVERSE))
			add_filter("top_erasure", 0, alpha_mask_filter(1, should_be_at, sculpting_rolldown_mask, flags = MASK_INVERSE))

		progress += world.time - last
		last = world.time
		progressbar.update(sculpting_line - should_be_at)

	if(!QDELETED(progressbar))
		progressbar.end_progress()

	lines = min(sculpting_line, progress / time_per_line)

	sculpting_line_end = sculpting_line_start - lines
	sculpting_line -= lines

	if(lines)
		if(isnull(sculpting_slates))
			create_slates()
		var/model_x_realigned = 0
		if(slate_dimension_x < model_width)
			// allow expansion but only for width
			var/x_alignment = FLOOR((model_width - slate_dimension_x) / 2, 1)
			model_x_realigned = x_alignment
			crop_slates(-x_alignment + 1, 1, slate_dimension_x + (model_width - slate_dimension_x - x_alignment), slate_dimension_y)
			alignment -= x_alignment
			set_base_pixel_x(base_pixel_x - x_alignment)
		if(!sculpting_overlay_active)
			// we didn't even reach the buffer yet
		else
			sculpting_buffer = crop_buffer(sculpting_buffer, 1, sculpting_line_end + 1, model_width, sculpting_line_start)
			//! TODO: this shouldn't be needed, but somehow is because of shennanigans. Figure out why and get rid of.
			preprocess_model_buffer(sculpting_buffer)
			//! End
			blend_slates(sculpting_buffer, model_x_align + 1 + model_x_realigned, sculpting_line_end + 1)
		assemble_built()
		update_appearance()

	sculpting_line_start = null
	sculpting_buffer = null
	sculpting_line_end = null
	sculpting_user = null
	sculpting_target = null
	sculpting_overlay_active = null

	add_filter("top_erasure", 0, alpha_mask_filter(1, sculpting_line, sculpting_rolldown_mask, flags = MASK_INVERSE))
	sculpting_renderer.alpha = 0
	sculpting_renderer.clear_filters()

	if(check_completion())
		user.visible_action_feedback(
			target = src,
			hard_range = MESSAGE_RANGE_CONSTRUCTION,
			visible_hard = SPAN_NOTICE("[user] finishes chiselling at [src] with a flourish."),
		)

	sculpting = FALSE

/obj/structure/sculpting_block/proc/check_completion()
	if(!sculpting_line)
		finished = TRUE
		flush_finished()
		return TRUE
	return FALSE

/obj/structure/sculpting_block/proc/flush_finished()
	assemble_built()
	icon = sculpting_built
	sculpting_built = null
	sculpting_slates = null
	name = "sculpted statue"
	desc = "A custom-chiseled statue depicting a particular thing of note."
	QDEL_NULL(sculpting_renderer)
	clear_filters()
	update_appearance()

/obj/structure/sculpting_block/proc/crop_buffer(icon/buffer, x1, y1, x2, y2)
	var/icon/built = icon('icons/system/blank_32x32.dmi', "")
	var/icon/cropping
	cropping = icon(buffer, dir = NORTH)
	cropping.Crop(x1, y1, x2, y2)
	built.Insert(cropping, dir = NORTH)
	cropping = icon(buffer, dir = EAST)
	cropping.Crop(x1, y1, x2, y2)
	built.Insert(cropping, dir = EAST)
	cropping = icon(buffer, dir = SOUTH)
	cropping.Crop(x1, y1, x2, y2)
	built.Insert(cropping, dir = SOUTH)
	cropping = icon(buffer, dir = WEST)
	cropping.Crop(x1, y1, x2, y2)
	built.Insert(cropping, dir = WEST)
	return built

/obj/structure/sculpting_block/proc/assemble_built()
	sculpting_built = icon('icons/system/blank_32x32.dmi', "")
	sculpting_built.Insert(sculpting_slates[1], dir = NORTH)
	sculpting_built.Insert(sculpting_slates[2], dir = EAST)
	sculpting_built.Insert(sculpting_slates[3], dir = SOUTH)
	sculpting_built.Insert(sculpting_slates[4], dir = WEST)

/**
 * grabs an icon from something for sculpting, processing it into a greyscale toned to the material's color
 *
 * @params
 * * to_clone - the atom the person is trying to replicate with the sculpt. no turfs.
 * * material_color - the color to tone to as rgb color string
 *
 * @return list(icon, x, y) where x/y are centering offsets
 */
/obj/structure/sculpting_block/proc/get_model_tuple(atom/movable/to_clone, material_color)
	. = get_compound_icon_with_offsets(to_clone, CALLBACK(src, PROC_REF(preprocess_model_slice)))
	if(isnull(.))
		return

/obj/structure/sculpting_block/proc/preprocess_model_slice(icon/slice)
	slice.ColorTone(material.icon_colour)

/obj/structure/sculpting_block/proc/preprocess_model_buffer(icon/slice)
	slice.ColorTone(material.icon_colour)

/**
 * get things in range of user that can be sculpted
 */
/obj/structure/sculpting_block/proc/get_possible_targets(mob/user, range_to_scan = 7)
	. = list()
	var/list/atom/potential = view(range_to_scan, user)
	var/list/mob/mobs = list()
	var/list/obj/objs = list()
	var/list/objs_seen_paths = list()
	for(var/atom/movable/AM in potential)
		if(AM.atom_flags & ATOM_ABSTRACT)
			continue
		if(!isturf(AM.loc))
			continue
		if(AM.invisibility > user.see_invisible)
			continue
		if(!user.can_see_plane(AM.plane))
			continue
		if(isobj(AM))
			var/obj/O = AM
			if(O.obj_flags & OBJ_NO_SCULPTING)
				continue
			if(objs_seen_paths[O.type])
				continue
			objs_seen_paths[O.type] = TRUE
			objs += O
		else
			var/mob/M = AM
			//! legacy code
			if(M.is_incorporeal())
				continue
			//! end
			mobs += M
	return mobs + objs

/**
 * ask someone for target
 */
/obj/structure/sculpting_block/proc/ask_for_target(mob/user)
	// todo: when we have click intercepts refactored, user should be asked to click on a target.
	var/list/possible = get_possible_targets(user)
	return input(user, "Pick a target", "Sculpting") as null|anything in possible

/obj/structure/sculpting_block/proc/create_slates()
	sculpting_slates = list()
	for(var/i in 1 to 4)
		var/icon/generated
		generated = icon('icons/system/blank_32x32.dmi')
		generated.Scale(icon_x_dimension, icon_y_dimension)
		sculpting_slates += generated
	slate_dimension_x = icon_x_dimension
	slate_dimension_y = icon_y_dimension

/obj/structure/sculpting_block/proc/blend_slates(icon/blending, x, y)
	sculpting_slates[1].Blend(icon(blending, dir = NORTH), ICON_OVERLAY, x, y)
	sculpting_slates[2].Blend(icon(blending, dir = EAST), ICON_OVERLAY, x, y)
	sculpting_slates[3].Blend(icon(blending, dir = SOUTH), ICON_OVERLAY, x, y)
	sculpting_slates[4].Blend(icon(blending, dir = WEST), ICON_OVERLAY, x, y)

/obj/structure/sculpting_block/proc/crop_slates(x1, y1, x2, y2)
	for(var/i in 1 to 4)
		var/icon/cropping = sculpting_slates[i]
		cropping.Crop(x1, y1, x2, y2)

/obj/structure/sculpting_block/proc/check_target(mob/user, atom/movable/target)
	if(isnull(sculpting_user))
		return TRUE // userless
	if(QDELETED(user) || QDELETED(target))
		return FALSE
	if(get_dist(user, target) > min(user.using_perspective.cached_view_width, user.using_perspective.cached_view_height))
		return FALSE
	if(!user.can_see_plane(target.plane))
		return FALSE
	if(target.invisibility > user.see_invisible)
		return FALSE
	return TRUE

/**
 * rendering object that sits in vis contents while sculpting
 */
/atom/movable/sculpting_render
	atom_flags = ATOM_ABSTRACT
	vis_flags = VIS_INHERIT_PLANE | VIS_INHERIT_DIR | VIS_INHERIT_ID
	layer = FLOAT_LAYER
	plane = OBJ_PLANE
	mouse_opacity = MOUSE_OPACITY_ICON

/atom/movable/sculpting_render/Destroy()
	vis_locs.len = 0
	return ..()
