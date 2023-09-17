/**
 * holds db-related data
 * loaded every connect
 */
/datum/player_data
	//! intrinsics
	/// our ckey
	var/ckey
	/// our key
	var/key
	/// available: null if don't know yet, FALSE if no dbcon, TRUE if loaded
	var/available
	/// loading?
	var/loading = FALSE
	/// saving?
	var/saving = FALSE
	// todo: this lock system sucks ass
	// todo: it should realistically be able to queue if something modifies us a lot

	//! loaded data
	/// player id
	var/player_id
	/// player flags
	var/player_flags = NONE
	/// player age
	var/player_age
	/// join date
	var/player_first_seen

/datum/player_data/New(key)
	src.ckey = ckey(key)
	if(!src.ckey)
		return
	src.key = key
	load()

/**
 * async
 */
/datum/player_data/proc/load()
	if(!SSdbcore.Connect())
		if(isnull(available))
			available = FALSE
		return FALSE
	INVOKE_ASYNC(src, PROC_REF(load_blocking))
	return TRUE

/datum/player_data/proc/load_blocking()
	// allow admin proccalls - there's no args here.
	var/was_proccall = !!IsAdminAdvancedProcCall()
	var/old_usr = usr
	usr = null
	_load_lock(was_proccall)
	usr = old_usr

/datum/player_data/proc/_load_lock(was_proccall)
	if(IsAdminAdvancedProcCall())
		return
	if(loading)
		if(!was_proccall)
			CRASH("loading is still locked; why are we loading this fast?")
		return
	loading = TRUE
	_load()
	loading = FALSE

/datum/player_data/proc/_load()
	if(IsAdminAdvancedProcCall())
		return
	if(IsGuestKey(key))
		return
	var/datum/db_query/lookup
	lookup = SSdbcore.ExecuteQuery(
		"SELECT id, playerid, firstseen FROM [format_table_name("player_lookup")] WHERE ckey = :ckey",
		list(
			"ckey" = ckey
		)
	)
	if(!lookup.NextRow())
		CRASH("failed to load lookup data")
	var/lookup_id = lookup.item[1]
	var/lookup_pid = lookup.item[2]
	var/lookup_firstseen = lookup.item[3]
	if(lookup_pid)
		if(istext(lookup_id))
			lookup_id = text2num(lookup_id)
		if(istext(lookup_pid))
			lookup_pid = text2num(lookup_pid)
		qdel(lookup)
		lookup = SSdbcore.ExecuteQuery(
			"SELECT id, flags, datediff(Now(), firstseen), firstseen FROM [format_table_name("player")] WHERE id = :id",
			list(
				"id" = lookup_pid
			)
		)
		if(lookup.NextRow())
			// found!
			var/lookup_flags = lookup.item[2]
			var/lookup_age = lookup.item[3]
			if(istext(lookup_flags))
				lookup_flags = text2num(lookup_flags)
			if(istext(lookup_age))
				lookup_age = text2num(lookup_age)
			player_id = lookup_pid
			player_flags = lookup_flags
			player_first_seen = lookup.item[4]
			player_age = lookup_age
			qdel(lookup)
			available = TRUE
		else
			CRASH("failed to lookup player row on id [lookup_pid] even though id was present in player_lookup.")
	else
		qdel(lookup)
		register_new_player(lookup_firstseen, lookup_id)

/datum/player_data/proc/register_new_player(migrate_firstseen, lookup_id)
	if(IsAdminAdvancedProcCall())
		return
	// new person!
	player_age = 0
	player_flags = NONE
	var/datum/db_query/insert
	if(migrate_firstseen)
		insert = SSdbcore.ExecuteQuery(
			"INSERT INTO [format_table_name("player")] (flags, firstseen, lastseen) VALUES (:flags, :fs, Now())",
			list(
				"flags" = player_flags,
				"fs" = migrate_firstseen
			)
		)
		player_first_seen = migrate_firstseen
	else
		insert = SSdbcore.ExecuteQuery(
			"INSERT INTO [format_table_name("player")] (flags, firstseen, lastseen) VALUES (:flags, Now(), Now())",
			list(
				"flags" = player_flags,
			)
		)
		player_first_seen = time_stamp()
	var/insert_id = insert.last_insert_id
	if(istext(insert_id))
		insert_id = text2num(insert_id)
	if(!isnum(insert_id))
		CRASH("invalid insert id??")
	player_id = insert_id
	qdel(insert)
	// now update lookup
	insert = SSdbcore.ExecuteQuery(
		"UPDATE [format_table_name("player_lookup")] SET playerid = :pid WHERE id = :id",
		list(
			"id" = lookup_id,
			"pid" = insert_id
		)
	)
	qdel(insert)
	available = TRUE
	// todo: lookup DATEDIFF so player age is set for the first connect after migrating a ckey.

/**
 * async
 */
/datum/player_data/proc/save()
	set waitfor = FALSE
	// why are we in here if we're write locked?
	if(saving)
		CRASH("write locked")
	// don't fuck with things if we're read-locked
	UNTIL(!loading)
	// check again
	if(saving)
		CRASH("write locked")
	// allow admin proccalls - there's no args here.
	var/old_usr = usr
	usr = null
	// don't lock; if something is spamming our flags they probably shouldn't be
	saving = TRUE
	_save()
	saving = FALSE
	usr = old_usr

/datum/player_data/proc/_save()
	qdel(SSdbcore.ExecuteQuery(
		"UPDATE [format_table_name("player")] SET flags = :flags WHERE id = :id",
		list(
			"flags" = player_flags,
			"id" = player_id
		)
	))

/**
 * async
 */
/datum/player_data/proc/log_connect()
	set waitfor = FALSE
	update_last_seen()

/datum/player_data/proc/update_last_seen()
	// don't interrupt
	if(!block_on_available())
		return FALSE
	qdel(SSdbcore.ExecuteQuery(
		"UPDATE [format_table_name("player")] SET lastseen = Now() WHERE id = :id",
		list(
			"id" = player_id
		)
	))
	return TRUE

/**
 * sync
 */
/datum/player_data/proc/player_age()
	UNTIL(!loading)
	return player_age

/**
 * block until we know if we're available
 * then return if we are
 *
 * WARNING: without database, or if this is for a guest key, we will never be available.
 */
/datum/player_data/proc/block_on_available(timeout = INFINITY)
	var/timed_out = world.time + timeout
	UNTIL(!isnull(available) || world.time > timed_out)
	return available

/**
 * returns if we're available
 * if we don't know yet, return false
 */
/datum/player_data/proc/immediately_available()
	return !!available
