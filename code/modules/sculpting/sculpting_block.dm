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
 */
/obj/structure/sculpting_block
	name = "material block"
	desc = "A block of material. You can sculpt this with appropriate tools, like a screwdriver."
	icon = 'icons/modules/sculpting/sculpting.dmi'
	icon_state = "block"
	density = TRUE
	anchored = FALSE

	/// finished base state
	var/sculpture_base_state = "base"
	/// material ref
	var/datum/material/material = /datum/material/steel

	icon_x_dimension = 32
	icon_y_dimension = 32
	bound_width = 32
	bound_height = 32

	/// is this sculpture finished?
	var/finished = FALSE

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
	var/icon/sculpting_slate
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

/obj/structure/sculpting_block/Initialize(mapload, material)
	// todo: materials system
	src.material = SSmaterials.get_material(material || src.material)
	// todo: if it autoinit'd, don't do this
	reset_sculpting()
	return ..()

/obj/structure/sculpting_block/Destroy()
	QDEL_NULL(sculpting_renderer)
	QDEL_NULL(sculpting_mask)
	QDEL_NULL(sculpting_slate)
	QDEL_NULL(sculpting_buffer)
	return ..()

/obj/structure/sculpting_block/proc/reset_sculpting()
	sculpting_line = icon_y_dimension
	finished = FALSE

/obj/structure/sculpting_block/update_icon(updates)
	if(length(underlays))
		underlays.len = 0
	if(sculpting_buffer)
		icon = sculpting_slate
	. = ..()
	underlays += sculpture_base_state

/obj/structure/sculpting_block/attackby(obj/item/I, mob/living/user, list/params, clickchain_flags, damage_multiplier)
	if(user.a_intent == INTENT_HARM)
		return ..()
	if(user.a_intent == INTENT_HELP)
		initiate_sculpting(user, tool = I)
		return CLICKCHAIN_DO_NOT_PROPAGATE

/obj/structure/sculpting_block/wrench_act(obj/item/I, mob/user, flags, hint)
	. = ..()
	if(.)
		return
	user.action_feedback(SPAN_NOTICE("You start [anchored? "unbolting [src] from the floor" : "bolting [src] to the floor"]."), src)
	log_construction(user, src, "start [anchored? "unanchor" : "anchor"]")
	if(!use_wrench(I, user, flags, 3 SECONDS))
		return TRUE
	user.action_feedback(SPAN_NOTICE("You start [anchored? "unbolt [src] from the floor" : "bolt [src] to the floor"]."), src)
	log_construction(user, src, "[anchored? "unanchored" : "anchored"]")
	set_anchored(!anchored)
	return TRUE

/obj/structure/sculpting_block/dynamic_tool_functions(obj/item/I, mob/user)
	. = list()
	.[TOOL_WRENCH] = anchored? "unanchor" : "anchor"
	return merge_double_lazy_assoc_list(., ..())

/obj/structure/sculpting_block/dynamic_tool_image(function, hint)
	. = ..()
	if(.)
		return
	switch(hint)
		if("unanchor")
			return dyntool_image_backward(TOOL_WRENCH)
		if("anchor")
			return dyntool_image_forward(TOOL_WRENCH)

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
	if(!user.Adjacent(src))
		return FALSE

	sculpting = TRUE

	var/list/model_tuple = get_model_tuple(target, material.icon_colour)
	TIMER_COOLDOWN_START(src, CD_INDEX_SCULPTING_COOLDOWN, 1 SECONDS)
	var/icon/model = model_tuple[1]
	var/model_width = model.Width()
	var/model_height = model.Height()
	if(model_height > icon_y_dimension)
		if(!silent)
			user.action_feedback(SPAN_WARNING("[target] is too tall."), src)
		sculpting = FALSE
		return FALSE
	// cut excess
	if(model_height > sculpting_line)
		model.Crop(1, 1, model_width, sculpting_line)
		model_height = sculpting_line
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
	sculpting_overlay_active = model_height <= sculpting_line

	var/lines = 0

	if(isnull(sculpting_renderer))
		sculpting_renderer = new
		vis_contents += sculpting_renderer

	sculpting_renderer.icon = sculpting_buffer
	sculpting_renderer.pixel_x = model_x_align
	sculpting_renderer.alpha = sculpting_overlay_active? initial(sculpting_renderer.alpha) : 0

	if(isnull(sculpting_mask))
		sculpting_mask = icon('icons/system/color_32x32.dmi', "white")
	if(sculpting_mask.Width() != model_width || sculpting_mask.Height() != model_height)
		sculpting_mask.Scale(1, 1, model_width, model_height)

	if(sculpting_overlay_active)
		sculpting_renderer.add_filter("slate", 0, alpha_mask_filter(1, sculpting_line - model_height + 1, sculpting_mask, flags = MASK_INVERSE))

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
			QDEL_NULL(progressbar)
			return
		if(!do_after(user, time_per_line, src, DO_AFTER_NO_PROGRESS))
			break
		var/should_be_at = sculpting_line - FLOOR(progress / time_per_line, 1)
		if(should_be_at != last_line)
			last_line = should_be_at
			if(last_line > model_height)
			else
				sculpting_overlay_active = TRUE
				sculpting_renderer.add_filter("slate", 0, alpha_mask_filter(1, should_be_at - model_height + 1, sculpting_mask, flags = MASK_INVERSE))

		progress += world.time - last
		progressbar.update(sculpting_line - should_be_at)

	QDEL_NULL(progressbar)

	lines = progress / time_per_line

	sculpting_line_end = sculpting_line_start - lines
	sculpting_line -= lines

	if(lines)
		if(isnull(sculpting_slate))
			create_slate()
		if(model_width < slate_dimension_x)
			// allow expansion but only for width
			var/x_alignment = FLOOR((model_width - slate_dimension_x / 2), 1)
			sculpting_slate.Crop(-x_alignment, 1, model_width - slate_dimension_x - x_alignment, slate_dimension_y)
			set_base_pixel_x(-x_alignment)
		if(!sculpting_overlay_active)
			// we didn't even reach the buffer yet
		else
			sculpting_buffer.Crop(1, model_height - sculpting_line_end, model_width, model_height)
			sculpting_slate.Blend(sculpting_buffer, ICON_OVERLAY, model_x_align, sculpting_line_end)
		update_appearance()

	sculpting_line_start = null
	sculpting_buffer = null
	sculpting_line_end = null
	sculpting_user = null
	sculpting_target = null
	sculpting_overlay_active = null

	if(check_completion())
		user.visible_action_feedback(
			target = src,
			hard_range = MESSAGE_RANGE_CONSTRUCTION,
			visible_hard = SPAN_NOTICE("[user] finishes chiselling at [src] with a flourish."),
		)

	sculpting = FALSE

/obj/structure/sculpting_block/proc/check_completion()
	if(sculpting_line > icon_y_dimension)
		finished = TRUE
		flush_finished()
		return TRUE
	return FALSE

/obj/structure/sculpting_block/proc/flush_finished()
	icon = sculpting_slate
	sculpting_slate = null
	QDEL_NULL(sculpting_renderer)
	update_appearance()

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
	. = get_compound_icon(to_clone)
	if(isnull(.))
		return
	var/icon/flattened = .[1]
	flattened.ColorTone(material_color)

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

/obj/structure/sculpting_block/proc/create_slate()
	var/icon/generated
	generated = icon('icons/system/blank_32x32.dmi')
	generated.Scale(icon_x_dimension, icon_y_dimension)
	sculpting_slate = generated
	slate_dimension_x = icon_x_dimension
	slate_dimension_y = icon_y_dimension

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
