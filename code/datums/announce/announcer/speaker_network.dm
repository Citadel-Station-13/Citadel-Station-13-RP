/**
 * all mobs on z can hear
 * ignores source
 */
/datum/announcer/speaker_network
	name = "Intercomm Announcement"
	desc = "Intercom announcements that can be globally heard on the level."

/datum/announcer/speaker_network/SendText(source, name, message, list/affected)
	var/msg = "[SPAN_BOLDWARNING("[location.render_proper_possessive_name()] speaker network blares out a message:")]<br>\
	<blockquote>[SPAN_BOLD(name)] - [message]</blockquote>"
	for(var/mob/M in affected)
		to_chat(M, msg)
