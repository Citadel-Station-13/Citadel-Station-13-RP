//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/character_migration
	abstract_type = /datum/character_migration
	/// Key. Must be unique.
	var/key
	/// Priority. Lower applies first.
	var/priority = /datum/character_migration/citadel_rp_maximum_priority::priority

/**
 * @return TRUE success, FALSE on significant error
 */
/datum/character_migration/proc/perform(datum/character/character, list/out_warnings, list/out_errors)
	return TRUE

/**
 * Marks the max priority we have in codebase. Always
 * relativize your priorities.
 *
 * This way, if downstreams get made, they can increment from this.
 */
/datum/character_migration/citadel_rp_maximum_priority
	priority = 0
