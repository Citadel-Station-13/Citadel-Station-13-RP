//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Stores the physiological state of a character,
 * including species, organs, etc.
 */
/datum/character_physiology
	/// blood color; rgb color
	///
	/// * can be overridden by species
	var/blood_color

#warn impl

/datum/character_physiology/proc/serialize()
	return list()
	#warn serialize

/datum/character_physiology/proc/deserialize(list/data)
	#warn impl

/datum/character_physiology/clone() as /datum/character_physiology
	var/datum/character_physiology/clone = new
	#warn impl

/**
 * Gets the physiology when `overlay_from` is overlaid ontop of us.
 */
/datum/character_physiology/proc/compute_result(datum/character_physiology/overlay_from) as /datum/character_physiology
	var/datum/character_physiology/overlay = new
	#warn impl
