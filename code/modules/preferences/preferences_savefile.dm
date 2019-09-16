/datum/preferences/proc/savefile_update(savefile/S)
	. = do_savefile_migration(S)
	if(. == SAVEFILE_MIGRATION_CATASTROPHIC_FAIL)		//Fatal. Delete data.
		var/delpath = "[PLAYER_SAVE_PATH(player_ckey)]/"
		if(fexists(delpath))
			fdel(delpath)
	else
		save_all()

/datum/preferences/proc/save_all()
	save_preferences()
	save_character()

/datum/preferences/proc/load_all()
	load_preferences()
	load_character()

/datum/preferences/proc/initialize_ckey(ckey, load = TRUE)
	if(player_ckey)
		if(player_ckey == ckey)
			return TRUE
		else
			CRASH("CATASTROPHIC SAVE DATA FAIL: [type]/initialize_ckey([ckey]) call resulted in ckey mismatch. PREFERENCE DATUMS CAN NOT BE REUSED!")
	player_ckey = ckey
	path = "[PLAYER_SAVE_PATH(ckey)]/[PLAYER_SAVE_FILENAME]"
	if(load)
		load_all()

/datum/preferences/proc/load_preferences()
	if(!path)
		to_chat(player_client, "<span class='danger'>Preferences load failed - Null path. If you are seeing this message, something has gone horribly wrong.</span>")
		return FALSE
	if(world.time < loadprefcooldown)			//Ensure server doesn't hang from too many reads/writes
		to_chat(player_client, "<span class='warning'>You're attempting to load your preferences a little too fast. Wait half a second, then try again.</span>")
		return FALSE
	loadprefcooldown = world.time + PREF_SAVELOAD_COOLDOWN
	if(!fexists(path))
		to_chat(player_client, "<span class='danger'>Preferences load failed - Unable to find file. If you are seeing this message, something has gone horribly wrong.</span>")
		return FALSE
	var/savefile/S = new(path)
	if(!S)
		to_chat(player_client, "<span class='danger'>Preferences load failed - Savefile initialization failure. If you are seeing this message, something has gone horribly wrong.</span>")
		return FALSE
	var/update_results = savefile_update(S)
	var/msg
	if(update_results != SAVEFILE_MIGRATION_NOT_NEEDED)
		to_chat(player_client, "<span class='boldnotice'>Your preferences/character save data is being automatically updated to the latest version.</span>")
		switch(update_results)
			if(SAVEFILE_MIGRATION_SUCCESSFUL)
				to_chat(player_client, "<span class='boldnotice'>Your preferences/character save data has been successfully updated to the latest version.</span>")
			if(SAVEFILE_MIGRATION_FAIL)
				to_chat(player_client, "<span class='danger'>Your preferences/character save data could not be successfully updated. You should re-check all preferences and character data for corruption.</span>")
			if(SAVEFILE_MIGRATION_CATASTROPHIC_FAIL)
				to_chat(player_client, "<span class='danger'><font size='5'>Catastrophic failure encountered during savefile loading. Your preferences and characters have been wiped.</span>")
				return FALSE
	player_setup.load_preferences(src, S)
	return TRUE

/datum/preferences/proc/save_preferences()
	if(!path)
		to_chat(player_client, "<span class='danger'>Preferences save failed - Null path. If you are seeing this message, something has gone horribly wrong.</span>")
		return FALSE
	if(world.time < saveprefcooldown)
		to_chat(player_client, "<span class='warning'>You're attempting to save your preferences a little too fast. Wait half a second, then try again.</span>")
		return FALSE
	saveprefcooldown = world.time + PREF_SAVELOAD_COOLDOWN
	var/savefile/S = new /savefile(path)
	if(!S)
		to_chat(player_client, "<span class='danger'>Preferences save failed - Savefile initialization failure. If you are seeing this message, something has gone horribly wrong.</span>")
		return FALSE
	player_setup.save_preferences(src, S)
	return TRUE
















/datum/preferences/proc/load_character(slot)
	if(!path)				return 0
	if(world.time < loadcharcooldown)
		if(istype(client))
			to_chat(client, "<span class='warning'>You're attempting to load your character a little too fast. Wait half a second, then try again.</span>")
		return 0
	loadcharcooldown = world.time + PREF_SAVELOAD_COOLDOWN
	if(!fexists(path))		return 0
	var/savefile/S = new /savefile(path)
	if(!S)					return 0
	S.cd = "/"
	if(!slot)	slot = default_slot
	if(slot != SAVE_RESET) // SAVE_RESET will reset the slot as though it does not exist, but keep the current slot for saving purposes.
		slot = sanitize_integer(slot, 1, config.character_slots, initial(default_slot))
		if(slot != default_slot)
			default_slot = slot
			S["default_slot"] << slot
	else
		S["default_slot"] << default_slot

	if(slot != SAVE_RESET)
		S.cd = "/character[slot]"
		player_setup.load_character(S)
	else
		player_setup.load_character(S)
		S.cd = "/character[default_slot]"

	player_setup.load_character(S)
	return 1

/datum/preferences/proc/save_character()
	if(!path)				return 0
	if(world.time < savecharcooldown)
		if(istype(client))
			to_chat(client, "<span class='warning'>You're attempting to save your character a little too fast. Wait half a second, then try again.</span>")
		return 0
	savecharcooldown = world.time + PREF_SAVELOAD_COOLDOWN
	var/savefile/S = new /savefile(path)
	if(!S)					return 0
	S.cd = "/character[default_slot]"

	player_setup.save_character(S)
	return 1

/datum/preferences/proc/sanitize_preferences()
	player_setup.sanitize_setup()
	return 1
