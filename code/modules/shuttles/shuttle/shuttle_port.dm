//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * Dock anchor; put this on docks.
 */
/obj/shuttle_port
	/// port name - used in interfaces
	name = "docking port"
	/// port desc - used in interfaces
	desc = "A port that allows the shuttle to align to a dock."
	icon = 'icons/modules/shuttles/shuttle_anchor.dmi'
	icon_state = "dock"
	plane = DEBUG_PLANE
	layer = DEBUG_LAYER_SHUTTLE_MARKERS

#ifndef CF_SHUTTLE_VISUALIZE_BOUNDING_BOXES
	invisibility = INVISIBILITY_ABSTRACT
#else
	invisibility = INVISIBILITY_NONE
#endif

	/// shuttle datum
	var/datum/shuttle/shuttle

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
	/// if this doesn't exist, stuff that need to hook it won't work.
	var/port_id

	/// registered shuttle hooks
	var/list/datum/shuttle_hook/hooks

	/// is this the primary port?
	/// if it is, this is what we align with for roundstart loading.
	var/primary_port = FALSE

/obj/shuttle_port/preloading_instance(with_id)
	. = ..()
	port_id = SSmapping.mangled_persistent_id(port_id, with_id)

/obj/shuttle_port/Destroy(force)
	if(!force && !shuttle.being_deleted)
		. = QDEL_HINT_LETMELIVE
		CRASH("attempted to delete a shuttle anchor")
	shuttle = null
	return ..()

/obj/shuttle_port/proc/before_bounds_initializing(datum/shuttle/from_shuttle, datum/turf_reservation/from_reservation, datum/shuttle_template/from_template)
	shuttle = from_shuttle

/obj/shuttle_port/proc/overall_width(direction)
	return shuttle.anchor.overall_width(direction)

/obj/shuttle_port/proc/overall_height(direction)
	return shuttle.anchor.overall_height(direction)

/**
 * @return turfs in square box, unfiltered
 */
/obj/shuttle_port/proc/aabb_ordered_turfs_here()
	return shuttle.anchor.aabb_ordered_turfs_here()

/**
 * todo: support tuple list(x,y,z) location params
 *
 * @return turfs in square box, unfiltered
 */
/obj/shuttle_port/proc/aabb_ordered_turfs_at(turf/location, direction = src.dir)
	// get our offsets
	var/dx_from_anchor = shuttle.anchor.x - src.x
	var/dy_from_anchor = shuttle.anchor.y - src.y

	// dir2angle is north-zero clockwise.
	// turn_amount will therefore be how much we need to turn clockwise to
	// get there.
	//
	// note that since we know this will be a whole number,
	// we use the native % instead of our fractional-supporting MODULUS() macro.
	var/turn_amount = (dir2angle(shuttle.anchor.dir) - dir2angle(direction)) % 360

	// converted x/y is where the anchor will be
	// after being rotated in its current location, in respect to ourselves
	var/converted_x
	var/converted_y

	switch(turn_amount)
		if(0)
			converted_x = src.x - dx_from_anchor
			converted_y = src.y - dy_from_anchor
		if(90)
			converted_x = src.x - dy_from_anchor
			converted_y = src.y + dx_from_anchor
		if(180)
			converted_x = src.x + dx_from_anchor
			converted_y = src.y + dy_from_anchor
		if(270)
			converted_x = src.x + dy_from_anchor
			converted_y = src.y - dx_from_anchor
		else
			CRASH("what?")

	// now that we have where the anchor will be when rotated in respect
	// to ourselves, we can offset it to get where we wish to go.

	var/dx_from_new = location.x - src.x
	var/dy_from_new = location.y - src.y

	return shuttle.anchor.aabb_ordered_turfs_at(
		list(
			converted_x + dx_from_new,
			converted_y + dy_from_new,
			location.z,
		),
		direction,
	)

/**
 * checks if we'll clip a zlevel edge or another shtutle at a location
 *
 * the weird return is for optimization reasons.
 *
 * todo: support tuple list(x,y,z) location params
 *
 * @return null if we will clip, list(ordered turfs) if we won't clip
 */
/obj/shuttle_port/proc/aabb_ordered_turfs_at_and_clip_check(turf/location, direction)
	// get our offsets
	var/dx_from_anchor = shuttle.anchor.x - src.x
	var/dy_from_anchor = shuttle.anchor.y - src.y

	// dir2angle is north-zero clockwise.
	// turn_amount will therefore be how much we need to turn clockwise to
	// get there.
	//
	// note that since we know this will be a whole number,
	// we use the native % instead of our fractional-supporting MODULUS() macro.
	var/turn_amount = (dir2angle(shuttle.anchor.dir) - dir2angle(direction)) % 360

	// converted x/y is where the anchor will be
	// after being rotated in its current location, in respect to ourselves
	var/converted_x
	var/converted_y

	switch(turn_amount)
		if(0)
			converted_x = src.x - dx_from_anchor
			converted_y = src.y - dy_from_anchor
		if(90)
			converted_x = src.x - dy_from_anchor
			converted_y = src.y + dx_from_anchor
		if(180)
			converted_x = src.x + dx_from_anchor
			converted_y = src.y + dy_from_anchor
		if(270)
			converted_x = src.x + dy_from_anchor
			converted_y = src.y - dx_from_anchor
		else
			CRASH("what?")

	// now that we have where the anchor will be when rotated in respect
	// to ourselves, we can offset it to get where we wish to go.

	var/dx_from_new = location.x - src.x
	var/dy_from_new = location.y - src.y

	return shuttle.anchor.aabb_ordered_turfs_at_and_clip_check(
		list(
			converted_x + dx_from_new,
			converted_y + dy_from_new,
			location.z,
		),
		direction,
	)

/obj/shuttle_port/forceMove()
	CRASH("attempted to forcemove a shuttle anchor")

/obj/shuttle_port/grid_move(grid_flags, turf/new_turf)
	return

/obj/shuttle_port/grid_after(grid_flags, rotation_angle, list/late_call_hooks)
	return

/obj/shuttle_port/grid_collect(grid_flags, turf/new_turf, loc_opinion)
	return

/obj/shuttle_port/grid_finished(grid_flags, rotation_angle)
	return

#define SHUTTLE_PORT_PATH(PATH) \
/obj/shuttle_port/##PATH/primary { \
	primary_port = TRUE; \
	color = "#88ff88"; \
} \
/obj/shuttle_port/##PATH

/obj/shuttle_port/north
	dir = NORTH

SHUTTLE_PORT_PATH(south)
	dir = SOUTH

SHUTTLE_PORT_PATH(east)
	dir = EAST

SHUTTLE_PORT_PATH(west)
	dir = WEST

SHUTTLE_PORT_PATH(two_wide)
	abstract_type = /obj/shuttle_port/two_wide
	icon = 'icons/modules/shuttles/shuttle_anchor_2x2.dmi'
	icon_state = "dock"
	port_width = 2

SHUTTLE_PORT_PATH(two_wide/left_aligned)

SHUTTLE_PORT_PATH(two_wide/left_aligned/north)
	dir = NORTH

SHUTTLE_PORT_PATH(two_wide/left_aligned/south)
	dir = SOUTH
	port_offset = 1

SHUTTLE_PORT_PATH(two_wide/left_aligned/east)
	dir = EAST
	port_offset = 1

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
