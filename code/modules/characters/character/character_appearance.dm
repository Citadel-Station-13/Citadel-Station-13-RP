//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Stores the appearance state of a character.
 *
 * * Defers to /datum/character_physiology.
 * * This means that physiology is always allowed to arbitarily
 *   override appearance whenever it wants.
 */
/datum/character_appearance
	/// base bodyset to use
	var/bodyset_id
	/// base skin color to use
	var/skin_color
	/// eye color to use
	var/eye_color
	/// sprite accessories; slot key to /datum/sprite_accessory_descriptor
	///
	/// * lazy list
	var/list/sprite_accessories
	/// bodyparts; bodypart key to /datum/character_bodypart_appearance
	///
	/// * lazy list
	var/list/bodypart_appearances
	/// transform multiplier, x
	var/size_x = 1
	/// transform multiplier, y
	var/size_y = 1

/datum/character_appearance/serialize()

/datum/character_appearance/deserialize(list/data)

#warn impl
