/datum/announcer/major_announce
	name = "Major Announcement"
	desc = "Legacy command report style announcements."

/datum/announcer/major_announce/SendText(source, name, message, list/affected)
	var/list/assembled = list()
	assembled += "<b><h1 class='alert'>[source]</h1></b><br>"
	assembled += "<h2 class='alert'>[name]</h2><br>"
	assembled += "<blockquote>[message]</blockquote>"
	var/msg = assembled.Join("")
	for(var/mob/M in affected)
		to_chat(M, msg)
