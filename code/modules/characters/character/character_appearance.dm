//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Stores the appearance state of a character.
 * * This is an overlay. **Almost all variables are nullable.**
 */
/datum/character_appearance
	/// short notes field for the player, for this appearance slot
	/// * Nullable
	var/label

	/// name to use
	/// * Nullable
	var/c_name
	/// The character's general flavor text
	/// * Nullable
	var/c_flavor_text_general
	/// The character's per-region flavor text
	/// * Nullable
	/// * Any key defined will override default; the key-value is not nullable on the value.
	/// * This does mean the player has to manually override any region they set on their base
	///   appearance. There's no better way to do this, unfortunately, without making the base
	///   case too complicated.
	#warn how should this be handled?
	var/list/c_flavor_text_regions

	/// headshot ref
	/// * Nullable
	var/c_profile_headshot_href
	/// fullbody ref
	/// * Nullable
	var/c_profile_fullbody_href

	/// base bodyset to use
	/// * Serialied as ID
	/// * Nullable
	//  TODO: impl, prototype
	var/datum/prototype/c_bodyset

	/// base skin color to use
	/// * Nullable
	/// * This is not skin tone. The user can select skin tone via UI; backend only stores RGBA.
	var/c_skin_color
	/// eye color to use
	/// * Nullable
	var/c_eye_color

	/// sprite accessories; slot key to /datum/sprite_accessory_descriptor
	/// * Nullable
	/// * Any key defined will override default; the key-value is not nullable on the value.
	var/list/c_sprite_accessory_by_key
	/// bodyparts; bodypart key to /datum/character_bodypart_appearance
	/// * Nullable
	/// * Any key defined will override default; the key-value is not nullable on the value.
	var/list/c_bodypart_appearance_by_key

	/// transform multiplier, x
	/// * Nullable
	var/c_size_x
	/// transform multiplier, y
	/// * Nullable
	var/c_size_y
	/// use fuzzy rendering `TRUE`/`FALSE` (turn off PIXEL_SCALE)
	/// * Nullable
	var/c_use_fuzzy_rendering

/datum/character_appearance/serialize()
	var/list/serialized_sprite_accessories
	var/list/serialized_bodypart_appearances
	#warn serialize
	return list(
		"label" = label,
		"c_name" = c_name,
		"c_flavor_general" = c_flavor_text_general,
		"c_flavor_regions" = c_flavor_regions,
		"c_profile_headshot" = c_profile_headshot_href,
		"c_profile_fullbody" = c_profile_fullbody_href,
		"c_bodyset" = c_bodyset?.id,
		"c_skin_color" = c_skin_color,
		"c_eye_color" = c_eye_color,
		"c_sprite_accessory" = serialized_sprite_accessories,
		"c_bodypart_appearance" = serialized_bodypart_appearances,
		"c_size_x" = c_size_x,
		"c_size_y" = c_size_y,
		"c_fuzzy" = c_use_fuzzy_rendering,
	)

/datum/character_appearance/deserialize(list/data)
	#warn impl


/datum/character_appearance/clone() as /datum/character_appearance
	var/datum/character_appearance/clone = new
	#warn impl

/**
 * Gets the appearance when `overlay_from` is overlaid ontop of us.
 */
/datum/character_appearance/proc/compute_result(datum/character_appearance/overlay_from) as /datum/character_appearance
	var/datum/character_appearance/overlay = new
	#warn impl
