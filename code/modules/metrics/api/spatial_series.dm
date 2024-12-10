//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

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
/datum/metric/spatial_series
	/// Whether the spatial metric corrosponds to the actual in-game map
	var/is_game_world = FALSE
	/// Don't render a tally of '1'
	var/elide_singular_tally = TRUE
	/// We care about time
	var/is_time_series = FALSE

/proc/metric_record_spatial_series_single(datum/metric/spatial_series/typepath, x, y, level_id, tally, comment)
	return

/proc/metric_record_spatial_series_box(datum/metric/spatial_series/typepath, x1, y1, x2, y2, level_id, tally, comment)
	return
