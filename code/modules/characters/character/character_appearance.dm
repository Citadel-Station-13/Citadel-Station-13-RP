//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Stores the appearance state of a character.
 */
/datum/character_appearance
	/// sprite accessories; slot key to /datum/sprite_accessory_descriptor
	///
	/// * overrides default if set on a slot, by key!
	/// * lazy list
	var/list/sprite_accessories

/datum/character_appearance/serialize()

/datum/character_appearance/deserialize(list/data)

#warn impl
