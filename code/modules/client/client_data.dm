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
	/// byond account join date
	var/account_join
	/// byond account age
	var/account_age

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

/datum/client_data/New(ckey)
	src.ckey = ckey
	src.playtime_last = REALTIMEOFDAY

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
	ASSERT(!playtime_mutex)
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
		"SELECT `roleid`, `minutes` FROM [format_table_name("playtime")] WHERE player = :player",
		list(
			"player" = player_id,
		)
	)
	query.Execute()
	while(query.NextRow())
		playtime[query.item[1]] = text2num(query.item[2])
	playtime_mutex = FALSE

/datum/client_data/proc/block_on_playtime_loaded(timeout = INFINITY)
	var/timed_out = world.time + timeout
	load_playtime()
	UNTIL(playtime_loaded || world.time > timed_out)

/datum/client_data/proc/block_on_account_age_loaded(timeout = INFINITY)
	var/timed_out = world.time + timeout
	UNTIL(!isnull(account_age) || world.time > timed_out)
	return account_age

/datum/client_data/proc/load_account_age()
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

