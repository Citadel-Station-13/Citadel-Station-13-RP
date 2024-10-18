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
	/// short notes field for the player, for this appearance slot
	var/label

	/// name to use
	///
	/// * overrides default if set on a slot
	var/name

	/// The character's general flavor text
	///
	/// * if set on a slot, the default flavortext will be suppressed
	var/flavor_text_general
	/// The character's per-zone flavor text
	///
	/// * if set on a slot, the default flavortext will be suppressed
	/// * Lazy list
	var/flavor_text_zones

	/// headshot ref
	///
	/// * overrides default if set on a slot
	// todo: implement
	var/ref_image_headshot
	/// fullbody ref
	///
	/// * overrides default if set on a slot
	// todo: implement
	var/ref_image_fullbody

	/// base bodyset to use
	///
	/// * overrides default if set on a slot
	/// * null = use species
	var/bodyset_id

	/// base skin color to use
	///
	/// * overrides default if set on a slot
	var/skin_color
	/// eye color to use
	///
	/// * overrides default if set on a slot
	var/eye_color

	/// sprite accessories; slot key to /datum/sprite_accessory_descriptor
	///
	/// * overrides default if set on a slot, by key!
	/// * lazy list
	var/list/sprite_accessories

	/// bodyparts; bodypart key to /datum/character_bodypart_appearance
	///
	/// * overrides default if set on a slot, by key!
	/// * lazy list
	var/list/bodypart_appearances

	/// transform multiplier, x
	///
	/// * overrides default if set on a slot, by key!
	var/size_x = 1
	/// transform multiplier, y
	///
	/// * overrides default if set on a slot, by key!
	var/size_y = 1
	/// use fuzzy rendering? default to FALSE
	///
	/// * if FALSE, the person uses PIXEL_SCALE
	/// * if TRUE, the person does not use PIXEL_SCALE
	var/use_fuzzy_rendering = FALSE

/datum/character_appearance/serialize()

/datum/character_appearance/deserialize(list/data)

#warn impl
