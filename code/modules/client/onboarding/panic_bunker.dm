/**
 * Panic bunker is special: We can defer the check until IPIntel comes back.
 */
/client/proc/panic_bunker()
	set waitfor = FALSE
	panic_bunker_pending = TRUE
	run_bunker_checks()

/client/proc/run_bunker_checks()
	// we need database up
	if(!SSdbcore.Connect())
		panic_bunker_pending = FALSE
		return
	var/allowed = blocking_bunker_checks()
	if(allowed)
		panic_bunker_pending = FALSE
		player.block_on_available()
		if(!(player.player_flags & PLAYER_FLAG_CONSIDERED_SEEN))
			player.player_flags |= PLAYER_FLAG_CONSIDERED_SEEN
			player.save()
	else
		disconnection_message("[CONFIG_GET(string/panic_bunker_message)]")
		security_kick("new account kicked by panic bunker")

/client/proc/blocking_bunker_checks()
	// is bunker on?
	if(!CONFIG_GET(flag/panic_bunker) && (!CONFIG_GET(flag/vpn_bunker) || !SSipintel.vpn_check(address)))
		return TRUE
	// allow bypass
	if(ckey in GLOB.bunker_passthrough)
		return TRUE

	// at time of writing this is in minutes
	var/needed_playtime = CONFIG_GET(number/panic_bunker_playtime)
	if(!needed_playtime)
		// using connection mode
		// block on player flags
		player.block_on_available()
		if(player.player_flags & PLAYER_FLAG_CONSIDERED_SEEN)
			return TRUE
		return FALSE
	else
		// using hour mode
		// block on player playtime
		persistent.block_on_playtime_loaded()
		// we use living playtime
		return persistent.playtime[PLAYER_PLAYTIME_LIVING] >= needed_playtime
