//handles setting lastKnownIP and computer_id for use by the ban systems as well as checking for multikeying
/mob/proc/update_Login_details()
	//Multikey checks and logging
	lastKnownIP	= client.address
	computer_id	= client.computer_id
	log_access_in(client)
	if(config_legacy.log_access)
		for(var/mob/M in player_list)
			if(M == src)	continue
			if( M.key && (M.key != key) )
				var/matches
				if( (M.lastKnownIP == client.address) )
					matches += "IP ([client.address])"
				if( (client.connection != "web") && (M.computer_id == client.computer_id) )
					if(matches)	matches += " and "
					matches += "ID ([client.computer_id])"
					spawn() alert("You have logged in already with another key this round, please log out of this one NOW or risk being banned!")
				if(matches)
					if(M.client)
						message_admins("<font color='red'><B>Notice: </B></font><font color=#4F49AF><A href='?src=\ref[usr];priv_msg=\ref[src]'>[key_name_admin(src)]</A> has the same [matches] as <A href='?src=\ref[usr];priv_msg=\ref[M]'>[key_name_admin(M)]</A>.</font>", 1)
						log_adminwarn("Notice: [key_name(src)] has the same [matches] as [key_name(M)].")
					else
						message_admins("<font color='red'><B>Notice: </B></font><font color=#4F49AF><A href='?src=\ref[usr];priv_msg=\ref[src]'>[key_name_admin(src)]</A> has the same [matches] as [key_name_admin(M)] (no longer logged in). </font>", 1)
						log_adminwarn("Notice: [key_name(src)] has the same [matches] as [key_name(M)] (no longer logged in).")

/mob/Login()
	SHOULD_CALL_PARENT(TRUE)

	player_list |= src
	update_Login_details()
	world.update_status()

	client.images = list()				//remove the images such as AIs being unable to see runes
	client.screen = list()				//remove hud items just in case
	if(hud_used)
		qdel(hud_used)		//remove the hud objects
	hud_used = new /datum/hud(src)

	if(client.prefs && client.prefs.client_fps)
		client.fps = client.prefs.client_fps
	else
		client.fps = 0 // Results in using the server FPS

	next_move = 1
	disconnect_time = null				//VOREStation Addition: clear the disconnect time

	..()

	reload_fullscreen() // Reload any fullscreen overlays this mob has.
	update_client_color()

	//Reload alternate appearances
	for(var/v in GLOB.active_alternate_appearances)
		if(!v)
			continue
		var/datum/atom_hud/alternate_appearance/AA = v
		AA.onNewMob(src)

	if(!plane_holder) //Lazy
		plane_holder = new(src) //Not a location, it takes it and saves it.
	if(!vis_enabled)
		vis_enabled = list()
	client.screen += plane_holder.plane_masters
	recalculate_vis()

	// AO support
	var/ao_enabled = client.is_preference_enabled(/datum/client_preference/ambient_occlusion)
	plane_holder.set_ao(VIS_OBJS, ao_enabled)
	plane_holder.set_ao(VIS_MOBS, ao_enabled)

	// Status indicators
	var/status_enabled = client.is_preference_enabled(/datum/client_preference/status_indicators)
	plane_holder.set_vis(VIS_STATUS, status_enabled)


	if(!client.tooltips)
		client.tooltips = new(client)

	var/turf/T = get_turf(src)
	if(isturf(T))
		update_client_z(T.z)

	SEND_SIGNAL(src, COMSIG_MOB_CLIENT_LOGIN, client)

	reload_huds()

	// set client perspective to what we're using
	client.set_perspective(get_using_perspective())
	// load rendering onto client's screen
	reload_rendering()

