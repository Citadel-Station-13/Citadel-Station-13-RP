/**
 * Run when a client is put in this mob or reconnets to byond and their client was on this mob
 *
 * Things it does:
 * * Adds player to GLOB.player_list
 * * sets lastKnownIP
 * * sets computer_id
 * * logs the login
 * * tells the world to update it's status (for player count)
 * * create mob huds for the mob if needed
 * * reset next_move to 1
 * * Set statobj to our mob
 * * NOT the parent call. The only unique thing it does is a very obtuse move op, see the comment lower down
 * * if the client exists set the perspective to the mob loc
 * * call on_log on the loc (sigh)
 * * reload the huds for the mob
 * * reload all full screen huds attached to this mob
 * * load any global alternate apperances
 * * sync the mind datum via sync_mind()
 * * call any client login callbacks that exist
 * * grant any actions the mob has to the client
 * * calls [auto_deadmin_on_login](mob.html#proc/auto_deadmin_on_login)
 * * send signal COMSIG_MOB_CLIENT_LOGIN
 */
/mob/Login()
	GLOB.player_list |= src
	update_Login_details()
	world.update_status()

	client.images = list() //remove the images such as AIs being unable to see runes
	client.screen = list() //remove hud items just in case
	if(hud_used)
		qdel(hud_used) //remove the hud objects
	hud_used = new /datum/hud(src)

	if(client.prefs && client.prefs.client_fps)
		client.fps = client.prefs.client_fps
	else
		client.fps = 0 // Results in using the server FPS

	next_move = 1
	disconnect_time = null // Clear the disconnect time

	/**
	 *! DO NOT CALL PARENT HERE
	 * BYOND's internal implementation of login does two things
	 * 1: Set statobj to the mob being logged into (We got this covered)
	 * 2: And I quote "If the mob has no location, place it near (1,1,1) if possible"
	 * See, near is doing an agressive amount of legwork there
	 * What it actually does is takes the area that (1,1,1) is in, and loops through all those turfs
	 * If you successfully move into one, it stops
	 * Because we want Move() to mean standard movements rather then just what byond treats it as (ALL moves)
	 * We don't allow moves from nullspace -> somewhere. This means the loop has to iterate all the turfs in (1,1,1)'s area
	 * For us, (1,1,1) is a space tile. This means roughly 200,000! calls to Move()
	 * You do not want this
	 */
	client.statobj = src

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

	// reset perspective to using
	reset_perspective(no_optimizations = TRUE)
	// load rendering onto client's screen
	reload_rendering()
	// reset statpanel of any verbs/whatnot
	client.statpanel_reload()

/// Handles setting lastKnownIP and computer_id for use by the ban systems as well as checking for multikeying
/mob/proc/update_Login_details()
	//Multikey checks and logging
	lastKnownIP	= client.address
	computer_id	= client.computer_id
	log_access_in(client)
	if(config_legacy.log_access)
		for(var/mob/M in GLOB.player_list)
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
						message_admins((SPAN_BOLDANNOUNCE("Notice: ") + SPAN_PURPLE("<A href='?src=\ref[usr];priv_msg=\ref[src]'>[key_name_admin(src)]</A> has the same [matches] as <A href='?src=\ref[usr];priv_msg=\ref[M]'>[key_name_admin(M)]</A>.")), 1)
						log_adminwarn("Notice: [key_name(src)] has the same [matches] as [key_name(M)].")
					else
						message_admins((SPAN_BOLDANNOUNCE("Notice: ") + SPAN_PURPLE("<A href='?src=\ref[usr];priv_msg=\ref[src]'>[key_name_admin(src)]</A> has the same [matches] as [key_name_admin(M)] (no longer logged in).")), 1)
						log_adminwarn("Notice: [key_name(src)] has the same [matches] as [key_name(M)] (no longer logged in).")
