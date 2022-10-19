/datum/preferences/proc/load_path(ckey,filename="preferences.sav")
	if(!ckey)	return
	path = "data/player_saves/[copytext(ckey,1,2)]/[ckey]/[filename]"
	savefile_version = SAVEFILE_VERSION_MAX

/datum/preferences/proc/load_preferences()
	if(!path)
		return 0
	if(world.time < loadprefcooldown) //This is done before checking if the file exists to ensure that the server can't hang on read attempts
		if(istype(client))
			to_chat(client, "<span class='warning'>You're attempting to load your preferences a little too fast. Wait half a second, then try again.</span>")
		return 0
	loadprefcooldown = world.time + PREF_SAVELOAD_COOLDOWN
	if(!fexists(path))
		return 0
	var/savefile/S = new /savefile(path)
	if(!S)
		return 0
	S.cd = "/"

	S["version"] >> savefile_version
	//Conversion
	if(!savefile_version || !isnum(savefile_version) || savefile_version < SAVEFILE_VERSION_MIN || savefile_version > SAVEFILE_VERSION_MAX)
		if(!savefile_update())  //handles updates
			savefile_version = SAVEFILE_VERSION_MAX
			save_preferences()
			save_character()
			return 0

	read_global_data()
	#warn preload global data somehow so migrations can affect it? or just |= a list?
	player_setup.load_preferences(S)
	return 1

/datum/preferences/proc/save_preferences()
	if(!path)				return 0
	if(world.time < saveprefcooldown)
		if(istype(client))
			to_chat(client, "<span class='warning'>You're attempting to save your preferences a little too fast. Wait half a second, then try again.</span>")
		return 0
	saveprefcooldown = world.time + PREF_SAVELOAD_COOLDOWN
	var/savefile/S = new /savefile(path)
	if(!S)					return 0
	S.cd = "/"

	S["version"] << savefile_version
	write_global_data()
	player_setup.save_preferences(S)
	return 1

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
		slot = sanitize_integer(slot, 1, config_legacy.character_slots, initial(default_slot))
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

	#warn handle migrations somehow?? for new system
	read_character_data()
	player_setup.load_character(S)
	clear_character_previews() // Recalculate them on next show
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

	write_character_data()
	player_setup.save_character(S)
	return 1

/datum/preferences/proc/overwrite_character(slot)
	if(!path)				return 0
	if(!fexists(path))		return 0
	var/savefile/S = new /savefile(path)
	if(!S)					return 0
	if(!slot)	slot = default_slot
	if(slot != SAVE_RESET)
		slot = sanitize_integer(slot, 1, config_legacy.character_slots, initial(default_slot))
		if(slot != default_slot)
			default_slot = slot
			S["default_slot"] << slot
	else
		S["default_slot"] << default_slot

	return 1

/datum/preferences/proc/sanitize_preferences()
	player_setup.sanitize_setup()
	return 1

#undef SAVEFILE_VERSION_MAX
#undef SAVEFILE_VERSION_MIN
