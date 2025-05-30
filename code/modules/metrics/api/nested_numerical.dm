//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * nested numerical metric
 *
 * This is what you can use for things like:
 *
 * * How many times an admin verb was pressed in a round
 */
/datum/metric/nested_numerical

/**
 * overwrites a nested numerical metric
 */
/proc/metric_set_nested_numerical(datum/metric/nested_numerical/typepath, key = "--unset--", amount)
	return

/**
 * increments a nested numerical metric
 */
/proc/metric_increment_nested_numerical(datum/metric/nested_numerical/typepath, key = "--unset--", amount = 1)
	return
