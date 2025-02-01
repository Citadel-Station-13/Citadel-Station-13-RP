//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Instance descriptors of sprite accessories.
 */
/datum/sprite_accessory_descriptor
	//* Descriptions *//

	/// sprite accessory ID
	var/id
	/// color channels, packed
	var/packed_coloration
	/// emissive power; 0 to 1, with 0 being off
	var/emissive = 0
	/// markings: id = /datum/sprite_accessory_marking_descriptor instance
	var/list/markings

	//* Buffers *//

	/// color channels, unpacked
	///
	/// * this follows the coloration format; this is not necessarily a list of colors
	/// * this is done on render
	var/tmp/list/unpacked_coloration

/datum/sprite_accessory_descriptor/serialize()
	return list(
		"id" = id,
		"coloration" = packed_coloration,
		"emissive" = emissive,
	)

/datum/sprite_accessory_descriptor/deserialize(list/data)
	id = data["id"]
	packed_coloration = data["coloration"]
	emissive = data["emissive"]

/**
 * Set coloration to a packed string.
 *
 * * Does not sanitize. Be careful.
 */
/datum/sprite_accessory_descriptor/proc/set_packed_coloration(packed)
	packed_coloration = pack_coloration_string(packed)
	unpacked_coloration = null

/**
 * Set coloration to a set of colors.
 *
 * * Does not sanitize. Be careful.
 */
/datum/sprite_accessory_descriptor/proc/set_unpacked_coloration(list/colors)
	packed_coloration = pack_coloration_string(colors)
	unpacked_coloration = null

/**
 * @return list of colors
 */
/datum/sprite_accessory_descriptor/proc/get_unpacked_coloration()
	if(!unpacked_coloration)
		unpacked_coloration = unpack_coloration_string(packed_coloration)
	return unpacked_coloration
