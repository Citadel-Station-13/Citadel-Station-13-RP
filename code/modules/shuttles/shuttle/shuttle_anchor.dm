//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * the physical shuttle object
 *
 * for aligned docks, we align the direction and the tile to the shuttle dock.
 *
 * ## Bounds
 *
 * size_x, size_y describes our total bounding box size when facing NORTH.
 * offset_x, offset_y describes where the anchor is when facing NORTH.
 *
 * The anchor is always aligned to the top left, with no offsets, in this way.
 * When rotated it is where it would be when rotated counterclockwise to the new position.
 *
 * For a size_x, size_y of 6, 4:
 *
 * offset_x, offset_y = 0, dir NORTH
 *
 * ^00000
 * 000000
 * 000000
 * 000000
 *
 * offset_x, offset_y = 0, dir SOUTH
 *
 * 000000
 * 000000
 * 000000
 * 00000V
 *
 * offset_x, offset_y = 0, dir WEST
 *
 * 0000
 * 0000
 * 0000
 * 0000
 * 0000
 * <000
 *
 * offset_x, offset_y = 3, -1, dir NORTH
 *
 * 000000
 * 000^00
 * 000000
 * 000000
 *
 * offset_x, offset_y = 3, -1, dir SOUTH
 *
 * 000000
 * 000000
 * 00V000
 * 000000
 *
 * offset_x, offset_y = 3, -1, dir WEST
 *
 * 0000
 * 0000
 * 0<00
 * 0000
 * 0000
 * 0000
 *
 * Offsets can position the anchor outside. This works, albeit is a bad idea.
 *
 * ## Mappers
 *
 * You only need to place down:
 * * The master anchor, somewhere on the shuttle (usually a central location)
 * * At least one port anchor if you want it to dock to airlocks, aligned to the airlock in question.
 *
 * Do not mess with the variables; the init system will set them.
 */
/obj/shuttle_anchor
	name = "Shuttle (uninitialized)"
	desc = "Why do you see this?"
	// by default this should be north.
	dir = NORTH
	icon = 'icons/modules/shuttles/shuttle_anchor.dmi'
	icon_state = "main"
	plane = DEBUG_PLANE
	layer = DEBUG_LAYER_SHUTTLE_MARKERS

#ifndef CF_SHUTTLE_VISUALIZE_BOUNDING_BOXES
	invisibility = INVISIBILITY_ABSTRACT
#else
	invisibility = INVISIBILITY_NONE
#endif

	/// shuttle datum
	var/datum/shuttle/shuttle

	/// see main documentation
	var/size_x
	/// see main documentation
	var/size_y
	/// see main documentation
	var/offset_x
	/// see main documentation
	var/offset_y

/obj/shuttle_anchor/Destroy(force)
	if(!force && !shuttle.being_deleted)
		. = QDEL_HINT_LETMELIVE
		CRASH("attempted to delete a shuttle anchor")
	shuttle = null
	return ..()

/obj/shuttle_anchor/proc/before_bounds_initializing(datum/shuttle/from_shuttle, datum/turf_reservation/from_reservation, datum/shuttle_template/from_template)
	shuttle = from_shuttle

/obj/shuttle_anchor/proc/calculate_bounds(bottomleft_x, bottomleft_y, topright_x, topright_y, initial_direction)
	ASSERT(bottomleft_x && bottomleft_y && topright_x && topright_y && initial_direction)
	var/r_size_x = topright_x - bottomleft_x + 1
	var/r_size_y = topright_y - bottomleft_y + 1
	switch(initial_direction)
		if(NORTH)
			size_x = r_size_x
			size_y = r_size_y
			offset_x = x - bottomleft_x
			offset_y = topright_y - y
		if(SOUTH)
			size_x = r_size_x
			size_y = r_size_y
			offset_x = topright_x - x
			offset_y = y - bottomleft_y
		if(EAST)
			size_x = r_size_y
			size_y = r_size_x
			offset_x = topright_y - y
			offset_y = topright_x - x
		if(WEST)
			size_x = r_size_y
			size_y = r_size_x
			offset_x = y - bottomleft_y
			offset_y = x - bottomleft_x

/**
 * get the width of the shuttle, aka
 * the perpendicular axis to the direction of parking/travel
 */
/obj/shuttle_anchor/proc/overall_width(direction)
	switch(direction)
		if(NORTH)
			return size_x
		if(SOUTH)
			return size_x
		if(EAST)
			return size_y
		if(WEST)
			return size_y

/**
 * get the height of the shuttle, aka
 * the parallel axis to the direction of parking/travel
 */
/obj/shuttle_anchor/proc/overall_height(direction)
	switch(direction)
		if(NORTH)
			return size_y
		if(SOUTH)
			return size_y
		if(EAST)
			return size_x
		if(WEST)
			return size_x

/**
 * @return turfs in square box, unfiltered
 */
/obj/shuttle_anchor/proc/aabb_ordered_turfs_here()
	return aabb_ordered_turfs_at(loc)

/**
 * @params
 * * location - a turf, or a tuple of list(x, y, z)
 *
 * @return turfs in square box, unfiltered
 */
/obj/shuttle_anchor/proc/aabb_ordered_turfs_at(turf/location, direction = src.dir)
	ASSERT(isturf(location))

	var/anchor_x
	var/anchor_y
	var/anchor_z

	if(islist(location))
		anchor_x = location[1]
		anchor_y = location[2]
		anchor_z = location[3]
	else
		anchor_x = location.x
		anchor_y = location.y
		anchor_z = location.z

	// take a guess as to what these mean (lowerleft/upperright x/y)
	var/real_llx
	var/real_lly
	var/real_urx
	var/real_ury

	switch(direction)
		if(NORTH)
			real_llx = anchor_x - offset_x
			real_lly = anchor_y + offset_y - (size_y - 1)
			real_urx = anchor_x - offset_x + (size_x - 1)
			real_ury = anchor_y + offset_y
		if(SOUTH)
			real_llx = anchor_x + offset_x - (size_x - 1)
			real_lly = anchor_y - offset_y
			real_urx = anchor_x + offset_x
			real_ury = anchor_y - offset_y + (size_y - 1)
		if(EAST)
			real_llx = anchor_x + offset_y - (size_y - 1)
			real_lly = anchor_y + offset_x - (size_x - 1)
			real_urx = anchor_x + offset_y
			real_ury = anchor_y + offset_x
		if(WEST)
			real_llx = anchor_x - offset_y
			real_lly = anchor_y - offset_x
			real_urx = anchor_x - offset_y + (size_y - 1)
			real_ury = anchor_y - offset_x + (size_x - 1)

	return SSgrids.get_ordered_turfs(
		real_llx,
		real_urx,
		real_lly,
		real_ury,
		anchor_z,
		direction,
	)

/**
 * checks if we'll clip a zlevel edge or another shtutle at a location
 *
 * the weird return is for optimization reasons.
 *
 * @params
 * * location - a turf, or a tuple of list(x, y, z)
 *
 * @return null if we will clip, list(ordered turfs) if we won't clip
 */
/obj/shuttle_anchor/proc/aabb_ordered_turfs_at_and_clip_check(turf/location, direction)
	ASSERT(isturf(location))

	var/anchor_x
	var/anchor_y
	var/anchor_z

	if(islist(location))
		anchor_x = location[1]
		anchor_y = location[2]
		anchor_z = location[3]
	else
		anchor_x = location.x
		anchor_y = location.y
		anchor_z = location.z

	// take a guess as to what these mean (lowerleft/upperright x/y)
	var/real_llx
	var/real_lly
	var/real_urx
	var/real_ury

	switch(direction)
		if(NORTH)
			real_llx = anchor_x - offset_x
			real_lly = anchor_y + offset_y - (size_y - 1)
			real_urx = anchor_x - offset_x + (size_x - 1)
			real_ury = anchor_y + offset_y
		if(SOUTH)
			real_llx = anchor_x + offset_x - (size_x - 1)
			real_lly = anchor_y - offset_y
			real_urx = anchor_x + offset_x
			real_ury = anchor_y - offset_y + (size_y - 1)
		if(EAST)
			real_llx = anchor_x + offset_y - (size_y - 1)
			real_lly = anchor_y + offset_x - (size_x - 1)
			real_urx = anchor_x + offset_y
			real_ury = anchor_y + offset_x
		if(WEST)
			real_llx = anchor_x - offset_y
			real_lly = anchor_y - offset_x
			real_urx = anchor_x - offset_y + (size_y - 1)
			real_ury = anchor_y - offset_x + (size_x - 1)

	if(real_llx <= 1 || real_urx >= world.maxx || real_lly <= 1 || real_ury >= world.maxy)
		return null

	var/list/turf/ordered_turfs_at = SSgrids.get_ordered_turfs(
		real_llx,
		real_urx,
		real_lly,
		real_ury,
		anchor_z,
		direction,
	)

	// why one wide border?
	// because level borders are special snowflakes
	// being right next to them means the other side will send people onto your tile.
	var/list/one_wide_border = border_of_turf_block(
		real_llx,
		real_lly,
		real_urx,
		real_ury,
		anchor_z,
		1,
	)

	for(var/turf/T as anything in ordered_turfs_at + one_wide_border)
		// do not allow clipping shuttles; that would be bad.
		if(istype(T.loc, /area/shuttle))
			return null
		// do not allow zlevel borders; annihilating them would be bad
		if(T.turf_flags & TURF_FLAG_LEVEL_BORDER)
			return null

	return ordered_turfs_at

/obj/shuttle_anchor/forceMove()
	CRASH("attempted to forcemove a shuttle anchor")

/**
 * usually only callable by admins
 *
 * basically, forced, *almost* zero-safety immediate shuttle move to a destination
 */
/obj/shuttle_anchor/proc/immediate_yank_to(turf/location, direction)
	ASSERT(isturf(location))
	ASSERT(direction in GLOB.cardinal)

	// check clipping
	var/list/new_ordered_turfs = aabb_ordered_turfs_at_and_clip_check(location, direction)
	if(isnull(new_ordered_turfs))
		return FALSE

	return shuttle.aligned_translation(location, direction, use_after_turfs = new_ordered_turfs)

/obj/shuttle_anchor/grid_move(grid_flags, turf/new_turf)
	return

/obj/shuttle_anchor/grid_after(grid_flags, rotation_angle, list/late_call_hooks)
	return

/obj/shuttle_anchor/grid_collect(grid_flags, turf/new_turf, loc_opinion)
	return

/obj/shuttle_anchor/grid_finished(grid_flags, rotation_angle)
	return
