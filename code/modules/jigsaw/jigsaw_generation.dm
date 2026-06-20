//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/datum/jigsaw_generation_template
	var/lower_left_x
	var/lower_left_y
	var/lower_left_z
	var/orientation
	var/datum/jigsaw_template/template

/datum/jigsaw_generation_tile
	var/x
	var/y
	var/datum/jigsaw_generation_template/enqueued
	var/list/north_match
	var/list/north_exclude
	var/list/south_match
	var/list/south_exclude
	var/list/east_match
	var/list/east_exclude
	var/list/west_match
	var/list/west_exclude

/**
 * Datum used to hold current state for a jigsaw dungeon generation.
 */
/datum/jigsaw_generation
	var/width
	var/height
	/**
	 * Grid. This is a flat spatial grid with widthxheight of the intended generation.
	 */
	var/list/grid

/datum/jigsaw_generation/New(width, height)
	src.width = width
	src.height = height

	src.grid = new /list(src.width * src.height)

// var/idx = ceil(root.x / TURF_CHUNK_RESOLUTION) + grid_width * (ceil(root.y / TURF_CHUNK_RESOLUTION) - 1)

#warn impl

/datum/jigsaw_generation/proc/cleanup()
	QDEL_LIST(pending_connectors)
