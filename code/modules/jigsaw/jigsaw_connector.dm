//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * Only set during a load cycle that wants to use connectors.
 */
GLOBAL_LIST(jigsaw_connectors_pending)

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

	var/is_registered = FALSE

	// Inner width.
	// * If this is even, the connector is left-biased in its real direction, facing in
	//   its direction; so if it's NORTH width 2, the connector is its tile and one to the east.
	var/width = 1
	// Outer width. (Margin)
	// * This is the tiles in both left and right directions that are presumed safe / sealed.
	var/margin = 1

/obj/jigsaw_connector/New()
	if(GLOB.jigsaw_connectors_pending)
		GLOB.jigsaw_connectors_pending += src
		is_registered = TRUE
	return ..()

/obj/jigsaw_connector/Initialize()
	if(!is_registered)
		return INITIALIZE_HINT_QDEL
	return ..()

#warn impl

/obj/jigsaw_connector/two_wide
	icon_state = "connector-2-1"
	width = 2

/obj/jigsaw_connector/three_wide
	icon_state = "connector-3-1"
	width = 3
