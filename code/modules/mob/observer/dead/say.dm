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


/mob/observer/dead/emote(var/act, var/type, var/message)
	//message = sanitize(message) - already sanitized in verb/me_verb()

	if(!message)
		return

	if(act != "me")
		return

	log_ghostemote(message, src)

	if(src.client)
		if(message)
			client.handle_spam_prevention(MUTE_DEADCHAT)
			if(src.client.prefs.muted & MUTE_DEADCHAT)
				to_chat(src, "<font color='red'>You cannot emote in deadchat (muted).</font>")
				return

	. = src.emote_dead(message)

/*
	for (var/mob/M in hearers(null, null))
		if (!M.stat)
			if(M.job == "Chaplain")
				if (prob (49))
					M.show_message("<span class='game'><i>You hear muffled speech... but nothing is there...</i></span>", 2)
					if(prob(20))
						playsound(src.loc, pick('sound/effects/ghost.ogg','sound/effects/ghost2.ogg'), 10, 1)
				else
					M.show_message("<span class='game'><i>You hear muffled speech... you can almost make out some words...</i></span>", 2)
//				M.show_message("<span class='game'><i>[stutter(message)]</i></span>", 2)
					if(prob(30))
						playsound(src.loc, pick('sound/effects/ghost.ogg','sound/effects/ghost2.ogg'), 10, 1)
			else
				if (prob(50))
					return
				else if (prob (95))
					M.show_message("<span class='game'><i>You hear muffled speech... but nothing is there...</i></span>", 2)
					if(prob(20))
						playsound(src.loc, pick('sound/effects/ghost.ogg','sound/effects/ghost2.ogg'), 10, 1)
				else
					M.show_message("<span class='game'><i>You hear muffled speech... you can almost make out some words...</i></span>", 2)
//				M.show_message("<span class='game'><i>[stutter(message)]</i></span>", 2)
					playsound(src.loc, pick('sound/effects/ghost.ogg','sound/effects/ghost2.ogg'), 10, 1)
*/
