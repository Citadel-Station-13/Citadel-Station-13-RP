/client/verb/motd()
	set name = "MOTD"
	set category = VERB_CATEGORY_OOC
	set desc ="Check the Message of the Day"

	var/motd = config.motd
	if(motd)
		to_chat(src, "<blockquote class=\"motd\">[motd]</blockquote>", handle_whitespace=FALSE)
	else
		to_chat(src, "<span class='notice'>The Message of the Day has not been set.</span>")
	to_chat(src, getAlertDesc())
