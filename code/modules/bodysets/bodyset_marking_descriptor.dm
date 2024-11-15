//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Instance descriptors of body markings.
 */
/datum/bodyset_marking_descriptor
	/// body marking ID
	var/id
	/// color channels, packed
	var/packed_coloration
	/// emissive power; 0 to 255, with 0 being off
	var/emissive = 0
	/// layer adjust
	///
	/// * -10 to 10 allowed
	var/layer = 0

	/// color channels, unpacked
	///
	/// * this follows the coloration format; this is not necessarily a list of colors
	/// * this is done on render
	var/list/unpacked_coloration

/datum/bodyset_marking_descriptor/serialize()
	return list(
		"id" = id,
		"coloration" = packed_coloration,
		"emissive" = emissive,
		"layer" = layer,
	)

/datum/bodyset_marking_descriptor/deserialize(list/data)
	id = data["id"]
	packed_coloration = data["coloration"]
	emissive = data["emissive"]
	layer = data["layer"]

/datum/bodyset_marking_descriptor/ui_serialize()
	return list(
		"id" = id,
		"colors" = get_unpacked_coloration(),
		"emissive" = emissive,
		"layer" = layer,
	)

/datum/bodyset_marking_descriptor/proc/set_packed_coloration(packed)
	packed_coloration = packed
	unpacked_coloration = null

/datum/bodyset_marking_descriptor/proc/set_unpacked_coloration(list/colors)
	packed_coloration = pack_coloration_string(colors)
	unpacked_coloration = null

/datum/bodyset_marking_descriptor/proc/get_unpacked_coloration()
	if(!unpacked_coloration)
		unpack_coloration_string(packed_coloration)
	return unpacked_coloration
