//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/datum/jigsaw_template_pattern
	var/override_tile_cost = null

/datum/jigsaw_template_pattern/proc/get_pattern() as /datum/jigsaw_pattern
	return new /datum/jigsaw_pattern(0, 0)


#warn emplace

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

	/**
	 * If for whatever reason you need to offset (in alignment multiples), this lets you do it.
	 * As an example, you can offset -1, -1 for a three-by-three on a 1x1 to effectively
	 * center it.
	 * * This is in alignment multiples, not tiles.
	 */
	var/x_offset = 0
	/**
	 * If for whatever reason you need to offset (in alignment multiples), this lets you do it.
	 * As an example, you can offset -1, -1 for a three-by-three on a 1x1 to effectively
	 * center it.
	 * * This is in alignment multiples, not tiles.
	 */
	var/y_offset = 0

/datum/jigsaw_template_pattern/rect/s_1x1
	width = 1
	height = 1

	var/list/south_match
	var/list/south_exclude

	var/list/north_match
	var/list/north_exclude

	var/list/east_match
	var/list/east_exclude

	var/list/west_match
	var/list/west_exclude

/datum/jigsaw_template_pattern/rect/s_2x2
	width = 2
	height = 2

	var/list/south_match
	var/list/south_exclude
	var/list/south_left_match
	var/list/south_left_exclude
	var/list/south_right_match
	var/list/south_right_exclude

	var/list/north_match
	var/list/north_exclude
	var/list/north_left_match
	var/list/north_left_exclude
	var/list/north_right_match
	var/list/north_right_exclude

	var/list/east_match
	var/list/east_exclude
	var/list/east_top_match
	var/list/east_top_exclude
	var/list/east_bottom_match
	var/list/east_bottom_exclude

	var/list/west_match
	var/list/west_exclude
	var/list/west_top_match
	var/list/west_top_exclude
	var/list/west_bottom_match
	var/list/west_bottom_exclude

/datum/jigsaw_template_pattern/rect/s_3x3
	width = 3
	height = 3

	var/list/south_match
	var/list/south_exclude
	var/list/south_left_match
	var/list/south_left_exclude
	var/list/south_middle_match
	var/list/south_middle_exclude
	var/list/south_right_match
	var/list/south_right_exclude

	var/list/north_match
	var/list/north_exclude
	var/list/north_left_match
	var/list/north_left_exclude
	var/list/north_middle_match
	var/list/north_middle_exclude
	var/list/north_right_match
	var/list/north_right_exclude

	var/list/east_match
	var/list/east_exclude
	var/list/east_top_match
	var/list/east_top_exclude
	var/list/east_middle_match
	var/list/east_middle_exclude
	var/list/east_bottom_match
	var/list/east_bottom_exclude

	var/list/west_match
	var/list/west_exclude
	var/list/west_top_match
	var/list/west_top_exclude
	var/list/west_middle_match
	var/list/west_middle_exclude
	var/list/west_bottom_match
	var/list/west_bottom_exclude
