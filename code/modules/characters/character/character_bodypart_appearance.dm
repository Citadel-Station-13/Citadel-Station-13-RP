//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Stores overrides for a bodypart's appearance.
 */
/datum/character_bodypart_appearance
	/// bodyset overridej
	/// * Serialied as ID
	/// * Nullable
	//  TODO: impl, prototype
	var/datum/prototype/c_bodyset
	/// body markings. ordered.
	/// * Nullable
	/// * If set, fully overrides markings on that part.
	var/list/datum/bodyset_marking_descriptor/c_body_markings
	/// override skin color
	/// * Nullable
	var/c_skin_color

/datum/character_bodypart_appearance/serialize()
	var/list/serialized_markings
	#warn serialize
	return list(
		"c_bodyset" = c_bodyset?.id,
		"c_bodymarks" = serialized_markings,
		"c_skin_color" = c_skin_color,
	)

/datum/character_bodypart_appearance/deserialize(list/data)
	#warn impl

/**
 * Gets the appearance when `overlay_from` is overlaid ontop of us.
 */
/datum/character_bodypart_appearance/proc/compute_result(datum/character_bodypart_appearance/overlay_from) as /datum/character_bodypart_appearance
	var/datum/character_bodypart_appearance/overlay = new
	#warn impl
