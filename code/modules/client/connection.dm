/client/proc/update_lookup_in_db()
	// ensure db is up
	if(!SSdbcore.Connect())
		return
	// unlike connection log, we don't care about guest keys here
	if(is_guest())
		return

	var/datum/db_query/lookup = SSdbcore.NewQuery(
		"SELECT id FROM [format_table_name("player_lookup")] WHERE ckey = :ckey",
		list(
			"ckey" = ckey,
		)
	)
	lookup.Execute()
	var/sql_id
	if(lookup.NextRow())
		sql_id = text2num(lookup.item[1])
	qdel(lookup)

	if(sql_id)
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
	else
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

/client/proc/log_connection_to_db()
	if(!SSdbcore.Connect())
		return

	SSdbcore.RunQuery(
		"INSERT INTO [format_table_name("connection_log")] (id, datetime, serverip, ckey, ip, computerid) VALUES (null, Now(), :server, :ckey, :ip, :cid)",
		list(
			"server" = "[world.internet_address]:[world.port]",
			"ckey" = ckey,
			"ip" = address || "0.0.0.0",
			"cid" = computer_id,
		)
	)

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
