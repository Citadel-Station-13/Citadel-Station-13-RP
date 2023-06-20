/client/proc/update_lookup_in_db()
	if(!SSdbcore.Connect())
		return
	// unlike connection log, we don't care about guest keys here
	if(is_guest())
		return
	#warn impl

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
