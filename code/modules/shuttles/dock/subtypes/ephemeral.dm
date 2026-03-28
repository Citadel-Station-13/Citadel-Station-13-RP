//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * ephemeral docks
 *
 * deletes when a shuttle leaves
 */
/obj/shuttle_dock/ephemeral
	create_bounding_box_area = FALSE

/obj/shuttle_dock/ephemeral/on_shuttle_departed(datum/shuttle/shuttle)
	if(inbound)
		return
	qdel(src)

/**
 * manual dock
 */
/obj/shuttle_dock/ephemeral/manual
	protect_bounding_box = TRUE
	// no boxing someone in now!
	protect_bounding_box_extra_radius = 3
