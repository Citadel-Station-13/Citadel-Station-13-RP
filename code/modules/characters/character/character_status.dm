//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Status datastructure for characters.
 *
 * Stores things like;
 *
 * * If you're allowed to switch factions
 * * Certain persistence flags
 */
/datum/character_status
	/// Arbitrary persistence k-v store.
	var/list/misc_kv_store = list()
	/// Lock faction, species, background from being changed.
	var/story_lock = FALSE

/datum/character_status/serialize()
	. = list()

/datum/character_status/deserialize(list/data)

#warn impl
