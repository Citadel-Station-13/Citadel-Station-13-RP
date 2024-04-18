//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

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

/obj/shuttle_anchor/proc/before_bounds_initializing(datum/shuttle/from_shuttle, datum/turf_reservation/from_reservation, datum/shuttle_template/from_template)
	shuttle = from_shuttle
	#warn impl

/obj/shuttle_anchor/proc/calculate_bounds(bottomleft_x, bottomleft_y, topright_x, topright_y, initial_direction)
	ASSERT(bottomleft_x && bottomleft_y && topright_x && topright_y && initial_direction)
	#warn impl

/obj/shuttle_anchor/Destroy(force)
	if(!force && !shuttle.being_deleted)
		. = QDEL_HINT_LETMELIVE
		CRASH("attempted to delete a shuttle anchor")
	shuttle = null
	return ..()

/obj/shuttle_anchor/proc/overall_width(direction)
	#warn impl

/obj/shuttle_anchor/proc/overall_height(direction)
	#warn impl

/**
 * @return turfs in square box, unfiltered
 */
/obj/shuttle_anchor/proc/aabb_ordered_turfs_here()
	return aabb_ordered_turfs_at(loc)

/**
 * @return turfs in square box, unfiltered
 */
/obj/shuttle_anchor/proc/aabb_ordered_turfs_at(turf/anchor, direction = src.dir)
	ASSERT(isturf(anchor))
	var/x = anchor.x
	var/y = anchor.y
	switch(dir)
		if(NORTH)
			return SSgrids.get_ordered_turfs(
				x - offset_x,
				x + size_x - 1 - offset_x,
				y - size_y + 1,
				y - offset_y,
				z,
				NORTH,
			)
		if(SOUTH)
			return SSgrids.get_ordered_turfs(
				x - size_x + 1 + offset_x,
				x + offset_x,
				y - offset_y,
				y + size_y - offset_y - 1,
				z,
				SOUTH,
			)
		if(EAST)
			return SSgrids.get_ordered_turfs(
				x - size_y + 1 + offset_y,
				x + offset_y,
				y - size_x + 1 + offset_x,
				y + offset_x,
				z,
				EAST,
			)
		if(WEST)
			return SSgrids.get_ordered_turfs(
				x - offset_y,
				x + size_y - 1 - offset_y,
				y - offset_x,
				y + size_x - 1 - offset_x,
				z,
				WEST,
			)

// 	// todo: more default heuristic spots

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
	#warn impl

#warn impl all

/obj/shuttle_anchor/grid_move(grid_flags, turf/new_turf)
	return

/obj/shuttle_anchor/grid_after(grid_flags, rotation_angle, list/late_call_hooks)
	return

/obj/shuttle_anchor/grid_collect(grid_flags, turf/new_turf, loc_opinion)
	return

/obj/shuttle_anchor/grid_finished(grid_flags, rotation_angle)
	return
