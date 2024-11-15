//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Stores overrides for a bodypart.
 *
 * * Specifically appearance; does not store physiology!
 */
/datum/character_bodypart_appearance
	/// bodyset override
	var/bodyset_id
	/// body markings
	var/list/datum/bodyset_marking_descriptor/body_markings
	/// override skin color
	var/skin_color

/datum/character_bodypart_appearance/serialize()
	return list()

/datum/character_bodypart_appearance/deserialize(list/data)
	return

#warn impl
