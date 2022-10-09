/**
 * holds db-related data
 * loaded every connect
 */
/datum/client_dbdata
	//! intrinsics
	/// our ckey
	var/ckey
	/// loaded
	var/loaded = FALSE
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

/datum/client_dbdata/New(ckey)
	src.ckey = ckey
	if(!src.ckey)
		return
	Load()

/**
 * async
 */
/datum/client_dbdata/proc/Load()
	set waitfor = FALSE
	// allow admin proccalls - there's no args here.
	var/was_proccall = !!IsAdminAdvancedProcCall()
	var/old_usr = usr
	usr = null
	_Load_Lock(TRUE)
	usr = old_usr

/datum/client_dbdata/proc/_Load_Lock(was_proccall)
	if(IsAdminAdvancedProcCall())
		return
	if(loading)
		if(!was_proccall)
			CRASH("loading is still locked; why are we loading this fast?")
		return
	loading = TRUE
	_Load()
	loading = FALSE

/datum/client_dbdata/proc/_Load()
	var/datum/db_query/lookup = SSdbcore.ExecuteQuery(
		"SELECT id, flags"
	)
	#warn finish, including player_age and auto inserts

/**
 * async
 */
/datum/client_dbdata/proc/Save()
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
	_Save()
	saving = FALSE
	usr = old_usr

/datum/client_dbdata/proc/_Save()
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
/datum/client_dbdata/proc/LogConnect()
	set waitfor = FALSE
	UpdateLastSeen()

/datum/client_dbdata/proc/UpdateLastSeen()
	// don't interrupt
	UNTIL(!loading)
	qde(SSdbcore.ExecuteQuery(
		"UPDATE [format_table_name("player")] SET lastseen = Now() WHERE id = :id",
		list(
			"id" = player_id
		)
	))

/**
 * sync
 */
/datum/client_dbdata/proc/player_age()
	UNTIL(!loading)
	return player_age
