//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * A single tile in a jigsaw template's pattern
 *
 * * Each tile has a list of match / exclude for each side.
 * * The match / require / exclude lists are used to determine if this tile can be placed
 *   next to another tile.
 * * All lists are immutable and potentially (likely) shared for efficiency.
 * * Tags is tags for that side of ourselves.
 * * Require is tags that must be present on the other side of the adjacent tile.
 * * Exclude is tags that must NOT be present on the other side of the adjacent tile
 * * Tags must be set on a side for it to be joinable.
 * * Technically, required / exclude is not enforced for non-joinable sides,
 *   but currently a border of 1 tile is placed around each ruin
 *   so it's fine.
 */
/datum/jigsaw_tile
	var/list/north_tags
	var/list/north_require
	var/list/north_exclude

	var/list/south_tags
	var/list/south_require
	var/list/south_exclude

	var/list/east_tags
	var/list/east_require
	var/list/east_exclude

	var/list/west_tags
	var/list/west_require
	var/list/west_exclude
