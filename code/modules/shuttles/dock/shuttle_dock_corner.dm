//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

GLOBAL_LIST_EMPTY(uninitialized_shuttle_dock_bounds)

/**
 * put them on the corners of a bounding box to form a bounding box
 *
 * the /obj/shuttle_dock must be inside one of these
 */
/obj/shuttle_dock_corner
	name = "dock corner"
	desc = "Why do you see this? Report it."
	#warn sprite

	#warn impl all

#warn impl all

/obj/shuttle_dock_corner/bottom_left

/obj/shuttle_dock_corner/bottom_right

/obj/shuttle_dock_corner/top_left

/obj/shuttle_dock_corner/top_right
