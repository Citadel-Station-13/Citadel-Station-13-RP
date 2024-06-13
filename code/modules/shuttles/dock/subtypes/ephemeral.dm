//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * ephemeral docks
 *
 * deletes when a shuttle leaves
 */
/obj/shuttle_dock/ephemeral
	create_bounding_box_area = FALSE

/obj/shuttle_dock/ephemeral/on_shuttle_departed(datum/shuttle/shuttle)
	#warn make sure it doesn't delete if the shuttle is coming right backbaglist
	qdel(src)

/**
 * manual dock
 */
/obj/shuttle_dock/ephemeral/manual

/**
 * transit dock
 */
/obj/shuttle_dock/ephemeral/transit
