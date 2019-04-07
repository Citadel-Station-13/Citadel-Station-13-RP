<<<<<<< HEAD
/mob/Logout()
	GLOB.nanomanager.user_logout(src) // this is used to clean up (remove) this user's Nano UIs
	player_list -= src
	disconnect_time = world.realtime
	log_access_out(src)
	if(admin_datums[src.ckey])
		if (ticker && ticker.current_state == GAME_STATE_PLAYING) //Only report this stuff if we are currently playing.
			var/admins_number = admins.len

			message_admins("Admin logout: [key_name(src)]")
			if(admins_number == 0) //Apparently the admin logging out is no longer an admin at this point, so we have to check this towards 0 and not towards 1. Awell.
				send2adminirc("[key_name(src)] logged out - no more admins online.")
	..()

=======
/mob/Logout()
	GLOB.nanomanager.user_logout(src) // this is used to clean up (remove) this user's Nano UIs
	player_list -= src
	disconnect_time = world.realtime	//VOREStation Addition: logging when we disappear.
	update_client_z(null)
	log_access_out(src)
	if(admin_datums[src.ckey])
		if (ticker && ticker.current_state == GAME_STATE_PLAYING) //Only report this stuff if we are currently playing.
			var/admins_number = admins.len

			message_admins("Admin logout: [key_name(src)]")
			if(admins_number == 0) //Apparently the admin logging out is no longer an admin at this point, so we have to check this towards 0 and not towards 1. Awell.
				send2adminirc("[key_name(src)] logged out - no more admins online.")
	..()

>>>>>>> 4adac33... Merge pull request #4935 from Heroman3003/how-long-have-i-been-asleep-doc
	return 1