//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * Only set during a load cycle that wants to use connectors.
 */
GLOBAL_LIST(jigsaw_connectors_pending)

/datum/jigsaw_pending_connector
	var/x
	var/y
	var/width
	var/margin
	var/direction

/**
 * Denotes a **possible** connection point for jigsaw pieces.
 *
 * Connectors are matched ontop of each other by reversing the direction
 * and checking if they can fit in.
 *
 * # Matching
 * Section WIP.
 */
/obj/jigsaw_connector
	#warn sprite
	icon = 'icons/modules/jigsaw/jigsaw_connector_3x3.dmi'
	icon_state = "connector-1-1"
	pixel_x = -32
	pixel_y = -32

	// Inner width.
	// * If this is even, the connector is left-biased in its real direction, facing in
	//   its direction; so if it's NORTH width 2, the connector is its tile and one to the east.
	var/width = 1
	// Outer width. (Margin)
	// * This is the tiles in both left and right directions that are presumed safe / sealed.
	var/margin = 1

/obj/jigsaw_connector/New()
	if(GLOB.jigsaw_connectors_pending)
		var/datum/jigsaw_pending_connector/pending = new
		pending.x = src.x
		pending.y = src.y
		pending.width = src.width
		pending.margin = src.margin
		pending.direction = src.dir
		GLOB.jigsaw_connectors_pending += pending
	return ..()

/obj/jigsaw_connector/Initialize()
	return INITIALIZE_HINT_QDEL

#warn impl

/obj/jigsaw_connector/two_wide
	icon_state = "connector-2-1"
	width = 2

/obj/jigsaw_connector/three_wide
	icon_state = "connector-3-1"
	width = 3
