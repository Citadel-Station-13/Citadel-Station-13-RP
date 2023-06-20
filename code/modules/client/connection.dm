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
