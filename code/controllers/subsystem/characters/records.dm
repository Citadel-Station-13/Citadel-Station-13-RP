//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

#warn nuke this for character_backend

/**
 * Fetches a single character record
 */
/datum/controller/subsystem/characters/proc/fetch_character_record(id) as /datum/character_record
	var/datum/db_query/query = SSdbcore.NewQuery(
		"",
		list(),
	)

/**
 * Stores a character record
 */
/datum/controller/subsystem/characters/proc/store_character_record(datum/character_record/record)
	var/datum/db_query/query = SSdbcore.NewQuery(
		"",
		list(),
	)

/**
 * Gets records of a given type for a character.
 *
 * * character_id - the character ID to query
 * * record_type - the record type to return
 * * page - which page to retrieve; defaults to 1.
 * * page_limit - how many to return per page. This is an utter suggestion to this proc; the subsystem reserves the right to ignore your request.
 * * ptr_page_count - if provided, this pointer will be set to how many pages there are at the current limit
 * * ptr_page_entries - if provided, this pointer will be set to the limit being actually used
 *
 * @return list(record datum, record datum, ...)
 */
/datum/controller/subsystem/characters/proc/query_character_records(character_id, record_type, page, page_limit, ptr_page_count, ptr_page_entries) as /list
	var/datum/db_query/query = SSdbcore.NewQuery(
		"",
		list(),
	)

#warn impl all

/*

CREATE TABLE IF NOT EXISTS `%_PREFIX_%character_records` (
  `id` INT(24) NOT NULL AUTO INCREMENT,
  `character_id` INT(24) NOT NULL,
  `flags` INT(24) NOT NULL DEFAULT 0,
  `type` VARCHAR(64) NOT NULL,
  `data` MEDIUMTEXT NOT NULL DEFAULT '{}',
  `r_timestamp` DATETIME NULL,
  `r_location` VARCHAR(512) NULL,
  `r_label` VARCHAR(256) NULL,
  `r_content_type` VARCHAR(64) NULL,
  `r_content` TEXT NULL,
  CONSTRAINT `character_id` FOREIGN KEY (`character_id`)
  REFERENCES `%_PREFIX_%characters` (`id`)
  ON DELETE NULL
  ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

*/
