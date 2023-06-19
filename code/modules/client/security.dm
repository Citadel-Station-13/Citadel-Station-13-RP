/client/proc/security_note(message)
	log_and_message_admins("client security: noting [key_name(src)] | [message]")
	add_system_note("client-security", [message])

/client/proc/security_kick(message)
	log_and_message_admins("client security: kicking [key_name(src)] | [message]")
	qdel(src)

/**
 * time is in minutes
 */
/client/proc/security_ban(message, time = -1)
	var/time_displayed = time == -1? "" : "for [DisplayTimeText(time MINUTES)]"
	log_and_message_admins("client security: banning [key_name(src)] [time == -1? "" : "for [time_displayed]"] | [message]")
	add_system_note("client-security", "banned for [time_displayed]: [message]")
	qdel(src)
	AddBan(ckey, computer_id, "client-security: [message]", minutes = time)
