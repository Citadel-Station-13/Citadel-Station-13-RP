//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * A single tile in a jigsaw template's pattern
 *
 * * Each tile has a list of match / exclude for each side.
 * * The match / require / exclude lists are used to determine if this tile can be placed
 *   next to another tile.
 * * All lists are immutable and potentially (likely) shared for efficiency.
 * * Match is tags for that side of ourselves.
 * * Require is tags that must be present on the other side of the adjacent tile.
 * * Exclude is tags that must NOT be present on the other side of the adjacent tile
 */
/datum/jigsaw_tile
	var/list/north_match
	var/list/north_require
	var/list/north_exclude

	var/list/south_match
	var/list/south_require
	var/list/south_exclude

	var/list/east_match
	var/list/east_require
	var/list/east_exclude

	var/list/west_match
	var/list/west_require
	var/list/west_exclude
