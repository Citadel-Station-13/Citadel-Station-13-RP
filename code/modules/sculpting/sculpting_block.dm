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

	/// finished base state
	var/sculpture_base_state = "base"
	/// material ref
	var/datum/material/material

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

	/// current icon for sculpting; every operation flushes to this, this begins at a x by y blank.
	/// we don't flush directly to our icon only because icon might get fucked with
	var/icon/sculpting_slate
	/// sculpting block is assumed to be a certain size
	/// store the current line being sculpted
	/// this starts at the topmost y
	/// if we're done sculpting, this should be nulled for consistency
	var/sculpting_line

/obj/structure/sculpting_block/Initialize(mapload, material)
	material = SSmaterials.get_material(material)
	// todo: if it autoinit'd, don't do this
	reset_sculpting()
	return ..()

/obj/structure/sculpting_block/proc/reset_sculpting()
	sculpting_line = icon_y_dimension
	finished = FALSE

/obj/structure/sculpting_block/update_icon(updates)
	cut_overlays()
	if(length(underlays))
		underlays.len = 0
	. = ..()
	if(!finished)
		underlays += sculpture_base_state
	else
		add_overlay(sculpture_base_state)

	#warn impl above

/**
 * returns speed multiplier, or null if not tool
 */
/obj/structure/sculpting_block/proc/is_sculpting_tool(obj/item/tool, mob/user)
	#warn impl

/obj/structure/sculpting_block/proc/initiate_sculpting(mob/user, silent, atom/movable/forced_target, obj/item/tool)
	if(sculpting)
		if(!silent)
			user.action_feedback(SPAN_WARNING("Someone's already working on [src]."))
		return FALSE
	var/atom/movable/target = isnull(forced_target)? ask_for_target(user) : forced_target
	if(isnull(tool))
		tool = user.get_active_held_item()
	var/tool_multiplier = is_sculpting_tool(tool)
	if(isnull(tool_multiplier))
		if(!silent)
			user.action_feedback(SPAN_WARNING("You must be holding a valid sculpting tool."))
		return FALSE

	setup_op(target)

	var/lines = 0

	#warn impl

	finish_op(lines)

	check_completion()

/obj/structure/sculpting_block/proc/check_completion()
	if(sculpting_line > icon_y_dimension)
		finished = TRUE
		flush_finished()

/obj/structure/sculpting_block/proc/flush_finished()
	#warn impl
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
	. = get_flat_icon(to_clone)
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
	for(var/atom/movable/AM in potential)
		if(AM.atom_flags & ATOM_ABSTRACT)
			continue
		if(AM.invisibility > user.see_invisible)
			continue
		if(!user.can_see_plane(AM.plane))
			continue
		if(isobj(AM))
			var/obj/O = AM
			if(!(O.obj_flags & OBJ_NO_SCULPTING))
				continue
		else
			var/mob/M = AM
			//! legacy code
			if(M.is_incorporeal())
				continue
			//! end
		. += AM

/**
 * ask someone for target
 */
/obj/structure/sculpting_block/proc/ask_for_target(mob/user)
	#warn impl

/obj/structure/sculpting_block/proc/setup_op(atom/movable/target)
	sculpting_line_start = sculpting_line
	#warn buffer

/obj/structure/sculpting_block/proc/finish_op(lines)
	sculpting_line_end = sculpting_line_start + lines

	sculpting_line += lines

	if(lines)
		if(isnull(sculpting_slate))
			create_slate()
		#warn crop out irrelevant parts and blend in

	sculpting_line_start = null
	scultping_buffer = null
	sculpting_line_end = null

/obj/structure/sculpting_block/proc/create_slate()
	#warn impl
