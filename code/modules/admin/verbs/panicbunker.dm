GLOBAL_LIST_EMPTY(bunker_passthrough)

/client/proc/panicbunker()
	set category = "Server"
	set name = "Toggle Panic Bunker"

	if(!check_rights(R_ADMIN))
		return

	if(!CONFIG_GET(flag/sql_enabled))
		to_chat(usr, "<span class='adminnotice'>The Database is not enabled!</span>")
		return

	config_legacy.panic_bunker = (!config_legacy.panic_bunker)

	log_and_message_admins("[key_name(usr)] has toggled the Panic Bunker, it is now [(config_legacy.panic_bunker?"on":"off")]")
	if (config_legacy.panic_bunker && (!SSdbcore.Connect()))
		message_admins("The Database is not connected! Panic bunker will not work until the connection is reestablished.")
	feedback_add_details("admin_verb","PANIC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/addbunkerbypass(ckeytobypass as text)
	set category = "Server"
	set name = "Add PB Bypass"
	set desc = "Allows a given ckey to connect despite the panic bunker for a given round."
	if(!CONFIG_GET(flag/sql_enabled))
		to_chat(usr, "<span class='adminnotice'>The Database is not enabled!</span>")
		return

	GLOB.bunker_passthrough |= ckey(ckeytobypass)
	GLOB.bunker_passthrough[ckey(ckeytobypass)] = world.realtime
	SSpersistence.SavePanicBunker() //we can do this every time, it's okay
	log_admin("[key_name(usr)] has added [ckeytobypass] to the current round's bunker bypass list.")
	message_admins("[key_name_admin(usr)] has added [ckeytobypass] to the current round's bunker bypass list.")
	send2irc("Panic Bunker", "[key_name(usr)] has added [ckeytobypass] to the current round's bunker bypass list.")

/client/proc/revokebunkerbypass(ckeytobypass as text)
	set category = "Server"
	set name = "Revoke PB Bypass"
	set desc = "Revoke's a ckey's permission to bypass the panic bunker for a given round."
	if(!CONFIG_GET(flag/sql_enabled))
		to_chat(usr, "<span class='adminnotice'>The Database is not enabled!</span>")
		return

	GLOB.bunker_passthrough -= ckey(ckeytobypass)
	SSpersistence.SavePanicBunker()
	log_admin("[key_name(usr)] has removed [ckeytobypass] from the current round's bunker bypass list.")
	message_admins("[key_name_admin(usr)] has removed [ckeytobypass] from the current round's bunker bypass list.")
	send2irc("Panic Bunker", "[key_name(usr)] has removed [ckeytobypass] from the current round's bunker bypass list.")

/client/proc/paranoia_logging()
	set category = "Server"
	set name = "New Player Warnings"

	if(!check_rights(R_ADMIN))
		return

	config_legacy.paranoia_logging = (!config_legacy.paranoia_logging)

	log_and_message_admins("[key_name(usr)] has toggled Paranoia Logging, it is now [(config_legacy.paranoia_logging?"on":"off")]")
	if (config_legacy.paranoia_logging && (!SSdbcore.Connect()))
		message_admins("The Database is not connected! Paranoia logging will not be able to give 'player age' (time since first connection) warnings, only Byond account warnings.")
	feedback_add_details("admin_verb","PARLOG") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/ip_reputation()
	set category = "Server"
	set name = "Toggle IP Rep Checks"

	if(!check_rights(R_ADMIN))
		return

	config_legacy.ip_reputation = (!config_legacy.ip_reputation)

	log_and_message_admins("[key_name(usr)] has toggled IP reputation checks, it is now [(config_legacy.ip_reputation?"on":"off")].")
	if (config_legacy.ip_reputation && (!SSdbcore.Connect()))
		message_admins("The database is not connected! IP reputation logging will not be able to allow existing players to bypass the reputation checks (if that is enabled).")
	feedback_add_details("admin_verb","IPREP") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
