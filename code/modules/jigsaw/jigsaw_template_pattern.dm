//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * Template patterns.
 *
 * * Each
 */
/datum/jigsaw_template_pattern
	var/override_tile_cost = null

/**
 * Returns a potentially-cached pattern.
 */
/datum/jigsaw_template_pattern/proc/get_pattern() as /datum/jigsaw_pattern
	return new /datum/jigsaw_pattern(0, 0, override_tile_cost)

/**
 * rect bounding box over the template. the template is lower-left
 * aligned to this box.
 *
 * * width / height is in alignment multiples
 * * this is for 'south' facing orientation.
 */
/datum/jigsaw_template_pattern/rect
	abstract_type = /datum/jigsaw_template_pattern/rect

	/**
	 * * This is in alignment multiples, not tiles.
	 */
	var/width
	/**
	 * * This is in alignment multiples, not tiles.
	 */
	var/height

/datum/jigsaw_template_pattern/rect/get_pattern()
	var/datum/jigsaw_pattern/pattern = new(width, height, override_tile_cost)
	return pattern

/datum/jigsaw_template_pattern/rect/s_1x1
	width = 1
	height = 1

	var/list/south_tags
	var/list/south_require
	var/list/south_exclude

	var/list/north_tags
	var/list/north_require
	var/list/north_exclude

	var/list/east_tags
	var/list/east_require
	var/list/east_exclude

	var/list/west_tags
	var/list/west_require
	var/list/west_exclude

/datum/jigsaw_template_pattern/rect/s_1x1/get_pattern()
	var/datum/jigsaw_pattern/pattern = ..()

	var/datum/jigsaw_tile/tile = new
	tile.north_exclude = north_exclude
	tile.north_require = north_require
	tile.north_tags = north_tags
	tile.south_exclude = south_exclude
	tile.south_require = south_require
	tile.south_tags = south_tags
	tile.east_exclude = east_exclude
	tile.east_require = east_require
	tile.east_tags = east_tags
	tile.west_exclude = west_exclude
	tile.west_require = west_require
	tile.west_tags = west_tags

	pattern.pattern[1] = tile

	return pattern

/datum/jigsaw_template_pattern/rect/s_2x2
	width = 2
	height = 2

	var/list/south_tags
	var/list/south_require
	var/list/south_exclude
	var/list/south_left_tags
	var/list/south_left_require
	var/list/south_left_exclude
	var/list/south_right_tags
	var/list/south_right_require
	var/list/south_right_exclude

	var/list/north_tags
	var/list/north_require
	var/list/north_exclude
	var/list/north_left_tags
	var/list/north_left_require
	var/list/north_left_exclude
	var/list/north_right_tags
	var/list/north_right_require
	var/list/north_right_exclude

	var/list/east_tags
	var/list/east_require
	var/list/east_exclude
	var/list/east_top_tags
	var/list/east_top_require
	var/list/east_top_exclude
	var/list/east_bottom_tags
	var/list/east_bottom_require
	var/list/east_bottom_exclude

	var/list/west_tags
	var/list/west_require
	var/list/west_exclude
	var/list/west_top_tags
	var/list/west_top_require
	var/list/west_top_exclude
	var/list/west_bottom_tags
	var/list/west_bottom_require
	var/list/west_bottom_exclude


/datum/jigsaw_template_pattern/rect/s_2x2/get_pattern()
	var/datum/jigsaw_pattern/pattern = ..()

	var/datum/jigsaw_tile/tile

	// top left
	tile = new
	tile.north_exclude = north_left_exclude || north_exclude
	tile.north_require = north_left_require || north_require
	tile.north_tags = north_left_tags || north_tags
	tile.west_exclude = west_top_exclude || west_exclude
	tile.west_require = west_top_require || west_require
	tile.west_tags = west_top_tags || west_tags

	pattern.pattern[3] = tile

	// top right
	tile = new
	tile.north_exclude = north_right_exclude || north_exclude
	tile.north_require = north_right_require || north_require
	tile.north_tags = north_right_tags || north_tags
	tile.east_exclude = east_top_exclude || east_exclude
	tile.east_require = east_top_require || east_require
	tile.east_tags = east_top_tags || east_tags

	pattern.pattern[4] = tile

	// bottom left
	tile = new
	tile.south_exclude = south_left_exclude || south_exclude
	tile.south_require = south_left_require || south_require
	tile.south_tags = south_left_tags || south_tags
	tile.west_exclude = west_bottom_exclude || west_exclude
	tile.west_require = west_bottom_require || west_require
	tile.west_tags = west_bottom_tags || west_tags

	pattern.pattern[1] = tile

	// bottom right
	tile = new
	tile.south_exclude = south_right_exclude || south_exclude
	tile.south_require = south_right_require || south_require
	tile.south_tags = south_right_tags || south_tags
	tile.east_exclude = east_bottom_exclude || east_exclude
	tile.east_require = east_bottom_require || east_require
	tile.east_tags = east_bottom_tags || east_tags

	pattern.pattern[2] = tile

	return pattern

/datum/jigsaw_template_pattern/rect/s_3x3
	width = 3
	height = 3

	var/list/south_tags
	var/list/south_require
	var/list/south_exclude
	var/list/south_left_tags
	var/list/south_left_require
	var/list/south_left_exclude
	var/list/south_middle_tags
	var/list/south_middle_require
	var/list/south_middle_exclude
	var/list/south_right_tags
	var/list/south_right_require
	var/list/south_right_exclude

	var/list/north_tags
	var/list/north_require
	var/list/north_exclude
	var/list/north_left_tags
	var/list/north_left_require
	var/list/north_left_exclude
	var/list/north_middle_tags
	var/list/north_middle_require
	var/list/north_middle_exclude
	var/list/north_right_tags
	var/list/north_right_require
	var/list/north_right_exclude

	var/list/east_tags
	var/list/east_require
	var/list/east_exclude
	var/list/east_top_tags
	var/list/east_top_require
	var/list/east_top_exclude
	var/list/east_middle_tags
	var/list/east_middle_require
	var/list/east_middle_exclude
	var/list/east_bottom_tags
	var/list/east_bottom_require
	var/list/east_bottom_exclude

	var/list/west_tags
	var/list/west_require
	var/list/west_exclude
	var/list/west_top_tags
	var/list/west_top_require
	var/list/west_top_exclude
	var/list/west_middle_tags
	var/list/west_middle_require
	var/list/west_middle_exclude
	var/list/west_bottom_tags
	var/list/west_bottom_require
	var/list/west_bottom_exclude

/datum/jigsaw_template_pattern/rect/s_3x3/get_pattern()
	var/datum/jigsaw_pattern/pattern = ..()

	var/datum/jigsaw_tile/tile

	// bottom left
	tile = new
	tile.south_exclude = south_left_exclude || south_exclude
	tile.south_require = south_left_require || south_require
	tile.south_tags = south_left_tags || south_tags
	tile.west_exclude = west_bottom_exclude || west_exclude
	tile.west_require = west_bottom_require || west_require
	tile.west_tags = west_bottom_tags || west_tags

	pattern.pattern[(1 - 1) + 1] = tile

	// bottom middle
	tile = new
	tile.south_exclude = south_middle_exclude || south_exclude
	tile.south_require = south_middle_require || south_require
	tile.south_tags = south_middle_tags || south_tags

	pattern.pattern[(1 - 1) + 2] = tile

	// bottom right
	tile = new
	tile.south_exclude = south_right_exclude || south_exclude
	tile.south_require = south_right_require || south_require
	tile.south_tags = south_right_tags || south_tags
	tile.east_exclude = east_bottom_exclude || east_exclude
	tile.east_require = east_bottom_require || east_require
	tile.east_tags = east_bottom_tags || east_tags

	pattern.pattern[(1 - 1) + 3] = tile

	// middle left
	tile = new
	tile.west_exclude = west_middle_exclude || west_exclude
	tile.west_require = west_middle_require || west_require
	tile.west_tags = west_middle_tags || west_tags

	pattern.pattern[(2 - 1) + 1] = tile

	// middle middle
	tile = new

	pattern.pattern[(2 - 1) + 2] = tile

	// middle right
	tile = new
	tile.east_exclude = east_middle_exclude || east_exclude
	tile.east_require = east_middle_require || east_require
	tile.east_tags = east_middle_tags || east_tags

	pattern.pattern[(2 - 1) + 3] = tile

	// top left
	tile = new
	tile.north_exclude = north_left_exclude || north_exclude
	tile.north_require = north_left_require || north_require
	tile.north_tags = north_left_tags || north_tags
	tile.west_exclude = west_top_exclude || west_exclude
	tile.west_require = west_top_require || west_require
	tile.west_tags = west_top_tags || west_tags

	pattern.pattern[(3 - 1) + 1] = tile

	// top middle
	tile = new
	tile.north_exclude = north_middle_exclude || north_exclude
	tile.north_require = north_middle_require || north_require
	tile.north_tags = north_middle_tags || north_tags

	pattern.pattern[(3 - 1) + 2] = tile

	// top right
	tile = new
	tile.north_exclude = north_right_exclude || north_exclude
	tile.north_require = north_right_require || north_require
	tile.north_tags = north_right_tags || north_tags
	tile.east_exclude = east_top_exclude || east_exclude
	tile.east_require = east_top_require || east_require
	tile.east_tags = east_top_tags || east_tags

	pattern.pattern[(3 - 1) + 3] = tile

	return pattern

