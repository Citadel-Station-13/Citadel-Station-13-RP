
/**
 * called before logout, because by the time logout happens client is no longer in us
 *
 * * anything changing a mob's ckey must call this!
 * * much like Logout(), this is only called if we have a client.
 */
/mob/proc/pre_logout()
	if(!client)
		return
	if(client.action_drawer)
		if(actions_controlled)
			client.action_drawer.unregister_holder(actions_controlled)
		if(actions_innate)
			client.action_drawer.unregister_holder(actions_innate)
		if(inventory)
			client.action_drawer.unregister_holder(inventory.actions)

/**
 * Linter check, do not call.
 */
/proc/lint__check_mob_logout_doesnt_sleep()
	SHOULD_NOT_SLEEP(TRUE)
	var/mob/M
	M.Logout()

/mob/Logout()
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_MOB_CLIENT_LOGOUT, client)
	SSnanoui.user_logout(src) // this is used to clean up (remove) this user's Nano UIs
	SStgui.on_logout(src) // Cleanup any TGUIs the user has open
	GLOB.player_list -= src
	disconnect_time = world.realtime // Logging when we disappear.
	active_storage?.hide(src)
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
	// update ssd overlay
	addtimer(CALLBACK(src, TYPE_PROC_REF(/mob, update_ssd_overlay)), 0)

	..()
	return 1
