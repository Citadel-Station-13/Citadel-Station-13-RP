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
 *
 * this can absolutely contain player specific data, especially if we don't
 * want to reload it every connect.
 */
/datum/client_data
	/// owner ckey
	var/ckey
	/// absolutely, positively annihilated
	var/ligma = FALSE

	//* externally managed data *//
	/// playtime - role string to number of minutes.
	var/list/playtime
	/// playtime was loaded
	var/playtime_loaded = FALSE
	/// playtime is loading or flushing
	var/playtime_mutex = FALSE
	/// playtime - queued for addition
	var/list/playtime_queued
	/// last REALTIMEOFDAY we did queuing
	var/playtime_last

/datum/client_data/New(ckey)
	src.ckey = ckey
	src.playtime_last = 0

	var/list/the_cheese_touch = CONFIG_GET(keyed_list/shadowban)
	var/client/C = GLOB.directory[src.ckey]
	var/why
	if("[C.ckey]" in the_cheese_touch)
		why = "ckey"
		src.ligma = TRUE
	else if("[C.computer_id]" in the_cheese_touch)
		why = "computerid"
		src.ligma = TRUE
	else if("[C.address]" in the_cheese_touch)
		why = "IP address"
		src.ligma = TRUE
	if(src.ligma)
		log_shadowban("[ckey] autobanned based on [why].")
		message_admins(SPAN_DANGER("Automatically shadowbanning [ckey] based on configuration (matched on [why]). Varedit client.persistent.ligma to change this."))

/datum/client_data/proc/load_playtime()
	set waitfor = FALSE
	if(playtime_loaded)
		return
	load_playtime_impl()

/datum/client_data/proc/load_playtime_impl()
	PRIVATE_PROC(TRUE)
	ASSERT(!playtime_mutex)
	if(playtime_mutex)
		return
	playtime_mutex = TRUE
	LAZYINITLIST(playtime)
	#warn impl
	playtime_mutex = FALSE

/datum/client_data/proc/block_on_playtime_loaded()
	load_playtime()
	UNTIL(playtime_loaded)

/datum/client_data/proc/flush_playtime(synchronous)
	block_on_playtime_loaded() // probably ensure we don't duplicate playtimes
	flush_playtime_impl
	#warn impl

#warn playtime handling
