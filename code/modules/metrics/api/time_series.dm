//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * records a series of values at given times
 *
 * * Supports a number, string, or both.
 *
 * This is what you can use for things like:
 *
 * * Time dilation tracking
 */
/datum/metric/time_series
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
/proc/metric_record_time_series(datum/metric/time_series/typepath, value, comment)
	return
