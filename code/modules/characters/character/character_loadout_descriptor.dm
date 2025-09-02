//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Stores metadata of a single picked item.
 */
/datum/character_loadout_descriptor


#warn impl

/datum/character_loadout_descriptor/serialize()
	return list(
	)
	#warn impl

/datum/character_loadout_descriptor/deserialize(list/data)

/datum/character_loadout_descriptor/clone()
	var/datum/character_loadout_descriptor/clone = new

/**
 * Reference a loadout item.
 */
/datum/character_loadout_descriptor/loadout_item

/**
 * Reference a persistent inventory item.
 */
/datum/character_loadout_descriptor/inventory_reference

#warn impl all

