//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Arbitrary string-sequence combo.
 */
/datum/combo
	/// strings, in order, from first to last, in combo
	var/list/keys = list()

/datum/combo/New(list/keys = src.keys)
	src.keys = keys

/datum/combo/proc/get_length() as num
	return length(keys)
