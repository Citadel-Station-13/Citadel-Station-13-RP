//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

GLOBAL_LIST_EMPTY(client_data)

/proc/resolve_client_data(ckey, key)
	ckey = ckey(ckey)	// just in case
	if(!islist(GLOB.client_data))
		// we CANNOT RUNTIME
		GLOB.client_data = list()
	if(!istype(GLOB.client_data[ckey], /datum/client_data))
		GLOB.client_data[ckey] = new /datum/client_data(ckey, key)
	return GLOB.client_data[ckey]

/**
 * client data datums, to hold
 * round-based data that we don't want wiped
 * by a disconnect.
 */
/datum/client_data
	/// owner ckey
	var/ckey
	/// owner key
	var/key
	/// absolutely, positively annihilated
	var/ligma = FALSE
	/// byond account join date; null = not loaded
	var/account_join
	/// byond account age; null = not loaded
	var/account_age
	/// is guest
	var/is_guest

	//* externally managed data *//
	/// playtime - role string to number of minutes.
	var/list/playtime
	/// playtime was loaded
	var/playtime_loaded = FALSE
	/// playtime is loading or flushing
	var/playtime_mutex = FALSE
	/// playtime - queued for addition
	var/list/playtime_queued = list()
	/// last REALTIMEOFDAY we did queuing
	var/playtime_last

/datum/client_data/New(ckey, key)
	src.ckey = ckey
	src.key = key
	src.playtime_last = REALTIMEOFDAY

	is_guest = IsGuestKey(key)

	spawn(0)
		load_account_age()

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

/datum/client_data/proc/block_on_account_age_loaded(timeout = 10 SECONDS)
	var/timed_out = world.time + timeout
	UNTIL(!isnull(account_age) || world.time > timed_out)
	return account_age

/datum/client_data/proc/load_account_age()
	if(is_guest)
		account_age = 0
		return
	var/list/http = world.Export("http://byond.com/members/[ckey]?format=text")
	if(!http)
		log_world("Failed to connect to byond age check for [ckey]")
		return
	var/F = file2text(http["CONTENT"])
	. = null
	if(F)
		// year-month-day
		var/regex/R = regex("joined = \"(\\d{4}-\\d{2}-\\d{2})\"")
		if(R.Find(F))
			var/str = R.group[1]
			account_join = str
			if(!SSdbcore.Connect())
				account_age = null
				return
			var/datum/db_query/query = SSdbcore.RunQuery(
				"SELECT DATEDIFF(Now(), :date)",
				list(
					"date" = str,
				)
			)
			if(query.NextRow())
				. = text2num(query.item[1])
		else
			CRASH("Age check regex failed for [src.ckey]")
	account_age = .

//* External - Playtime *//

/datum/client_data/proc/load_playtime()
	set waitfor = FALSE
	if(playtime_loaded)
		return
	// no args, injection proof; release proccall guard
	var/old_usr = usr
	usr = null
	load_playtime_impl()
	usr = old_usr

/datum/client_data/proc/load_playtime_impl()
	PRIVATE_PROC(TRUE)
	if(playtime_mutex)
		return
	playtime_mutex = TRUE
	playtime = list()
	var/player_id
	var/client/client = GLOB.directory[ckey]
	if(isnull(client))
		playtime_mutex = FALSE
		return
	client.player.block_on_available()
	// clients can be deleted at any time.
	player_id = client?.player?.player_id
	if(isnull(player_id))
		playtime_mutex = FALSE
		return
	var/datum/db_query/query = SSdbcore.NewQuery(
		"SELECT `roleid`, `minutes` FROM [DB_PREFIX_TABLE_NAME("playtime")] WHERE player = :player",
		list(
			"player" = player_id,
		)
	)
	query.Execute()
	while(query.NextRow())
		playtime[query.item[1]] = text2num(query.item[2])
	playtime_loaded = TRUE
	playtime_mutex = FALSE

/datum/client_data/proc/block_on_playtime_loaded(timeout = 10 SECONDS)
	var/timed_out = world.time + timeout
	load_playtime()
	UNTIL(playtime_loaded || world.time > timed_out)
	return playtime_loaded
