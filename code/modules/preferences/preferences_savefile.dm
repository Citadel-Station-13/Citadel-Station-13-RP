/datum/preferences/proc/load_path(ckey,filename="preferences.sav")
	if(!ckey)	return
	path = "data/player_saves/[copytext(ckey,1,2)]/[ckey]/[filename]"
	savefile_version = SAVEFILE_VERSION_MAX

/datum/preferences/proc/load_preferences()
	// todo: storage handler datums...
	if(!path)
		return FALSE
	// check DOS guard
	if(world.time < loadprefcooldown) //This is done before checking if the file exists to ensure that the server can't hang on read attempts
		if(istype(client))
			to_chat(client, "<span class='warning'>You're attempting to load your preferences a little too fast. Wait half a second, then try again.</span>")
		return FALSE
	loadprefcooldown = world.time + PREF_SAVELOAD_COOLDOWN
	// get savefile
	if(!fexists(path))
		return FALSE
	var/savefile/S = new /savefile(path)
	if(!S)
		return FALSE
	// prep savefile
	S.cd = "/"
	// load savefile version
	S["version"] >> savefile_version
	// load global data so we can access it during migrations
	var/list/io_errors = list()
	read_global_data(S, io_errors)
	// perform migrations
	if(savefile_version < SAVEFILE_VERSION_MIN)
		io_errors += SPAN_DANGER("Your savefile version was [savefile_version], below minimum [SAVEFILE_VERSION_MIN]; your savefile will now be deleted and recreated.")
		// todo: wipe
		savefile_version = SAVEFILE_VERSION_MAX
	else if(savefile_version < SAVEFILE_VERSION_MAX)
		perform_global_migrations(S, savefile_version, io_errors, options)
		savefile_version = SAVEFILE_VERSION_MAX
		// don't flush immediately incase they want to cancel/ahelp about something breaking
		// save_preferences()
	queue_errors(io_errors, "error while migrating global data:")
	// load legacy data
	player_setup.load_preferences(S)
	if(initialized)
		auto_flush_errors()
	return TRUE

/datum/preferences/proc/save_preferences()
	// todo: storage handler datums...
	if(!path)
		return FALSE
	// check DOS guard
	if(world.time < saveprefcooldown)
		if(istype(client))
			to_chat(client, "<span class='warning'>You're attempting to save your preferences a little too fast. Wait half a second, then try again.</span>")
		return FALSE
	saveprefcooldown = world.time + PREF_SAVELOAD_COOLDOWN
	// get saveflie
	var/savefile/S = new /savefile(path)
	if(!S)
		return FALSE
	// prep saveflie
	S.cd = "/"
	// save savefile version
	S["version"] << savefile_version
	// write global data
	write_global_data(S)
	// write legacy data
	player_setup.save_preferences(S)
	if(initialized)
		auto_flush_errors()
	return TRUE

/datum/preferences/proc/load_character(slot)
	// todo: storage handler datums...
	if(!path)
		return FALSE
	// check DOS guard
	if(world.time < loadcharcooldown)
		if(istype(client))
			to_chat(client, "<span class='warning'>You're attempting to load your character a little too fast. Wait half a second, then try again.</span>")
		return FALSE
	loadcharcooldown = world.time + PREF_SAVELOAD_COOLDOWN
	// get savefile
	if(!fexists(path))
		return FALSE
	var/savefile/S = new /savefile(path)
	if(!S)
		return FALSE
	// prep savefile
	S.cd = "/"

	// BEGIN SLOT HANDLING
	if(!slot)
		slot = default_slot
	if(slot != SAVE_RESET) // SAVE_RESET will reset the slot as though it does not exist, but keep the current slot for saving purposes.
		slot = sanitize_integer(slot, 1, config_legacy.character_slots, initial(default_slot))
		if(slot != default_slot)
			default_slot = slot
			S["default_slot"] << slot
	else
		S["default_slot"] << default_slot
	if(slot != SAVE_RESET)
		S.cd = "/character[slot]"
	else
		S.cd = "/character[default_slot]"
	// END SLOT HANDLING

	var/list/io_errors = list()

	// load character data
	read_character_data(S, slot, io_errors)
	// perform migrations
	var/current_version = character[CHARACTER_DATA_VERSION]
	if(!isnum(current_version))
		current_version = CHARACTER_VERSION_LEGACY
	if(current_version < CHARACTER_VERSION_MIN)
		io_errors += SPAN_DANGER("Your character version was [current_version], below minimum [CHARACTER_VERSION_MIN]; your slot will now be reset.")
		// todo: wipe slot
		current_version = CHARACTER_VERSION_MAX
	else if(current_version < CHARACTER_VERSION_MAX)
		perform_character_migrations(S, current_version, io_errors, character)
		current_version = CHARACTER_VERSION_MAX
	queue_errors(io_errors, "error while migrating slot [slot]:")
	character[CHARACTER_DATA_VERSION] = current_version
	// load legacy data
	player_setup.load_character(S)
	// rebuild previews
	clear_character_previews() // Recalculate them on next show
	if(initialized)
		auto_flush_errors()
	return TRUE

/datum/preferences/proc/save_character()
	// todo: storage handler datums...
	if(!path)
		return FALSE
	// check DOS guard
	if(world.time < savecharcooldown)
		if(istype(client))
			to_chat(client, "<span class='warning'>You're attempting to save your character a little too fast. Wait half a second, then try again.</span>")
		return FALSE
	savecharcooldown = world.time + PREF_SAVELOAD_COOLDOWN
	// get saveflie
	var/savefile/S = new /savefile(path)
	if(!S)
		return FALSE
	// prep saveflie
	S.cd = "/character[default_slot]"
	// write character data
	write_character_data(S, default_slot)
	// write legacy data
	player_setup.save_character(S)
	if(initialized)
		auto_flush_errors()
	return TRUE

/datum/preferences/proc/overwrite_character(slot)
	if(!path)
		return 0
	if(!fexists(path))
		return 0
	var/savefile/S = new /savefile(path)
	if(!S)
		return 0
	if(!slot)
		slot = default_slot
	if(slot != SAVE_RESET)
		slot = sanitize_integer(slot, 1, config_legacy.character_slots, initial(default_slot))
		if(slot != default_slot)
			default_slot = slot
			S["default_slot"] << slot
	else
		S["default_slot"] << default_slot
	if(initialized)
		auto_flush_errors()
	return 1

/datum/preferences/proc/sanitize_preferences()
	player_setup.sanitize_setup()
	// todo: error feedback
	var/list/io_errors = list()
	sanitize_everything(io_errors)
	queue_errors(io_errors, "error during sanitize_preferences(); unknown call stack.")
	if(initialized)
		auto_flush_errors()
	return 1

#undef SAVEFILE_VERSION_MAX
#undef SAVEFILE_VERSION_MIN
