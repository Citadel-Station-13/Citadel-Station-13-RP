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
	/// absolutely, positively annihilated
	var/ligma = FALSE

/datum/client_data/New(ckey)
	src.ckey = ckey

	var/list/the_cheese_touch = CONFIG_GET(keyed_list/shadowban)
	var/client/C = GLOB.directory[src.ckey]
	var/why
	if(C.ckey in the_cheese_touch)
		why = "ckey"
		src.ligma = TRUE
	else if(C.computer_id in the_cheese_touch)
		why = "computerid"
		src.ligma = TRUE
	else if(C.address in the_cheese_touch)
		why = "IP address"
		src.ligma = TRUE
	if(src.ligma)
		log_shadowban("[ckey] autobanned based on [why].")
		message_admins(SPAN_DANGER("Automatically shadowbanning [ckey] based on configuration (matched on [why]). Varedit client.persistent.ligma to change this."))
