//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Stores items stored by a character.
 *
 * * Persistent inventory can live here for things like event characters / offmap characters.
 * * Persistent loadout lives here.
 */
/datum/character_inventory


#warn impl

/datum/character_inventory/serialize()
	return list()

/datum/character_inventory/deserialize(list/data)
	return
