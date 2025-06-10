//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

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
 * * You don't need to put down anchors at all, they auto-generate.
 * * If you place one anyways, it'll be respected. That said, the size will be auto-generated still.
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
	atom_flags = ATOM_ABSTRACT | ATOM_NONWORLD

#ifndef CF_SHUTTLE_VISUALIZE_BOUNDING_BOXES
	invisibility = INVISIBILITY_ABSTRACT
#else
	invisibility = INVISIBILITY_NONE
#endif

	/// shuttle datum
	var/tmp/datum/shuttle/shuttle

	/// see main documentation
	var/tmp/size_x
	/// see main documentation
	var/tmp/size_y
	/// see main documentation
	var/tmp/offset_x
	/// see main documentation
	var/tmp/offset_y

	/// are we moving right now?
	var/tmp/anchor_moving = FALSE

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
 * get our centered coords if landing on a dock's bounding box
 * in centered mode.
 *
 * this is by centering the entire shuttle, not just the anchor!
 *
 * @params
 * * dock - the dock in question
 * * direction - the direction we should dock
 * * dock_bbox - llx, lly, urx, ury tuple, if you already have this information
 *
 * @return list(x, y, z, dir)
 */
/obj/shuttle_anchor/proc/coords_for_centered_docking(obj/shuttle_dock/dock, direction = src.dir, list/dock_bbox)
	if(isnull(dock_bbox))
		dock_bbox = dock.absolute_bounding_box_coords()

	// our width/height are absolute width/heights.
	var/their_width = dock_bbox[3] - dock_bbox[1] + 1
	var/their_height = dock_bbox[4] - dock_bbox[2] + 1
	var/our_width = direction & (EAST|WEST)? size_y : size_x
	var/our_height = direction & (EAST|WEST)? size_x : size_y
	var/width_difference = their_width - our_width
	var/height_difference = their_height - our_height
	var/width_centering = round(width_difference / 2)
	var/height_centering = round(height_difference / 2)

	switch(direction)
		if(NORTH)
			return list(
				dock_bbox[1] + width_centering + offset_x,
				dock_bbox[2] + height_centering + (size_y - 1) - offset_y,
				dock.z,
				direction,
			)
		if(SOUTH)
			return list(
				dock_bbox[1] + width_centering + (size_x - 1) - offset_x,
				dock_bbox[2] + height_centering + offset_y,
				dock.z,
				direction,
			)
		if(EAST)
			return list(
				dock_bbox[1] + width_centering + (size_y - 1) - offset_y,
				dock_bbox[2] + height_centering + (size_x - 1) - offset_x,
				dock.z,
				direction,
			)
		if(WEST)
			return list(
				dock_bbox[1] + offset_y,
				dock_bbox[2] + offset_x,
				dock.z,
				direction,
			)

/**
 * checks if we can fit in a docking port's bounding box at a specific location
 *
 * @params
 * * dock - the dock
 * * location - a turf, or a tuple of coordinates
 * * direction - the direction we should be in when in it
 * * dock_bbox - the dock's absoluate_bounding_box_coords() if we already have it cached
 */
/obj/shuttle_anchor/proc/will_fit_docking(obj/shuttle_dock/dock, turf/location, direction, list/dock_bbox)
	if(isnull(dock_bbox))
		dock_bbox = dock.absolute_bounding_box_coords()

	var/list/absolute_bbox_at = absolute_llx_lly_urx_ury_coords_at(location, direction)

	return ( \
		absolute_bbox_at[1] >= dock_bbox[1] && \
		absolute_bbox_at[2] >= dock_bbox[2] && \
		absolute_bbox_at[3] <= dock_bbox[3] && \
		absolute_bbox_at[4] <= dock_bbox[4] \
	)

/**
 * heuristically find cardinals directions we can fit in on a dock
 *
 * @params
 * * dock - the dock
 * * dock_bbox - the dock's absoluate_bounding_box_coords() if we already have it cached
 *
 * @return list(dirs...)
 */
/obj/shuttle_anchor/proc/centered_docking_dirs_we_fit(obj/shuttle_dock/dock, list/dock_bbox)
	. = list()
	if(isnull(dock_bbox))
		dock_bbox = dock.absolute_bounding_box_coords()
	for(var/dir in GLOB.cardinal)
		if(!will_fit_centered_docking(dock, dir, dock_bbox))
			continue
		. += dir

/**
 * heuristically find cardinals directions we can fit in on a dock
 *
 * @params
 * * dock - the dock
 * * dock_bbox - the dock's absoluate_bounding_box_coords() if we already have it cached
 *
 * @return dirs as bits
 */
/obj/shuttle_anchor/proc/centered_docking_dir_bits_we_fit(obj/shuttle_dock/dock, list/dock_bbox)
	. = NONE
	if(isnull(dock_bbox))
		dock_bbox = dock.absolute_bounding_box_coords()
	for(var/dir in GLOB.cardinal)
		if(!will_fit_centered_docking(dock, dir, dock_bbox))
			continue
		. |= dir

/**
 * will we fit in a dock in a centered docking?
 *
 * @params
 * * dock - the dock
 * * direction - the direction to dock in
 * * dock_bbox - the dock's absoluate_bounding_box_coords() if we already have it cached
 */
/obj/shuttle_anchor/proc/will_fit_centered_docking(obj/shuttle_dock/dock, direction = src.dir, list/dock_bbox)
	var/list/coords = coords_for_centered_docking(dock, dir, dock_bbox)
	return will_fit_docking(dock, coords, direction, dock_bbox)

/**
 * get position and direction when performing a landing at a specific location with a specific set of
 * parameters
 *
 * @params
 * * dock - the dock we'd dock at
 * * align_with_port - if we're aligning with a port instead of performing a centered docking
 * * centered - are we doing a centered docking? if not, we're just matching the dock's coordinates
 * * direction - the direction we need to be at when we arrive
 *
 * @return list(x, y, z, dir)
 */
/obj/shuttle_anchor/proc/calculate_resultant_motion_from_docking(obj/shuttle_dock/dock, obj/shuttle_port/align_with_port, centered, direction)
	if(align_with_port)
		return calculate_motion_with_respect_to(
			list(align_with_port.x, align_with_port.y, align_with_port.z),
			list(dock.x, dock.y, dock.z),
			align_with_port.dir,
			dock.dir,
		)
	if(centered)
		// align us, centered, with it
		return coords_for_centered_docking(dock, direction || src.dir)
	else
		// align us with it
		return list(dock.x, dock.y, dock.z, direction || dock.dir)

/**
 * get rotated coordinates and direction when moved with another location on the shuttle
 *
 * @params
 * * old_coords - list(x,y,z)
 * * new_coords - list(x,y,z)
 * * old_dir - old direction
 * * new_dir - new direction
 *
 * @return list(x, y, z, dir)
 */
/obj/shuttle_anchor/proc/calculate_motion_with_respect_to(list/old_coords, list/new_coords, old_dir, new_dir)
	return calculate_entity_motion_with_respect_to_moving_point(
		list(src.x, src.y, src.z),
		src.dir,
		old_coords,
		new_coords,
		old_dir,
		new_dir,
	)

/**
 * checks if we intersect a dock at a given coordinate and direction
 *
 * @params
 * * dock - the dock
 * * location - a turf, or a set of coordinates; not necessary if absolute_bbox is given
 * * direction - the direction; not necessary if absolute_bbox is given
 * * absolute_bbox - llx, lly, urx, ury, if we already have it cached
 */
/obj/shuttle_anchor/proc/intersects_dock(obj/shuttle_dock/dock, turf/location, direction, list/absolute_bbox)
	if(isnull(absolute_bbox))
		absolute_bbox = absolute_llx_lly_urx_ury_coords_at(location, direction)
	var/list/dock_absolute_bbox = dock.absolute_llx_lly_urx_ury_coords()
	return ( \
		(absolute_bbox[1] > dock_absolute_bbox[3]) || (absolute_bbox[3] < dock_absolute_bbox[1]) \
		|| \
		(absolute_bbox[2] > dock_absolute_bbox[4]) || (absolute_bbox[4] < dock_absolute_bbox[2]) \
	)

/**
 * gets the topleft, topright, bottomleft, and bottomright turfs
 * **right outside the shuttle bounding box**
 * with respect to the given direction
 *
 * if EAST, as an example, this will be
 * list(topright, bottomright, topleft, bottomleft)
 * in respect to the **map**.
 *
 * why? because that is the topleft, topright, bottomleft, and bottomright in
 * respect to the EAST direction!
 *
 * todo: coords list(x,y,z) version
 *
 * @params
 * * turf/location - turf or list(x,y,z)
 * * direction - direction we'll be in / at
 */
/obj/shuttle_anchor/proc/relative_tl_tr_bl_br_outside_turfs_at(turf/location, direction)
	var/anchor_z

	if(islist(location))
		anchor_z = location[3]
	else
		anchor_z = location.z

	var/list/bounds = absolute_llx_lly_urx_ury_coords_at(location, direction)
	switch(direction)
		if(NORTH)
			return list(
				locate(bounds[1] - 1, bounds[4] + 1, anchor_z), // tl absolute outside
				locate(bounds[3] + 1, bounds[4] + 1, anchor_z), // tr absolute outside
				locate(bounds[1] - 1, bounds[2] - 1, anchor_z), // bl absolute outside
				locate(bounds[3] + 1, bounds[2] - 1, anchor_z), // br absolute outside
			)
		if(SOUTH)
			return list(
				locate(bounds[3] + 1, bounds[2] - 1, anchor_z), // br absolute outside
				locate(bounds[1] - 1, bounds[2] - 1, anchor_z), // bl absolute outside
				locate(bounds[3] + 1, bounds[4] + 1, anchor_z), // tr absolute outside
				locate(bounds[1] - 1, bounds[4] + 1, anchor_z), // tl absolute outside
			)
		if(EAST)
			return list(
				locate(bounds[3] + 1, bounds[4] + 1, anchor_z), // tr absolute outside
				locate(bounds[3] + 1, bounds[2] - 1, anchor_z), // br absolute outside
				locate(bounds[1] - 1, bounds[4] + 1, anchor_z), // tl absolute outside
				locate(bounds[1] - 1, bounds[2] - 1, anchor_z), // bl absolute outside
			)
		if(WEST)
			return list(
				locate(bounds[1] - 1, bounds[2] - 1, anchor_z), // bl absolute outside
				locate(bounds[1] - 1, bounds[4] + 1, anchor_z), // tl absolute outside
				locate(bounds[3] + 1, bounds[2] - 1, anchor_z), // br absolute outside
				locate(bounds[3] + 1, bounds[4] + 1, anchor_z), // tr absolute outside
			)

/**
 * gets the topleft, topright, bottomleft, and bottomright turfs
 * **right inside the shuttle bounding box**
 * with respect to the given direction
 *
 * if EAST, as an example, this will be
 * list(topright, bottomright, topleft, bottomleft)
 * in respect to the **map**.
 *
 * why? because that is the topleft, topright, bottomleft, and bottomright in
 * respect to the EAST direction!
 *
 * todo: coords list(x,y,z) version
 *
 * @params
 * * turf/location - turf or list(x,y,z)
 * * direction - direction we'll be in / at
 */
/obj/shuttle_anchor/proc/relative_tl_tr_bl_br_inside_turfs_at(turf/location, direction)
	var/anchor_z

	if(islist(location))
		anchor_z = location[3]
	else
		anchor_z = location.z

	var/list/bounds = absolute_llx_lly_urx_ury_coords_at(location, direction)
	switch(direction)
		if(NORTH)
			return list(
				locate(bounds[1], bounds[4], anchor_z), // tl absolute inside
				locate(bounds[3], bounds[4], anchor_z), // tr absolute inside
				locate(bounds[1], bounds[2], anchor_z), // bl absolute inside
				locate(bounds[3], bounds[2], anchor_z), // br absolute inside
			)
		if(SOUTH)
			return list(
				locate(bounds[3], bounds[2], anchor_z), // br absolute inside
				locate(bounds[1], bounds[2], anchor_z), // bl absolute inside
				locate(bounds[3], bounds[4], anchor_z), // tr absolute inside
				locate(bounds[1], bounds[4], anchor_z), // tl absolute inside
			)
		if(EAST)
			return list(
				locate(bounds[3], bounds[4], anchor_z), // tr absolute inside
				locate(bounds[3], bounds[2], anchor_z), // br absolute inside
				locate(bounds[1], bounds[4], anchor_z), // tl absolute inside
				locate(bounds[1], bounds[2], anchor_z), // bl absolute inside
			)
		if(WEST)
			return list(
				locate(bounds[1], bounds[2], anchor_z), // bl absolute inside
				locate(bounds[1], bounds[4], anchor_z), // tl absolute inside
				locate(bounds[3], bounds[2], anchor_z), // br absolute inside
				locate(bounds[3], bounds[4], anchor_z), // tr absolute inside
			)

/**
 * get real (non-directional) bounding box lowerleft/upperright x/y's
 *
 * @return list(llx, lly, urx, ury)
 */
/obj/shuttle_anchor/proc/absolute_llx_lly_urx_ury_coords_at(turf/location, direction)
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

	return list(
		real_llx,
		real_lly,
		real_urx,
		real_ury,
	)

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
	var/real_llx
	var/real_lly
	var/real_urx
	var/real_ury

	var/list/bounds = absolute_llx_lly_urx_ury_coords_at(location, direction)

	real_llx = bounds[1]
	real_lly = bounds[2]
	real_urx = bounds[3]
	real_ury = bounds[4]

	return SSgrids.get_ordered_turfs(
		real_llx,
		real_urx,
		real_lly,
		real_ury,
		islist(location)? location[3] : location.z,
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
		// also don't cross out of reservations that would be really, really bad.
		if(T.turf_flags & (TURF_FLAG_LEVEL_BORDER | TURF_FLAG_UNUSED_RESERVATION))
			return null

	return ordered_turfs_at

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

//* Movement Hooks ; We don't allow normal movement. *//

/obj/shuttle_anchor/forceMove()
	CRASH("attempted to forcemove a shuttle anchor")

/obj/shuttle_anchor/setDir(ndir)
	if(!anchor_moving)
		CRASH("attempted to setDir an anchor")
	return ..()

/obj/shuttle_anchor/abstract_move(atom/new_loc)
	if(!anchor_moving)
		CRASH("attempted to abstract_move a shuttle anchor")
	return ..()

//* Grid Hooks ; Shuttle manually moves us. *//

/obj/shuttle_anchor/grid_move(grid_flags, turf/new_turf)
	return

/obj/shuttle_anchor/grid_after(grid_flags, rotation_angle, list/late_call_hooks)
	return

/obj/shuttle_anchor/grid_collect(grid_flags, turf/new_turf, loc_opinion)
	return

/obj/shuttle_anchor/grid_finished(grid_flags, rotation_angle)
	return
