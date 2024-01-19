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
	#warn sprite
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

/**
 * @return turfs in square box, unfiltered
 */
/obj/shuttle_anchor/proc/ordered_turfs_here()
	return ordered_turfs_at(loc)

/**
 * @return turfs in square box, unfiltered
 */
/obj/shuttle_anchor/proc/ordered_turfs_at(turf/anchor, direction)
	ASSERT(isturf(anchor))
	#warn impl

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
