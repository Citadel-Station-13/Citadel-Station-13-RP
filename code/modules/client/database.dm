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

	//! loaded data
	/// player id
	var/player_id
	/// player flags
	var/player_flags = NONE

/datum/client_dbdata/New(ckey)
	src.ckey = ckey
	if(!src.ckey)
		return
	Load()

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

/datum/client_dbdata/proc/SaveFlags()
	set waitfor = FALSE
	// don't fuck with things if we're read-locked
	UNTIL(!loading)
	// allow admin proccalls - there's no args here.
	var/old_usr = usr
	usr = null
	// don't lock; if something is spamming our flags they probably shouldn't be
	_SaveFlags()
	usr = old_usr

/datum/client_dbdata/proc/_SaveFlags()


