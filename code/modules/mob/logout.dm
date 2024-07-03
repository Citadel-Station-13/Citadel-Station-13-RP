/**
 * **never directly set ckey on a mob**
 *
 * use this to transfer
 */
/mob/proc/transfer_client_to(mob/transfer_to)
	if(client)
		pre_logout()
	// if they have a client, kick them out
	if(transfer_to.client)
		transfer_to.pre_logout()
	// if we're logged in, client is transferred. if we're not, they'll log in at the other mob
	transfer_to.ckey = ckey

/**
 * sets our ckey
 */
/mob/proc/set_ckey(ckey)
	var/client/resolved = GLOB.directory[ckey]
	// see if this is an active client
	if(resolved)
		// if it's the same client, don't do anything
		if(client == resolved)
			return
		// tell their mob the client is about to leave
		resolved.mob?.pre_logout()
	// if we have a client it isn't the same as the resolved one so that is going away
	if(client)
		pre_logout()
	// transfer
	src.ckey = ckey

/**
 * called before logout, because by the time logout happens client is no longer in us
 *
 * * anything changing a mob's ckey must call this!
 * * much like Logout(), this is only called if we have a client.
 */
/mob/proc/pre_logout()
	client?.action_drawer.unregister_holder(actions_controlled)
	client?.action_drawer.unregister_holder(actions_innate)

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
