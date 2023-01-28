/**
 * ? Character Persistence System
 */
/datum/controller/subsystem/persistence
	/// loaded characters - "[id]" = /datum/character instance
	var/list/loaded = list()

#warn impl

/datum/controller/subsystem/persistence/proc/save(datum/character/char)
	// pause admin proccall guard
	var/__oldusr = usr
	usr = null
	// section below can never be allowed to runtime

	#warn impl

	// resume admin proccall guard
	usr = __oldusr

/datum/controller/subsystem/persistence/proc/load_all(playerid)
	// pause admin proccall guard
	var/__oldusr = usr
	usr = null
	// section below can never be allowed to runtime

	#warn impl

	// resume admin proccall guard
	usr = __oldusr

/datum/controller/subsystem/persistence/proc/load_id(char_id)
	// pause admin proccall guard
	var/__oldusr = usr
	usr = null
	// section below can never be allowed to runtime

	#warn impl

	// resume admin proccall guard
	usr = __oldusr

/datum/controller/subsystem/persistence/proc/load_dynamic(playerid, cname, ctype)
	// pause admin proccall guard
	var/__oldusr = usr
	usr = null
	// section below can never be allowed to runtime

	#warn impl

	// resume admin proccall guard
	usr = __oldusr

/datum/controller/subsystem/persistence/proc/fetch_id(char_id)
	// pause admin proccall guard
	var/__oldusr = usr
	usr = null
	// section below can never be allowed to runtime

	#warn impl

	// resume admin proccall guard
	usr = __oldusr

/datum/controller/subsystem/persistence/proc/fetch_dynamic(playerid, cname, ctype)
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
 */
/datum/character/proc/load_from_query(datum/db_query/query)
	if(IsAdminAdvancedProcCall())
		CRASH("no proccalls allowed")
	#warn impl

/**
 * creates a database query to write our data
 */
/datum/character/proc/create_save_query()
	if(IsAdminAdvancedProcCall())
		CRASH("no proccalls allowed")
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

/datum/character/human
	character_type = "human"
