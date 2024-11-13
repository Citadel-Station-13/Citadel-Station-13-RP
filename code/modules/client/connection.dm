/client/proc/update_lookup_in_db()
	// ensure db is up
	if(!SSdbcore.Connect())
		return
	// unlike connection log, we don't care about guest keys here
	if(is_guest())
		return

	var/datum/db_query/lookup = SSdbcore.NewQuery(
		"SELECT id FROM [format_table_name("player_lookup")] WHERE ckey = :ckey",
		list("ckey" = ckey)
	)
	if(!lookup.Execute())
		qdel(lookup)
		return

	var/client_is_in_db = lookup.NextRow()
	if (!client_is_in_db)
		//New player!! Need to insert all the stuff
		var/datum/db_query/insert = SSdbcore.NewQuery(
			"INSERT INTO [format_table_name("player_lookup")] (id, ckey, firstseen, lastseen, ip, computerid, lastadminrank) VALUES (null, :ckey, Now(), Now(), :ip, :cid, :rank)",
			list(
				"ckey" = ckey,
				"ip" = address,
				"cid" = computer_id,
				"rank" = holder?.rank || "Player",
			)
		)
		insert.Execute()
		qdel(insert)
		qdel(lookup)
		return

	var/sql_id = text2num(lookup.item[1])
	qdel(lookup)
	var/datum/db_query/update = SSdbcore.NewQuery(
		"UPDATE [format_table_name("player_lookup")] SET lastseen = Now(), ip = :ip, computerid = :computerid, lastadminrank = :lastadminrank WHERE id = :id",
		list(
			"ip" = address,
			"computerid" = computer_id,
			"lastadminrank" = holder?.rank || "Player",
			"id" = sql_id,
		)
	)
	update.Execute()
	qdel(update)

/client/proc/log_connection_to_db()
	set waitfor = FALSE
	log_connection_to_db_impl()

/client/proc/log_connection_to_db_impl()
	PRIVATE_PROC(TRUE)

	if(!SSdbcore.Connect())
		return

	var/datum/db_query/query_log_connection = SSdbcore.NewQuery({"
		INSERT INTO `[format_table_name("connection_log")]` (`id`,`datetime`,`serverip`,`ckey`,`ip`,`computerid`)
		VALUES(null, Now(), :server, :ckey, INET_ATON(:ip), :computerid)
	"}, list(
		"serverip" = "[world.internet_address]:[world.port]" || "0",
		"ckey" = ckey,
		"ip" = address,
		"computerid" = computer_id))
	query_log_connection.Execute(FALSE)
	qdel(query_log_connection)

/client/proc/reject_on_initialization_block()
	if(!initialized)
		to_chat(src, SPAN_DANGER("Your client is still initializing. Wait a moment."))
		return FALSE
	return TRUE

/**
 * initializes us once everything resolves
 * this is necessary because things like IPIntel/panic bunker stuff
 * take time to resolve, and we don't want to block client/New().
 */
/client/proc/deferred_initialization_block()
	UNTIL(!panic_bunker_pending)
	UNTIL(!queued_security_kick)
	initialized = TRUE
