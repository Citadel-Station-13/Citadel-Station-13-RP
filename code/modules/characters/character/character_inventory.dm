//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Stores items stored by a character.
 * * Persistent inventory can live here for things like event characters / offmap characters.
 * * This does not store loadout data. Loadout may reference things in this.
 */
/datum/character_inventory

/datum/character_inventory/serialize()
	return list()

/datum/character_inventory/deserialize(list/data)
	return
