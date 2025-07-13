//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/character_migration
	abstract_type = /datum/character_migration
	/// Key. Must be unique.
	var/key

/**
 * @return TRUE success, FALSE on significant error
 */
/datum/character_migration/proc/perform(datum/character/character, list/out_warnings, list/out_errors)
	return TRUE
