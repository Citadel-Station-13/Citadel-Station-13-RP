//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Stores a set of selected loadout items
 */
/datum/character_loadout
	/// ordered list of descriptors
	var/list/datum/character_loadout_descriptor/descriptors = list()

/datum/character_loadout/serialize()
	return list(
	)
	#warn impl

/datum/character_loadout/deserialize(list/data)
	#warn impl

/datum/character_loadout/clone()
	var/datum/character_loadout/clone = new
	#warn impl
	return clone
