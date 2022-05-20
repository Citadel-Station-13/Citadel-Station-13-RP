/datum/announcer/minor_announce
	name = "Minor Announcement"
	desc = "Legacy minor announce/request console style announcements."

/datum/announcer/minor_announce/SendText(source, name, message, list/affected)
	var/msg = "[SPAN_MINORANNOUNCE("[name]: [message]")]"
	for(var/mob/M in affected)
		to_chat(M, msg)
