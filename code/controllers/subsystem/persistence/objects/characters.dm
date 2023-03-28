/**
 * ? Character Data System
 *
 * This is both used for persistence, as well as potentially admin backend in the future.
 * Please exercise caution when editing the subsystem and the root of /datum/character_data.
 * Use and abuse subtypes to do what you need to do for persistence features.
 */
/datum/controller/subsystem/persistence
	/// loaded characters - "[id]" = /datum/character_data instance
	var/list/character_cache = list()

/**
 * flushes a character to db
 * a new character is valid to save this way.
 *
 * @params
 * * char - character datum
 * * persisting - update persistence info if mob is given
 */
/datum/controller/subsystem/persistence/proc/save_character(datum/character_data/char, mob/persisting)
	// pause admin proccall guard
	var/__oldusr = usr
	usr = null
	// section below can never be allowed to runtime

	// if we have id, we're updating
	if(char.character_id)
		// last played is not updated by this proc
		// everything else can though!
		var/datum/db_query/update_query = SSdbcore.NewQuery(
			"UPDATE [format_table_name("character")] \
			SET[persisting? " last_persisted = NOW()," : ""] canonical_name = :name, persist_data = :data, \
			playerid = :pid \
			WHERE id = :id",
			list(
				"id" = char.character_id,
				"pid" = char.player_id,
				"name" = ckey(char.canonical_name),
				"data" = persisting? json_encode(char.make_persist_data(persisting)) : json_encode(list()),
			)
		)
		update_query.Execute(async = FALSE)
		qdel(update_query)
	else
		var/datum/db_query/insert_query = SSdbcore.NewQuery(
			"INSERT INTO [format_table_name("character")] \
			(`created`, `last_played`, `last_persisted`, `playerid`, `canonical_name`, \
			`persist_data`, `character_type`) \
			VALUES (NOW(), NULL, [persisting? "NOW" : "NULL"], :pid, :name, :data, :type)",
			list(
				"pid" = char.player_id,
				"name" = ckey(char.canonical_name),
				"data" = persisting? json_encode(char.make_persist_data(persisting)) : json_encode(list()),
				"type" = char.character_type,
			),
		)
		insert_query.Execute(async = FALSE)
		char.character_id = isnum(insert_query.last_insert_id)? insert_query.last_insert_id : text2num(insert_query.last_insert_id)
		qdel(insert_query)
	// fetch our ID immediately to repopulate
	fetch_character(char.character_id, TRUE)

	// resume admin proccall guard
	usr = __oldusr

/**
 * fetches a character datum
 * you should not hold references to it yourself
 * refetch when you need it!
 *
 * @params
 * * id - character id
 * * force - reload from sql if it's in cache
 */
/datum/controller/subsystem/persistence/proc/fetch_character(id, force = FALSE)
	ASSERT(isnum(id))

	// pause admin proccall guard
	var/__oldusr = usr
	usr = null
	// section below can never be allowed to runtime

	var/datum/character_data/loaded = character_cache[num2text(id, 16)]
	if(!force && loaded)
		return loaded

	var/datum/db_query/load_query = SSdbcore.NewQuery(
		"SELECT `created`, `last_played`, `last_persisted`, `playerid`, `canonical_name`, `persist_data`, `character_type` FROM \
		[format_table_name("character")] WHERE id = :id",
		list(
			"id" = id,
		)
	)
	load_query.Execute(async = FALSE)

	if(!load_query.NextRow())
		character_cache -= num2text(id, 16)
		qdel(load_query)
		return null

	var/char_type = load_query.item[7]
	var/datum_type = character_type_to_datum_path(char_type)

	if(!datum_type)
		. = null
		CRASH("unexpected char_type: [char_type]")

	// one's there, make one if it isn't already there
	if(!istype(loaded, datum_type))
		character_cache[num2text(id, 16)] = (loaded = new datum_type)

	loaded.character_id = id
	loaded.player_id = text2num(load_query.item[4])
	loaded.created_at = load_query.item[1]
	loaded.played_at = load_query.item[2]
	loaded.persisted_at = load_query.item[3]
	loaded.canonical_name = load_query.item[5]
	loaded.read_persist_data(load_query.item[6]? safe_json_decode(load_query.item[6], list()) : list())

	. = loaded

	qdel(load_query)

	// resume admin proccall guard
	usr = __oldusr

/**
 * returns a list of character ids for a player
 *
 * @params
 * * playerid - player id
 * * fetch - fetch the character datums in the process
 * * force - forcefully fetch the character even if it's cached
 */
/datum/controller/subsystem/persistence/proc/query_characters(playerid, fetch = FALSE, force = FALSE)
	ASSERT(isnum(playerid))

	// pause admin proccall guard
	var/__oldusr = usr
	usr = null
	// section below can never be allowed to runtime

	. = list()
	var/datum/db_query/iteration_query = SSdbcore.ExecuteQuery(
		"SELECT id FROM [format_table_name("character")] WHERE playerid = :id",
		list(
			"id" = playerid
		)
	)
	while(iteration_query.NextRow())
		. += text2num(iteration_query.item[1])
	if(!length(.))
		return

	// resume admin proccall guard
	usr = __oldusr

	// fetch if needed
	if(fetch)
		for(var/id in .)
			fetch_character(id, force)

/**
 * mark a character as having played
 *
 * @params
 * * id - character id
 */
/datum/controller/subsystem/persistence/proc/character_played(id)
	ASSERT(isnum(id))

	// pause admin proccall guard
	var/__oldusr = usr
	usr = null
	// section below can never be allowed to runtime

	var/datum/db_query/mark_query = SSdbcore.ExecuteQuery(
		"UPDATE [format_table_name("character")] SET last_played = NOW() WHERE id = :id",
		list(
			"id" = id
		)
	)
	. = !!mark_query.affected

	// resume admin proccall guard
	usr = __oldusr

/**
 * hardcoded switch: what character type string corrosponds to what /datum/character_data
 */
/datum/controller/subsystem/persistence/proc/character_type_to_datum_path(what)
	switch(what)
		if(OBJECT_PERSISTENCE_CHARACTER_TYPE_HUMAN)
			return /datum/character_data/human

/datum/character_data
	abstract_type = /datum/character_data
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
	/// last persisted SQL datetime - not modifiable directly
	var/persisted_at

/**
 * reads from a given mob
 *
 * this *is* allowed to touch the mob's /datum/mind!
 */
/datum/character_data/proc/read_from(mob/M)
	return

/**
 * writes to a given mob
 *
 * this *is* allowed to touch the mob's /datum/mind!
 */
/datum/character_data/proc/write_to(mob/M)
	return

/**
 * gets data to persist
 *
 * @return list of k-v entries
 */
/datum/character_data/proc/make_persist_data(mob/M)
	return list()

/**
 * loads fields from persisting data
 */
/datum/character_data/proc/read_persist_data(list/data)
	return

/**
 * changes the name of this character
 * only ever change names this way, this'll handle the necessary updates, within the subsystem and on /datum/player's.
 */
/datum/character_data/proc/immediate_rename(new_name)
	canonical_name = ckey(new_name)
	SSpersistence.save_character(src)

/datum/character_data/human
	character_type = OBJECT_PERSISTENCE_CHARACTER_TYPE_HUMAN
