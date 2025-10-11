/mob/observer/dead/say(var/message, var/datum/prototype/language/speaking = null, var/verb="says", var/alt_name="", var/whispering = 0)
	message = sanitize(message)

	if (!message)
		return

	log_ghostsay(message, src)

	if (src.client)
		if(message)
			client.handle_spam_prevention(MUTE_DEADCHAT)
			if(src.client.prefs.muted & MUTE_DEADCHAT)
				to_chat(src, "<font color='red'>You cannot talk in deadchat (muted).</font>")
				return

	. = src.say_dead(message)
