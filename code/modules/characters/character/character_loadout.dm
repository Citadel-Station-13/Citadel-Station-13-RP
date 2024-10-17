//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Stores a set of selected loadout items
 */
/datum/character_loadout
	/// underwear; slot id to /datum/underwear_descriptor
	var/list/underwear_slots
	#warn underwaer by slot

/datum/character_loadout/serialize()
	return list()

/datum/character_loadout/deserialize(list/data)
	return


#warn impl

