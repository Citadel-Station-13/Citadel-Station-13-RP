//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * Shuttle aligners provide the physical alignment points for a shuttle.
 *
 * * Aligners are used to do aligned docking; generally, you align an aligner
 *   with respect to a shuttle dock.
 * * Aligners are moved manually, as they don't require a turf underneath them to go with the shuttle.
 */
/obj/shuttle_aligner
	/// shuttle datum
	var/tmp/datum/shuttle/shuttle
	/// allow moves
	var/tmp/currently_moving = FALSE

/obj/shuttle_aligner/shuttle_aligner/proc/before_bounds_initializing(datum/shuttle/from_shuttle, datum/map_reservation/from_reservation, datum/shuttle_template/from_template)
	shuttle = from_shuttle

/obj/shuttle_aligner/Destroy(force)
	if(!force && !shuttle.being_deleted)
		. = QDEL_HINT_LETMELIVE
		CRASH("attempted to delete a shuttle aligner")
	shuttle = null
	return ..()

/**
 * @return turfs in square box, unfiltered
 */
/obj/shuttle_aligner/proc/aabb_ordered_turfs_here()
	return aabb_ordered_turfs_at(loc)

/**
 * @return turfs in square box, unfiltered
 */
/obj/shuttle_aligner/proc/aabb_ordered_turfs_at(turf/location, direction = src.dir)
	CRASH("base function called")

/**
 * checks if we'll clip a zlevel edge or another shuttle at a location
 *
 * * this is a hard clip check, if this returns null you CANNOT MOVE.
 *
 * @params
 * * location - turf or list(x,y,z)
 * * direction - which way we should be facing when we're done
 *
 * @return null if we will clip, list(ordered turfs) if we won't clip
 */
/obj/shuttle_aligner/port/proc/aabb_ordered_turfs_at_and_clip_check(turf/location, direction)
	CRASH("base function called")

/**
 * get the width of the shuttle, aka
 * the perpendicular axis to the direction of parking/travel
 */
/obj/shuttle_aligner/proc/overall_width(direction)
	CRASH("base function called")
/**
 * get the height of the shuttle, aka
 * the parallel axis to the direction of parking/travel
 */
/obj/shuttle_aligner/proc/overall_height(direction)
	CRASH("base function called")

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
/obj/shuttle_aligner/proc/calculate_motion_with_respect_to(list/old_coords, list/new_coords, old_dir, new_dir)
	return calculate_entity_motion_with_respect_to_moving_point(
		list(src.x, src.y, src.z),
		src.dir,
		old_coords,
		new_coords,
		old_dir,
		new_dir,
	)

//* Regular Movement *//

/obj/shuttle_aligner/forceMove()
	CRASH("attempted to forceMove a shuttle aligner")

/obj/shuttle_aligner/setDir(ndir)
	if(!currently_moving)
		CRASH("attempted to setDir a shuttle aligner")
	return ..()

/obj/shuttle_aligner/abstract_move(atom/new_loc)
	if(!currently_moving)
		CRASH("attempted to abstract_move a shuttle aligner")
	return ..()

//* Grid Hooks ; Shuttle manually moves us. *//

/obj/shuttle_aligner/grid_move(grid_flags, turf/new_turf)
	return

/obj/shuttle_aligner/grid_after(grid_flags, rotation_angle, list/late_call_hooks)
	return

/obj/shuttle_aligner/grid_collect(grid_flags, turf/new_turf, loc_opinion)
	return NONE

/obj/shuttle_aligner/handle_grid_overlap(grid_flags)
	. = TRUE

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
/obj/shuttle_aligner/master
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

	/// see main documentation
	var/tmp/size_x
	/// see main documentation
	var/tmp/size_y
	/// see main documentation
	var/tmp/offset_x
	/// see main documentation
	var/tmp/offset_y

/obj/shuttle_aligner/master/overall_width(direction)
	switch(direction)
		if(NORTH)
			return size_x
		if(SOUTH)
			return size_x
		if(EAST)
			return size_y
		if(WEST)
			return size_y

/obj/shuttle_aligner/master/overall_height(direction)
	switch(direction)
		if(NORTH)
			return size_y
		if(SOUTH)
			return size_y
		if(EAST)
			return size_x
		if(WEST)
			return size_x

/obj/shuttle_aligner/master/proc/calculate_bounds(bottomleft_x, bottomleft_y, topright_x, topright_y, initial_direction)
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
/obj/shuttle_aligner/master/proc/coords_for_centered_docking(obj/shuttle_dock/dock, direction = src.dir, list/dock_bbox)
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
/obj/shuttle_aligner/master/proc/will_fit_docking(obj/shuttle_dock/dock, turf/location, direction, list/dock_bbox)
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
/obj/shuttle_aligner/master/proc/centered_docking_dirs_we_fit(obj/shuttle_dock/dock, list/dock_bbox)
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
/obj/shuttle_aligner/master/proc/centered_docking_dir_bits_we_fit(obj/shuttle_dock/dock, list/dock_bbox)
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
/obj/shuttle_aligner/master/proc/will_fit_centered_docking(obj/shuttle_dock/dock, direction = src.dir, list/dock_bbox)
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
/obj/shuttle_aligner/master/proc/calculate_resultant_motion_from_docking(obj/shuttle_dock/dock, obj/shuttle_aligner/port/align_with_port, centered, direction)
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
/obj/shuttle_aligner/master/proc/calculate_motion_with_respect_to(list/old_coords, list/new_coords, old_dir, new_dir)
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
/obj/shuttle_aligner/master/proc/intersects_dock(obj/shuttle_dock/dock, turf/location, direction, list/absolute_bbox)
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
/obj/shuttle_aligner/master/proc/relative_tl_tr_bl_br_outside_turfs_at(turf/location, direction)
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
/obj/shuttle_aligner/master/proc/relative_tl_tr_bl_br_inside_turfs_at(turf/location, direction)
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
/obj/shuttle_aligner/master/proc/absolute_llx_lly_urx_ury_coords_at(turf/location, direction)
	var/anchor_x
	var/anchor_y

	if(islist(location))
		anchor_x = location[1]
		anchor_y = location[2]
	else
		anchor_x = location.x
		anchor_y = location.y

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
 * @params
 * * location - a turf, or a tuple of list(x, y, z)
 *
 * @return turfs in square box, unfiltered
 */
/obj/shuttle_aligner/master/aabb_ordered_turfs_at(turf/location, direction = src.dir)
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
 * checks if we'll clip a zlevel edge or another shuttle at a location
 *
 * * this returns axis-aligned-bounding-box turfs, as name implies; it doesn't filter.
 * * the weird return is for optimization reasons.
 *
 * @params
 * * location - a turf, or a tuple of list(x, y, z)
 *
 * @return null if we will clip, list(ordered turfs) if we won't clip
 */
/obj/shuttle_aligner/master/proc/aabb_ordered_turfs_at_and_clip_check(turf/location, direction)
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
/obj/shuttle_aligner/master/proc/immediate_yank_to(turf/location, direction)
	ASSERT(isturf(location))
	ASSERT(direction in GLOB.cardinal)

	// check clipping
	var/list/new_ordered_turfs = aabb_ordered_turfs_at_and_clip_check(location, direction)
	if(isnull(new_ordered_turfs))
		return FALSE

	return shuttle.aligned_translation(location, direction, use_after_turfs = new_ordered_turfs)

/**
 * shuttle-side docking port; put this on airlocks
 */
/obj/shuttle_aligner/port
	/// port name - used in interfaces
	name = "docking port"
	/// port desc - used in interfaces
	desc = "A port that allows the shuttle to align to a dock."
	icon = 'icons/modules/shuttles/shuttle_anchor.dmi'
	icon_state = "dock"
	plane = DEBUG_PLANE
	layer = DEBUG_LAYER_SHUTTLE_MARKERS
	atom_flags = ATOM_ABSTRACT | ATOM_NONWORLD

#ifndef CF_SHUTTLE_VISUALIZE_BOUNDING_BOXES
	invisibility = INVISIBILITY_ABSTRACT
#else
	invisibility = INVISIBILITY_NONE
#endif

	/// dock width - this is how wide the airlock/otherwise opening is.
	///
	/// the port is left-aligned to the width when looking north
	/// so if it's width 3,
	/// we have this:
	/// ^XX
	///
	/// if the port is rotated, we are left-aligned to the *direction of the port*, e.g.
	/// east, =
	/// >
	/// x
	/// x
	var/port_width = 1
	/// offset the port right in the width
	///
	/// width 3, offset 2:
	/// XX^
	///
	/// this is needed because port alignment must always be
	/// exact, so things like power lines and atmos lines can be connected.
	var/port_offset = 0
	/// how many tiles of 'safety' extends to both sides of the width
	/// this means that an airtight seal can be formed as long as the dock accomodates the safety region,
	/// even if it's too big for the width
	var/port_margin = 1
	/// port id - must be unique per shuttle instance
	/// the maploader will handle ID scrambling
	///
	/// * if this doesn't exist, stuff that need to hook it won't work.
	/// * if this isn't set, we'll assign it a random one on init
	var/port_id

	/// registered shuttle hooks
	/// * Hooks registered here will have 'translation', 'traversal', and 'dock' events fired.
	var/tmp/list/datum/shuttle_hook/hooks

	/// is this the primary port?
	/// if it is, this is what we align with for roundstart loading.
	/// * if there is more than one primary port, one will win, the others will lose.
	///   the victor is undefined.
	/// * there can be no primary port.
	var/primary_port = FALSE

/obj/shuttle_aligner/port/preloading_from_mapload(with_id)
	. = ..()
	port_id = SSmapping.mangled_persistent_id(port_id, with_id)

/obj/shuttle_aligner/port/proc/dispatch_event_to_hooks(datum/event_args/shuttle/event)
	SHOULD_NOT_SLEEP(TRUE)
	for(var/datum/shuttle_hook/hook as anything in hooks)
		hook.on_event(event)

/obj/shuttle_aligner/port/overall_width(direction)
	var/turn_angle = dir2angle(src.dir) - dir2angle(direction)
	return shuttle.anchor.overall_width(turn(shuttle.anchor.dir, turn_angle))

/obj/shuttle_aligner/port/overall_height(direction)
	var/turn_angle = dir2angle(src.dir) - dir2angle(direction)
	return shuttle.anchor.overall_height(turn(shuttle.anchor.dir, turn_angle))

#warn below, two functions above

/obj/shuttle_aligner/port/aabb_ordered_turfs_at(turf/location, direction = src.dir)
	// unpack
	var/new_x
	var/new_y
	var/new_z

	if(islist(location))
		new_x = location[1]
		new_y = location[2]
		new_z = location[3]
	else
		new_x = location.x
		new_y = location.y
		new_z = location.z

	var/list/anchor_motion = shuttle.anchor.calculate_motion_with_respect_to(
		list(src.x, src.y, src.z),
		list(new_x, new_y, new_z),
		src.dir,
		direction,
	)

	return shuttle.anchor.aabb_ordered_turfs_at(anchor_motion, anchor_motion[4])

/obj/shuttle_aligner/port/proc/aabb_ordered_turfs_at_and_clip_check(turf/location, direction)
	// unpack
	var/new_x
	var/new_y
	var/new_z

	if(islist(location))
		new_x = location[1]
		new_y = location[2]
		new_z = location[3]
	else
		new_x = location.x
		new_y = location.y
		new_z = location.z

	var/list/anchor_motion = shuttle.anchor.calculate_motion_with_respect_to(
		list(src.x, src.y, src.z),
		list(new_x, new_y, new_z),
		src.dir,
		direction,
	)

	return shuttle.anchor.aabb_ordered_turfs_at_and_clip_check(anchor_motion, anchor_motion[4])

/**
 * can we form an airtight seal at a given dock?
 *
 * @return SHUTTLE_DOCKING_SEAL_*
 */
/obj/shuttle_aligner/port/proc/check_dock_seal(obj/shuttle_dock/dock)
	// facing north, pos 1 = where the dock obj actually is
	var/our_left = 1 - port_offset
	var/their_left = 1 - dock.dock_offset
	var/our_right = port_width - port_offset
	var/their_right = dock.dock_width - dock.dock_offset
	var/our_tolerance = port_margin
	var/their_tolerance = dock.dock_margin
	var/left_distance = abs(our_left - their_left)
	var/right_distance = abs(our_right - their_right)

	var/has_mismatch = FALSE

	if(our_left != their_left)
		if(our_left < their_left)
			if(our_tolerance < left_distance)
				return SHUTTLE_DOCKING_SEAL_FAULT
		if(our_left > their_left)
			if(their_tolerance < left_distance)
				return SHUTTLE_DOCKING_SEAL_FAULT
		has_mismatch = TRUE
	if(our_right != their_right)
		if(our_right > their_right)
			if(their_tolerance < right_distance)
				return SHUTTLE_DOCKING_SEAL_FAULT
		if(our_right < their_right)
			if(our_tolerance < right_distance)
				return SHUTTLE_DOCKING_SEAL_FAULT
		has_mismatch = TRUE

	return has_mismatch? SHUTTLE_DOCKING_SEAL_INCONVENIENT : SHUTTLE_DOCKING_SEAL_NOMINAL

#define SHUTTLE_PORT_PATH(PATH) \
/obj/shuttle_aligner/port/##PATH/primary { \
	primary_port = TRUE; \
	color = "#88ff88"; \
} \
/obj/shuttle_aligner/port/##PATH

/obj/shuttle_aligner/port/north
	dir = NORTH

SHUTTLE_PORT_PATH(south)
	dir = SOUTH

SHUTTLE_PORT_PATH(east)
	dir = EAST

SHUTTLE_PORT_PATH(west)
	dir = WEST

SHUTTLE_PORT_PATH(two_wide)
	abstract_type = /obj/shuttle_aligner/port/two_wide
	icon = 'icons/modules/shuttles/shuttle_anchor_2x2.dmi'
	icon_state = "dock"
	port_width = 2

SHUTTLE_PORT_PATH(two_wide/left_aligned)

SHUTTLE_PORT_PATH(two_wide/left_aligned/north)
	dir = NORTH

SHUTTLE_PORT_PATH(two_wide/left_aligned/south)
	dir = SOUTH
	port_offset = 1
	pixel_x = -32

SHUTTLE_PORT_PATH(two_wide/left_aligned/east)
	dir = EAST
	port_offset = 1
	pixel_y = -32

SHUTTLE_PORT_PATH(two_wide/left_aligned/west)
	dir = WEST

SHUTTLE_PORT_PATH(two_wide/right_aligned)

SHUTTLE_PORT_PATH(two_wide/right_aligned/north)
	dir = NORTH
	port_offset = 1
	pixel_x = -32

SHUTTLE_PORT_PATH(two_wide/right_aligned/south)
	dir = SOUTH

SHUTTLE_PORT_PATH(two_wide/right_aligned/east)
	dir = EAST

SHUTTLE_PORT_PATH(two_wide/right_aligned/west)
	dir = WEST
	port_offset = 1
	pixel_y = -32

SHUTTLE_PORT_PATH(three_wide)
	icon = 'icons/modules/shuttles/shuttle_anchor_3x3.dmi'
	icon_state = "dock"
	port_width = 3

SHUTTLE_PORT_PATH(three_wide/north)
	dir = NORTH
	port_offset = 1
	pixel_x = -32

SHUTTLE_PORT_PATH(three_wide/south)
	dir = SOUTH
	port_offset = 1
	pixel_x = -32

SHUTTLE_PORT_PATH(three_wide/east)
	dir = EAST
	port_offset = 1
	pixel_y = -32

SHUTTLE_PORT_PATH(three_wide/west)
	dir = WEST
	port_offset = 1
	pixel_y = -32
