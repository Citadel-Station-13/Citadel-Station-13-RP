/client/proc/reestablish_db_connection()
	set category = "Special Verbs"
	set name = "Attempts to (re)establish the DB Connection"

	if(!check_rights(R_NONE))
		return

	if (!CONFIG_GET(flag/sql_enabled))
		to_chat(usr, SPAN_ADMINNOTICE("The Database is not enabled!"), confidential = TRUE)
		return

	if (SSdbcore.IsConnected())
		if (!holder.check_for_rights(R_DEBUG))
			tgui_alert(usr,"The database is already connected! (Only those with +debug can force a reconnection)", "The database is already connected!")
			return

		var/reconnect = tgui_alert(usr,"The database is already connected! If you *KNOW* that this is incorrect, you can force a reconnection", "The database is already connected!", list("Force Reconnect", "Cancel"))
		if (reconnect != "Force Reconnect")
			return

		SSdbcore.Disconnect()
		log_admin("[key_name(usr)] has forced the database to disconnect")
		message_admins("[key_name_admin(usr)] has <b>forced</b> the database to disconnect!")
		// BLACKBOX_LOG_ADMIN_VERB("Force Reestablished Database Connection")

	log_admin("[key_name(usr)] is attempting to re-establish the DB Connection")
	message_admins("[key_name_admin(usr)] is attempting to re-establish the DB Connection")
	// BLACKBOX_LOG_ADMIN_VERB("Reestablished Database Connection")

	SSdbcore.failed_connections = 0
	if(!SSdbcore.Connect())
		message_admins("Database connection failed: " + SSdbcore.ErrorMsg())
	else
		message_admins("Database connection re-established")

		message_admins("Reloading client database data...")
		for(var/client/C in GLOB.clients)
			C.player?.load()
		message_admins("Asserting round ID set...")
		if(!isnum(text2num(GLOB.round_id)))
			SSdbcore.SetRoundID()
			message_admins("Round ID was not set and has now been re-set. Things might be weird this round.")
