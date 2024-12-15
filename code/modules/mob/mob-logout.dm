
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

	// admin logout shenanigans moved to client destroy!

	// unrender rendering systems
	dispose_rendering()
	// gc perspectives
	if(using_perspective?.reset_on_logout)
		reset_perspective()
	// update ssd overlay
	addtimer(CALLBACK(src, TYPE_PROC_REF(/mob, update_ssd_overlay)), 0)

	..()
	return 1
