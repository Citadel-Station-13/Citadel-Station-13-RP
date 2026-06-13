//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/datum/jigsaw_generation_enqueued_placement
	var/lower_left_x
	var/lower_left_y
	var/lower_left_z
	var/orientation
	var/datum/jigsaw_template/template

/**
 * Datum used to hold current state for a jigsaw dungeon generation.
 */
/datum/jigsaw_generation
	/**
	 * Broadphase emplacements.
	 */
	var/list/datum/jigsaw_generation_enqueued_placement/broadphase_enqueued = list()
	var/broadphase_emplaced = FALSE

	/**
	 * Yet to be assigned / consumed.
	 * * This is both pre- and post- convex broadphase. This allows
	 *   pending connectors to be emplaced even after the broadphase.
	 * * When the broadphase finishes, all connectors are checked for overlap,
	 *   and are removed from the list if needed. The rest are used for the 'live run'.
	 */
	var/list/datum/jigsaw_pending_connector/pending_connectors = list()


#warn impl

/datum/jigsaw_generation/proc/cleanup()
	QDEL_LIST(pending_connectors)
