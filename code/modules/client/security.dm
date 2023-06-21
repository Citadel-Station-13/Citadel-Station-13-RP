/client/proc/security_note(message, tell_user)
	log_access("client security: noting [key_name(src)] | [message]")
	message_admins("client security: noting [key_name(src)] for [message]")
	add_system_note("client-security", message)
	if(tell_user)
		to_chat(src, SPAN_BOLDANNOUNCE("CLIENT-SECURITY: [message]<br>Please correct this."))

/client/proc/security_kick(message, tell_user, immediate)
	log_access("client security: kicking [key_name(src)] | [message]")
	message_admins("client security: kicking [key_name(src)] | [message]")
	if(tell_user)
		to_chat(src, SPAN_BOLDANNOUNCE("CLIENT-SECURITY: [message]<br>Please correct this.<br>You will now be disconnected."))
		disconnection_message(message)
		if(!immediate)
			queue_security_kick(5 SECONDS)
	queue_security_kick()

/**
 * time is in minutes
 * tell_user is implicit
 */
/client/proc/security_ban(message, time = -1)
	var/time_displayed = time == -1? "" : "for [DisplayTimeText(time MINUTES)]"
	log_access("client security: banning [key_name(src)] [time == -1? "" : "for [time_displayed]"] | [message]")
	message_admins("client security: banning [key_name(src)] [time == -1? "" : "for [time_displayed]"] | [message]")
	add_system_note("client-security", "banned for [time_displayed]: [message]")
	qdel(src)
	AddBan(ckey, computer_id, "client-security: [message]", minutes = time)

/**
 * queues a security kick
 * ensures the client's around for atleast delay or after current proc chain is over
 */
/client/proc/queue_security_kick(delay)
	var/left = isnull(queued_security_kick)? null : timeleft(queued_security_kick)
	if(isnull(left) || left < delay)
		deltimer(queued_security_kick)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(qdel), src), delay, TIMER_STOPPABLE)

/**
 * shows a disconnection message that's hopefully resistant to fast-disconnects
 */
/client/proc/disconnection_message(msg)
	var/content = {"
		<html>
		<head>
		<title>Disconnection</title>
		</head>
		<body>
		You have been intentionally disconnected by the server.<br><br>
		<center><b>[msg]></b></center>
		<br><hr>
		If you feel this is in error, contact an administrator out of game (e.g. on Discord).
		</body>
		</html>
	"}
	src << browse(content, "window=droppedFromServer;size=480x360;can_close=1")
	window_flash(src)
