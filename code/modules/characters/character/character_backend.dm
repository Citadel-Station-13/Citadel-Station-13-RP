//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * A storage backend for character system.
 *
 * Requirements:
 * * A single character ID should only exist once in the backend. There should never
 *   be more than one character datum of the same ID existing
 *   where both are spawned by the same backend.
 */
/datum/character_backend

/**
 * Saves a character to the store, updating the store with its data.
 */
/datum/character_backend/proc/save_character(datum/character/character)
	CRASH("Not implemented.")

/**
 * Loads a character from the store, overwriting all data.
 */
/datum/character_backend/proc/load_character(datum/character/character)
	CRASH("Not implemented.")

/**
 * Fetches a character by ID
 */
/datum/character_backend/proc/fetch_character(id) as /datum/character
	CRASH("Not implemented.")

/**
 * @params
 * * ckey - ckey to fetch for
 * * filter_string - if provided, character filter string must contain this substring.
 *
 * @return list of /datum/character's
 */
/datum/character_backend/proc/fetch_characters_by_ckey(ckey, filter_string) as /list
	CRASH("Not implemented.")

/**
 * The returned character may have some fields filled out automatically.
 *
 * @params
 * * ckey - ckey to create the character for
 *
 * @return /datum/character created, or null on fail
 */
/datum/character_backend/proc/create_character_for_ckey(ckey) as /datum/character
	CRASH("Not implemented.")

/datum/character_backend/proc/emit_character_setup_log(datum/character/character, action, list/params, client/user)
	CRASH("Not implemented.")
