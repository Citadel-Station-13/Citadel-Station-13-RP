//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Antimagic provider.
 */
/datum/antimagic

/**
 * Simple scaling
 *
 * We fully block magic at a given potency, falling off linearly to a given other potency.
 */
/datum/antimagic/simple
	/// magic types blocked
	var/magic_types = MAGIC_TYPES_ALL
	/// potency we can block fully
	var/full_block_potency = 100
	/// potency we stop blocking at
	var/cant_block_potency = 200


#warn impl all
