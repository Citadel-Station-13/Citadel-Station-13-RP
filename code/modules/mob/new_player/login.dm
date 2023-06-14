/mob/new_player/Login()
	update_Login_details()	//handles setting lastKnownIP and computer_id for use by the ban systems as well as checking for multikeying

	var/motd = config.motd
	if(motd)
		to_chat(src, "<blockquote class=\"motd\">[motd]</blockquote>", handle_whitespace=FALSE)
	if(client)
		to_chat(src, client.getAlertDesc())

	if(!mind)
		mind = new /datum/mind(ckey)
		mind.active = 1
		mind.current = src

	loc = null
	GLOB.player_list |= src

	new_player_panel()
	spawn(40)
		if(client)
			handle_privacy_poll()
			client.playtitlemusic()
	return ..()

/mob/new_player/login_cutscene()
	client.start_cutscene(SSlobby.titlescreen)
