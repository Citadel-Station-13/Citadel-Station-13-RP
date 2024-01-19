//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

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
	#warn id scrambling

	/// registered shuttle hooks
	var/list/datum/shuttle_hook/hooks

/obj/shuttle_port/Destroy(force)
	if(!force && !shuttle.being_deleted)
		. = QDEL_HINT_LETMELIVE
		CRASH("attempted to delete a shuttle anchor")
	shuttle = null
	return ..()

/**
 * @return turfs in square box, unfiltered
 */
/obj/shuttle_port/proc/ordered_turfs_here()
	return shuttle.anchor.ordered_turfs_at(loc)

/**
 * @return turfs in square box, unfiltered
 */
/obj/shuttle_port/proc/ordered_turfs_at(turf/anchor, direction)
	ASSERT(isturf(anchor))
	return shuttle.anchor.ordered_turfs_at(anchor, direction)

/obj/shuttle_port/north
	dir = NORTH

/obj/shuttle_port/south
	dir = SOUTH

/obj/shuttle_port/east
	dir = EAST

/obj/shuttle_port/west
	dir = WEST

/obj/shuttle_port/two_wide
	icon = 'icons/modules/shuttles/shuttle_anchor_2x2.dmi'
	icon_state = "dock"
	port_width = 2

/obj/shuttle_port/two_wide/north
	dir = NORTH

/obj/shuttle_port/two_wide/south
	dir = SOUTH
	port_offset = 1

/obj/shuttle_port/two_wide/east
	dir = EAST
	port_offset = 1

/obj/shuttle_port/two_wide/west
	dir = WEST

/obj/shuttle_port/three_wide
	icon = 'icons/modules/shuttles/shuttle_anchor_3x3.dmi'
	icon_state = "dock"
	port_width = 3

/obj/shuttle_port/three_wide/north
	dir = NORTH

/obj/shuttle_port/three_wide/south
	dir = SOUTH
	port_offset = 2

/obj/shuttle_port/three_wide/east
	dir = EAST
	port_offset = 2

/obj/shuttle_port/three_wide/west
	dir = WEST
