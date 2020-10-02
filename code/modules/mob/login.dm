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
						message_admins("<font color='red'><B>Notice: </B></font><font color='blue'><A href='?src=\ref[usr];priv_msg=\ref[src]'>[key_name_admin(src)]</A> has the same [matches] as <A href='?src=\ref[usr];priv_msg=\ref[M]'>[key_name_admin(M)]</A>.</font>", 1)
						log_adminwarn("Notice: [key_name(src)] has the same [matches] as [key_name(M)].")
					else
						message_admins("<font color='red'><B>Notice: </B></font><font color='blue'><A href='?src=\ref[usr];priv_msg=\ref[src]'>[key_name_admin(src)]</A> has the same [matches] as [key_name_admin(M)] (no longer logged in). </font>", 1)
						log_adminwarn("Notice: [key_name(src)] has the same [matches] as [key_name(M)] (no longer logged in).")

/mob/Login()

	player_list |= src
	update_Login_details()
	world.update_status()

	client.images = null				// Remove the images such as AIs being unable to see runes
	client.screen = list()				// Remove hud items just in case
	if(hud_used)	qdel(hud_used)		// Remove the hud objects
	hud_used = new /datum/hud(src)

	if(client.prefs && client.prefs.client_fps)
		client.fps = client.prefs.client_fps
	else
		client.fps = 0	// Results in using the server FPS

	next_move = 1
	disconnect_time = null	// Clear the disconnect time
	sight |= SEE_SELF
	..()

	if(viewing_alternate_appearances && viewing_alternate_appearances.len)
		for(var/datum/alternate_appearance/AA in viewing_alternate_appearances)
			AA.display_to(list(src))

	var/obj/screen/plane_master/augmented/aug = plane_holder.plane_masters[VIS_AUGMENTED]
	aug.apply()

	if(loc && !isturf(loc))
		client.eye = loc
		client.perspective = EYE_PERSPECTIVE
	else
		client.eye = src
		client.perspective = MOB_PERSPECTIVE
	reload_fullscreen() // Reload any fullscreen overlays this mob has.
	add_click_catcher()
	update_client_color()

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

	if(!client.tooltips)
		client.tooltips = new(client)

	var/turf/T = get_turf(src)
	if(isturf(T))
		update_client_z(T.z)

	SEND_SIGNAL(src, COMSIG_MOB_CLIENT_LOGIN, client)
