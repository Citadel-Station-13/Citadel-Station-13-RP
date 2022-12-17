GLOBAL_DATUM_INIT(lobby_image, /obj/effect/lobby_image, new)

/obj/effect/lobby_image
	name = "Citadel Station 13"
	desc = "How are you reading this?"
	screen_loc = "CENTER-7,CENTER-7"

// todo: the image needs to be autocentered for widescreen/variable screens

/obj/effect/lobby_image/Initialize(mapload)
	SSticker.build_lobby_screen(src)
	return ..()

/mob/new_player/Login()
	update_Login_details()	//handles setting lastKnownIP and computer_id for use by the ban systems as well as checking for multikeying

	var/motd = config.motd
	if(motd)
		to_chat(src, "<blockquote class=\"motd\">[motd]</blockquote>", handle_whitespace=FALSE)
	if(client)
		to_chat(src, client.getAlertDesc())

	if(!mind)
		mind = new /datum/mind(key)
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
