//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Instance descriptors of sprite accessories.
 *
 * * Anything that needs to modify any variable - including 'variation' - must own their copy. Use clone() as needed.
 */
/datum/sprite_accessory_descriptor
	//* Descriptions *//

	/// sprite accessory ID
	var/id
	/// color channels, if the accessory is colorable
	var/list/colors
	/// emissive power; 0 to 1, with 0 being off
	var/emissive = 0
	/// markings: id = /datum/sprite_accessory_marking_descriptor instance
	var/list/markings
	/// active variation
	var/variation

/datum/sprite_accessory_descriptor/serialize()
	. = list(
		"id" = id,
		"colors" = colors,
		"emissive" = emissive,
	)
	if(markings)
		var/list/serialized_markings = list()
		for(var/id in markings)
			var/datum/sprite_accessory_marking_descriptor/marking_descriptor = markings[id]
			serialized_markings[id] = marking_descriptor.serialize()
		.["markings"] = serialized_markings

/datum/sprite_accessory_descriptor/deserialize(list/data)
	id = data["id"]
	colors = data["colors"]
	emissive = data["emissive"]
	if(data["markings"])
		var/list/serialized_marking_descriptors = data["markings"]
		for(var/id in serialized_marking_descriptors)
			var/datum/sprite_accessory_marking_descriptor/deserialized_marking_descriptor = new
			deserialized_marking_descriptor.deserialize(serialized_marking_descriptors[id])
			markings[id] = deserialized_marking_descriptor

/datum/sprite_accessory_descriptor/clone()
	var/datum/sprite_accessory_descriptor/creating = new
	creating.id = id
	creating.colors = colors?.Copy()
	creating.emissive = emissive
	if(markings)
		var/list/built_markings = list()
		for(var/id in markings)
			var/datum/sprite_accessory_marking_descriptor = markings[id]
			built_markings[id] = marking_descriptor.clone
		creating.markings = built_markings
	creating.variation = variation
	return creating

/datum/sprite_accessory_descriptor/proc/operator~=(datum/sprite_accessory_descriptor/other)
	if(!istype(other))
		return FALSE
	if(id != other.id)
		return FALSE
	if(colors !~ other.colors)
		return FALSE
	if(emissive != other.emissive)
		return FALSE
	if(length(markings ^ other.markings))
		return FALSE
	for(var/id in markings)
		if(markings[id] !~ other.markings[id])
			return FALSE
	if(variation != other.variation)
		return FALSE
	return TRUE
