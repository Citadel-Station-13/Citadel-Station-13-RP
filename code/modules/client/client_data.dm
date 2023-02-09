GLOBAL_LIST_EMPTY(client_data)

/proc/resolve_client_data(ckey)
	ckey = ckey(ckey)	// just in case
	if(!islist(GLOB.client_data))
		// we CANNOT RUNTIME
		GLOB.client_data = list()
	if(!istype(GLOB.client_data[ckey], /datum/client_data))
		GLOB.client_data[ckey] = new /datum/client_data(ckey)
	return GLOB.client_data[ckey]

/**
 * client data datums, to hold
 * round-based data that we don't want wiped
 * by a disconnect.
 */
/datum/client_data
	/// owner ckey
	var/ckey

/datum/client_data/New(ckey)
	src.ckey = ckey
