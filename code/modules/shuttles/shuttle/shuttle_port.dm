//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * shuttle-side docking port; put this on airlocks
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
	atom_flags = ATOM_ABSTRACT | ATOM_NONWORLD

#ifndef CF_SHUTTLE_VISUALIZE_BOUNDING_BOXES
	invisibility = INVISIBILITY_ABSTRACT
#else
	invisibility = INVISIBILITY_NONE
#endif

	/// shuttle datum
	var/tmp/datum/shuttle/shuttle

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
	var/tmp/list/datum/shuttle_hook/hooks

	/// is this the primary port?
	/// if it is, this is what we align with for roundstart loading.
	var/primary_port = FALSE

	/// are we moving right now?
	var/tmp/port_moving = FALSE

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
/obj/shuttle_port/proc/calculate_motion_with_respect_to(list/old_coords, list/new_coords, old_dir, new_dir)
	return calculate_entity_motion_with_respect_to_moving_point(
		list(src.x, src.y, src.z),
		src.dir,
		old_coords,
		new_coords,
		old_dir,
		new_dir,
	)

/**
 * @return turfs in square box, unfiltered
 */
/obj/shuttle_port/proc/aabb_ordered_turfs_here()
	return shuttle.anchor.aabb_ordered_turfs_here()

/**
 * @params
 * * location - turf or list(x,y,z)
 * * direction - which way we should be facing when we're done
 *
 * @return turfs in square box, unfiltered. turfs that don't exist will be nulls.
 */
/obj/shuttle_port/proc/aabb_ordered_turfs_at(turf/location, direction = src.dir)
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
/obj/shuttle_port/proc/aabb_ordered_turfs_at_and_clip_check(turf/location, direction)
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
/obj/shuttle_port/proc/check_dock_seal(obj/shuttle_dock/dock)
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

//* Regular Movement *//

/obj/shuttle_port/forceMove()
	CRASH("attempted to forceMove a shuttle port")

/obj/shuttle_port/setDir(ndir)
	if(!port_moving)
		CRASH("attempted to setDir a shuttle port")
	return ..()

/obj/shuttle_port/abstract_move(atom/new_loc)
	if(!port_moving)
		CRASH("attempted to abstract_move a shuttle port")
	return ..()

//* Grid Hooks ; Shuttle manually moves us. *//

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
