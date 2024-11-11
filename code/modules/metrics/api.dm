//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * counter metric
 *
 * * numerical, can only go up through a round
 */
/datum/metric/counter

/**
 * increments a counter metric by an amount, defaulting to 1
 *
 * * The time at which this is called does matter. The recorded metric will be at the current
 *   time of the recording.
 *
 * This is what you can use for things like:
 *
 * * How many times an admin verb was pressed in a round
 * * How many times a thing happened in a round
 */
/proc/metric_record_counter(datum/metric/counter/typepath, amount = 1)
	return

/**
 * records a series of values at given times
 *
 * * Supports a number, string, or both.
 *
 * This is what you can use for things like:
 *
 * * Time dilation tracking
 */
/datum/metric/series
	/// has numerical data to graph
	///
	/// * doesn't limit the data, only determines if we try to pull a graph
	var/graph_exists = FALSE
	/// representation of numerical data in graph
	///
	/// * valid values are ["average", "tally"]
	var/graph_collate = "tally"

/**
 * records a number or a string in a series metric
 *
 * * The time at which this is called does matter. The recorded metric will be at the current
 *   time of the recording.
 */
/proc/metric_record_series(datum/metric/series/typepath, tally, comment)
	return

/**
 * Records an event at a specific tile of a map
 *
 * * Supports a single tile event with annotation of number and/or string
 * * Supports a rectangular event with annotation of number and/or string
 *
 * This is usually used for game-map purposes, but is actually usable as an arbitrary
 * spatial metric if you need it for whatever reason.
 *
 * This is what you can use for things like:
 *
 * * Tracking where people died
 * * Tracking what explodes
 * * Tracking what goes wrong where
 */
/datum/metric/spatial
	/// Whether the spatial metric corrosponds to the actual in-game map
	var/is_game_world = FALSE
	/// Don't render a tally of '1'
	var/elide_singular_tally = TRUE

/proc/metric_record_spatial_single(datum/metric/spatial/typepath, x, y, level_id, tally, comment)
	return
	
/proc/metric_record_spatial_box(datum/metric/spatial/typepath, x1, y1, x2, y2, level_id, tally, comment)
	return
