//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Fetches a single character record
 */
/datum/controller/subsystem/characters/proc/fetch_character_record(id) as /datum/character_record

/**
 * Stores a character record
 */
/datum/controller/subsystem/characters/proc/store_character_record(datum/character_record/record)

/**
 * Gets records of a given type for a character.
 *
 * * character_id - the character ID to query
 * * record_type - the record type to return
 * * page - which page to retrieve; defaults to 1.
 * * limit - how many to return per page. This is an utter suggestion to this proc; the subsystem reserves the right to ignore your request.
 * * page_total_pointer - if provided, this pointer will be set to how many pages there are at the current limit
 * * limit_count_pointer - if provided, this pointer will be set to the limit being used.
 *
 * @return list(record datum, record datum, ...)
 */
/datum/controller/subsystem/characters/proc/query_character_records(character_id, record_type, page) as /list

#warn impl all
