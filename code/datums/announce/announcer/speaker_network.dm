/datum/announcer/speaker_network
	name = "Intercomm Announcement"
	desc = "Intercom announcements that can be globally heard on the level."

/datum/announcer/speaker_network/SendText(source, name, message, list/affected)
	var/msg = "[SPAN_BOLDWARNING("The installation's speaker network blares out a message:")]<br>    \
	[SPAN_BOLDNOTICE(source)]: [SPAN_BOLD(name)] - [message]"
	for(var/mob/M in affected)
		to_chat(M, msg)
