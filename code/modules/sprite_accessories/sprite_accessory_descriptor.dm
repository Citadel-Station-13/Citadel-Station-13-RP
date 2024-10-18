//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Instance descriptors of sprite accessories.
 */
/datum/sprite_accessory_descriptor
	/// sprite accessory ID
	var/id
	/// color channels, packed
	var/packed_coloration
	/// color channels, unpacked
	///
	/// * this follows the coloration format; this is not necessarily a list of colors
	/// * this is done on render
	var/list/unpacked_coloration
	/// emissive power; 0 to 255, with 0 being off
	var/emissive = 0

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

#warn set_coloration
#warn sanitize_and_validate

/**
 * Binding: tgui/bindings/datum/Game_SpriteAccessoryDescriptor
 */
/datum/sprite_accessory_descriptor/proc/tgui_data()
	#warn impl
