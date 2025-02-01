//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Instance descriptors of sprite accessory markings.
 */
/datum/sprite_accessory_marking_descriptor
	/// multiply-blend color to apply
	var/color = "#ffffff"
	/// emissive strength from 0 to 1
	var/emissive = 0

/datum/sprite_accessory_marking_descriptor/serialize()
	return list(
		"color" = color,
		"emissive" = emissive,
	)

/datum/sprite_accessory_marking_descriptor/deserialize(list/data)
	color = data["color"]
	emissive = data["emissive"]

/datum/sprite_accessory_marking_descriptor/clone()
	var/datum/sprite_accessory_marking_descriptor/creating = new
	creating.color = color
	creating.emissive = emissive
