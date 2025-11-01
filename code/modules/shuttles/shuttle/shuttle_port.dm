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

/obj/shuttle_port/preloading_from_mapload(with_id)
	. = ..()
	port_id = SSmapping.mangled_persistent_id(port_id, with_id)

// This file is WIP, and is just here so mappers can start using them.

//* Movement Hooks ; We don't allow normal movement. *//

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
