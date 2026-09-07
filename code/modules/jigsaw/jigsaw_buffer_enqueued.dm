//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/datum/jigsaw_buffer_enqueued
	var/lower_left_grid_x
	var/lower_left_grid_y
	/**
	 * * Starts at SOUTH.
	 */
	var/orientation
	var/datum/prototype/jigsaw_template/template
	var/datum/dmm_context/context

	var/list/datum/jigsaw_buffer_tile/tiles = list()

/datum/jigsaw_buffer_enqueued/New(datum/prototype/jigsaw_template/template, lower_left_grid_x, lower_left_grid_y, orientation, datum/dmm_context/context)
	src.template = template
	src.lower_left_grid_x = lower_left_grid_x
	src.lower_left_grid_y = lower_left_grid_y
	src.orientation = orientation
	src.context = context

/datum/jigsaw_buffer_enqueued/Destroy()
	src.template = null
	src.context = null
	src.tiles = null
	return ..()

/**
 * * Does not fire off atom init.
 */
/datum/jigsaw_buffer_enqueued/proc/load_into_world(lower_left_x, lower_left_y, z) as /datum/dmm_context
	// get the real offset'd relative grid coordinates from lower left
	var/ll_grid_x = src.lower_left_grid_x + src.template.offset_x
	var/ll_grid_y = src.lower_left_grid_y + src.template.offset_y

	// translate to world coordinates, with the lower left grid x / y 1 / 1 being
	// at the provided lower left x/y.

	var/ll_real_x = lower_left_x + (ll_grid_x - 1) * TURF_ALIGNMENT
	var/ll_real_y = lower_left_y + (ll_grid_y - 1) * TURF_ALIGNMENT

	// load
	template.load_cached()
	var/datum/dmm_parsed/parsed_map = template.parsed

	return parsed_map.load(ll_real_x, ll_real_y, z, orientation = src.orientation, context = src.context)
