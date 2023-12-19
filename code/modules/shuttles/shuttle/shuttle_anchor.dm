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
 */
/obj/shuttle_anchor
	name = "Shuttle (uninitialized)"
	desc = "Why do you see this?"
	#warn sprite
	invisibility = INVISIBILITY_ABSTRACT

	/// shuttle datum to init - typepath
	var/shuttle_datum_typepath
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

/obj/shuttle_anchor/proc/ordered_turfs_here()
	return ordered_turfs_at(loc)

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
	ASSERT(direction in GLOB.cardinals)
	#warn impl

#warn impl all

/**
 * Main shuttle anchor; must have one per shuttle.
 */
/obj/shuttle_anchor/master
	#warn sprite

/**
 * Dock anchor; put this on docks.
 */
/obj/shuttle_anchor/port
	/// port name - used in interfaces
	name = "docking port"
	/// port desc - used in interfaces
	desc = "A port that allows the shuttle to align to a dock."
	#warn sprite

	/// dock width - this is how wide the airlock/otherwise opening is.
	///
	/// the port is left-aligned to the width
	/// so if it's width 3,
	/// we have this:
	/// ^XX
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
	#warn id scrambling
