/mob/Logout()
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_MOB_CLIENT_LOGOUT, client)
	SSnanoui.user_logout(src) // this is used to clean up (remove) this user's Nano UIs
	SStgui.on_logout(src) // Cleanup any TGUIs the user has open
	GLOB.player_list -= src
	disconnect_time = world.realtime // Logging when we disappear.
	update_client_z(null)
	log_access_out(src)
	if(admin_datums[src.ckey])
		if (SSticker && SSticker.current_state == GAME_STATE_PLAYING) //Only report this stuff if we are currently playing.
			var/admins_number = GLOB.admins.len

			message_admins("Admin logout: [key_name(src)]")
			if(admins_number == 0) //Apparently the admin logging out is no longer an admin at this point, so we have to check this towards 0 and not towards 1. Awell.
				send2irc("LOGOUT", "[key_name(src)] logged out - no more admins online.")

	// unrender rendering systems
	dispose_rendering()
	// gc perspectives
	if(using_perspective?.reset_on_logout)
		reset_perspective()

	..()
	return 1
