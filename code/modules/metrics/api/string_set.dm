//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Records an unique set of strings.
 *
 * This is what you can use for things like:
 *
 * * What subsystems failed init
 */
/datum/metric/string_set

/**
 * records a string into a string set
 */
/proc/metric_record_string_set(datum/metric/string_set/typepath, string)
	return
