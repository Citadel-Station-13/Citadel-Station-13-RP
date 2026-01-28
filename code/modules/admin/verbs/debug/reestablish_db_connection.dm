/client/proc/reestablish_db_connection()
	set category = "Special Verbs"
	set name = "Reestablish DB Connection"
	if (!CONFIG_GET(flag/sql_enabled))
		to_chat(usr, "<span class='adminnotice'>The Database is not enabled!</span>")
		return

	if (SSdbcore.IsConnected())
		if (!usr.client.holder.check_for_rights(R_DEBUG))
			tgui_alert(usr,"The database is already connected! (Only those with +debug can force a reconnection)", "The database is already connected!")
			return

		var/reconnect = tgui_alert(usr,"The database is already connected! If you *KNOW* that this is incorrect, you can force a reconnection", "The database is already connected!", list("Force Reconnect", "Cancel"))
		if (reconnect != "Force Reconnect")
			return

		SSdbcore.Disconnect()
		log_admin("[key_name(usr)] has forced the database to disconnect")
		message_admins("[key_name_admin(usr)] has <b>forced</b> the database to disconnect!")
		BLACKBOX_LOG_ADMIN_VERB("Force Reestablished Database Connection")

	log_admin("[key_name(usr)] is attempting to re-established the DB Connection")
	message_admins("[key_name_admin(usr)] is attempting to re-established the DB Connection")
	BLACKBOX_LOG_ADMIN_VERB("Reestablished Database Connection")

	SSdbcore.failed_connections = 0
	if(!SSdbcore.Connect())
		message_admins("Database connection failed: " + SSdbcore.ErrorMsg())
	else
		message_admins("Database connection re-established")
		message_admins("Reloading client database data...")
		for(var/client/C in GLOB.clients)
			C.player?.load()
		// assume roundid is all good
