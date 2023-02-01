/**
 * ? Character Persistence System
 */
/datum/controller/subsystem/persistence
	/// loaded characters - "[id]" = /datum/character instance
	var/list/character_cache = list()

/**
 * flushes a character to db
 * a new character is valid to save this way.
 *
 * @params
 * * char - character datum
 */
/datum/controller/subsystem/persistence/proc/save_character(datum/character/char)
	// pause admin proccall guard
	var/__oldusr = usr
	usr = null
	// section below can never be allowed to runtime

	#warn impl

	// resume admin proccall guard
	usr = __oldusr

/**
 * fetches a character datum
 * you should not hold references to it yourself
 * refetch when you need it!
 *
 * @params
 * * id - character id
 */
/datum/controller/subsystem/persistence/proc/fetch_character(id)
	// pause admin proccall guard
	var/__oldusr = usr
	usr = null
	// section below can never be allowed to runtime

	#warn impl

	// resume admin proccall guard
	usr = __oldusr

/**
 * returns a list of character ids for a player
 *
 * @params
 * * playerid - player id
 * * fetch - fetch the character datums in the process
 */
/datum/controller/subsystem/persistence/proc/query_characters(playerid, fetch = FALSE)
	// pause admin proccall guard
	var/__oldusr = usr
	usr = null
	// section below can never be allowed to runtime

	#warn impl

	// resume admin proccall guard
	usr = __oldusr

/**
 * mark a character as having played
 *
 * @params
 * * id - character id
 */
/datum/controller/subsystem/persistence/proc/character_played(id)
	// pause admin proccall guard
	var/__oldusr = usr
	usr = null
	// section below can never be allowed to runtime

	#warn impl

	// resume admin proccall guard
	usr = __oldusr


/**
 * --- /datum/character - Character Table ---
CREATE TABLE IF NOT EXISTS `%_PREFIX_%character` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `created` DATETIME NOT NULL DEFAULT Now(),
  `last_played` DATETIME NULL,
  `last_persisted` DATETIME NULL,
  `playerid` INT(11) NOT NULL,
  `canonical_name` INT(11) NOT NULL,
  `persist_data` MEDIUMTEXT NULL,
  PRIMARY KEY(`id`),
  CONSTRAINT `character_has_player` FOREIGN KEY (`playerid`)
  REFERENCES `%_PREFIX_%player` (`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  UNIQUE (`playerid`, `canonical_name`)
) ENIGNE=InnoDB DEFAULT CHARSET=utf8m4 COLLATE=utf8mb4_general_ci;

 */

/**
 * hardcoded switch: what character type string corrosponds to what /datum/character
 */
/datum/controller/subsystem/persistence/proc/character_type_to_datum_path(what)
	switch(what)
		if(OBJECT_PERSISTENCE_CHARACTER_TYPE_HUMAN)
			return /datum/character/human

/datum/character
	abstract_type = /datum/character
	/// our character id, if we're already in the sql database
	var/character_id
	/// character type - should never change
	var/character_type
	/// our player id
	var/player_id
	/// our ckey(name) - used to avoid spaces/whatever getting in the way
	var/canonical_name
	/// created - SQL datetime - not modifiable
	var/created_at
	/// last played SQL datetime - not modifiable directly, use proc
	var/played_at

/**
 * reads from a given mob
 *
 * this *is* allowed to touch the mob's /datum/mind!
 */
/datum/character/proc/read_from(mob/M)
	return

/**
 * writes to a given mob
 *
 * this *is* allowed to touch the mob's /datum/mind!
 */
/datum/character/proc/write_to(mob/M)
	return

/**
 * reads data out of a database query
 *
 * @params
 * * id - character id - number
 * * playerid - player id - number
 * * canonical_name - ckey(name) of character - string
 * * created_at - created SQL timestamp - string
 * * played_at - last played SQL timestamp - string
 * * persist_data - persistence JSON - string
 */
/datum/character/proc/load_from_query(id, playerid, canonical_name, created_at, played_at, persist_data)
	if(IsAdminAdvancedProcCall())
		CRASH("no proccalls allowed")
	src.character_id = id
	src.player_id = playerid
	src.canonical_name = canonical_name
	src.created_at = created_at
	src.played_at = played_at
	read_persist_data(safe_json_decode(persist_data) || list())

/**
 * creates a database query to write our data
 */
/datum/character/proc/create_save_query()
	if(IsAdminAdvancedProcCall())
		CRASH("no proccalls allowed")
	var/datum/db_query/query = SSdbcore.NewQuery(

	)
	#warn impl

/**
 * gets data to persist
 *
 * @return list of k-v entries
 */
/datum/character/proc/make_persist_data()
	return list()

/**
 * loads fields from persisting data
 */
/datum/character/proc/read_persist_data(list/data)
	return

/**
 * changes the name of this character
 * only ever change names this way, this'll handle the necessary updates, within the subsystem and on /datum/player's.
 */
/datum/character/proc/immediate_rename(new_name)
	#warn impl

/datum/character/human
	character_type = OBJECT_PERSISTENCE_CHARACTER_TYPE_HUMAN
