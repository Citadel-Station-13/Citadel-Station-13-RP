//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Stores a set of selected loadout items
 */
/datum/character_loadout
	///
	var/list/selected_ids = list()

/datum/character_loadout/serialize()
	return list(
		"selected" = selected_ids,
	)

/datum/character_loadout/deserialize(list/data)
	selected_ids = sanitize_islist(data, list())
	selected_ids.len = clamp(length(selected_ids), 0, CHARACTER_MAX_LOADOUT_ITEMS)


#warn impl

