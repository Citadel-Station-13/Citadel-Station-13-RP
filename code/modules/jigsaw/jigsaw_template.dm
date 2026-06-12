//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * Detected / specified connector.
 */
/datum/jigsaw_template_connector
	/// x offset from lower left
	var/x_offset
	/// y offset from lower left
	var/y_offset
	/// Direction facing
	/// * Connectors can only connect to other connectors facing the opposite direction.
	var/direction
	var/width
	var/margin

/datum/jigsaw_template
	/// the name of this template, used for debugging and referencing in other templates.
	var/name = "Dungeon Fragment"
	/// path on disk
	var/path

	/// parsed map if held
	var/datum/dmm_parsed/parsed

	/**
	 * Are we fully convex?
	 * * Fully convex means there are no non-skipover turfs more 'outside'
	 *   on any side than a connector.
	 * * Fully convex templates can be planned out without actually loading,
	 *   and are the only things allowed in the first phase of jigsaw generation.
	 */
	var/convex = FALSE

	/**
	 * Connectors with locations.
	 */
	var/list/datum/jigsaw_template_connector/connectors = list()

#warn impl
