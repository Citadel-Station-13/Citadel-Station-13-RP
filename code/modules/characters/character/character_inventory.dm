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

// this file is obviously unfinished because we haven't finished persistence API yet.
// this basically leaves references to entity IDs serialized by the persistence serializer.
// this also necessary metadata so that we don't have to load the entity just to view it in the UI.
// (realistically for the latter part we can probably do a SQL join)
