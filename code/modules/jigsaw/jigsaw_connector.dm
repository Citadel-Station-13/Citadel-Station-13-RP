//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * Only set during a load cycle that wants to use connectors.
 */
GLOBAL_LIST(jigsaw_connectors_pending)

/datum/jigsaw_pending_connector
	var/x
	var/y
	var/z
	var/width
	var/margin
	var/direction

	var/spent = FALSE

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

	/// set if we detect another jigsaw connector spawning onto us
	var/matched = FALSE

	/// our pending connector.
	/// * we un-reference this on destroy, but when we match, we mark it as 'spent' for disposal.
	var/datum/jigsaw_pending_connector/pending


/obj/jigsaw_connector/New()
	if(GLOB.jigsaw_connectors_pending)
		var/datum/jigsaw_pending_connector/pending = new
		pending.x = src.x
		pending.y = src.y
		pending.z = src.z
		pending.width = src.width
		pending.margin = src.margin
		pending.direction = src.dir
		GLOB.jigsaw_connectors_pending += pending
		src.pending = pending
	try_match_other()
	return ..()

/obj/jigsaw_connector/Initialize()
	SHOULD_CALL_PARENT(FALSE)
	return INITIALIZE_HINT_QDEL

/obj/jigsaw_connector/Destroy()
	pending = null
	return ..()

/obj/jigsaw_connector/proc/on_match()
	matched = TRUE
	pending?.spent = TRUE

/obj/jigsaw_connector/proc/try_match_other()
#warn impl

/obj/jigsaw_connector/two_wide
	icon_state = "connector-2-1"
	width = 2

/obj/jigsaw_connector/three_wide
	icon_state = "connector-3-1"
	width = 3
