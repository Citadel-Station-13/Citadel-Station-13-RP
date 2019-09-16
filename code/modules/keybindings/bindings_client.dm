/proc/input_sanity_check(client/C, key)
	if(SSinput.valid_keys[key])
		return FALSE

	if(length(key) > 32)
		log_admin("[key_name(C)] just attempted to send an invalid keypress with length over 32 characters, likely malicious.")
		message_admins("[ADMIN_TPMONTY(C.mob)][ADMINKICK(C)] just attempted to send an invalid keypress with length over 32 characters, likely malicious.")
	else
		log_admin_private("[key_name(C)] just attempted to send an invalid keypress - \"[key]\", possibly malicious.")
		message_admins("[ADMIN_TPMONTY(C.mob)][ADMINKICK(C)] just attempted to send an invalid keypress - \"[key]\", possibly malicious.")
	return TRUE

/client/proc/hotkey_keystring_to_signal(keystring, key_up = FALSE)
	var/datum/keybind/KB = SSinput.keybind_by_path(prefs.hotkey_keybindings_by_keystring[keystring] || SSinput.default_hotkey_keybindings_by_keystring[keystring])
	return key_up? KB.keyup_signal : KB.keydown_signal

/client/proc/classic_keystring_to_signal(keystring, key_up = FALSE)
	var/datum/keybind/KB = SSinput.keybind_by_path(prefs.classic_keybindings_by_keystring[keystring] || SSinput.default_classic_keybindings_by_keystring[keystring])
	return key_up? KB.keyup_signal : KB.keydown_signal

// Clients aren't datums so we have to define these procs indpendently.
// These verbs are called for all key press and release events
/client/verb/keyDown(_key as text)
	set instant = TRUE
	set hidden = TRUE

	if(input_sanity_check(src, _key))
		return

	keys_held[_key] = world.time
	var/movement = SSinput.movement_keys[_key]
	if(!(next_move_dir_sub & movement) && !keys_held["Ctrl"])
		next_move_dir_add |= movement

	//Moonwalking!
	if(movement && !(movement & (movement - 1)) && keys_held["Alt"])
		mob.permfacedir(movement)

	// Client-level keybindings are ones anyone should be able to do at any time
	// Things like taking screenshots, hitting tab, and adminhelps.

	//Hardcoded keybinds.
	switch(_key)
		if("F1")
			if(keys_held["Ctrl"] && keys_held["Shift"]) // Is this command ever used?
				winset(src, null, "command=.options")
			else
				get_adminhelp()
			return
		if("F2") // Screenshot. Hold shift to choose a name and location to save in
			winset(src, null, "command=.screenshot [!keys_held["shift"] ? "auto" : ""]")
			return
		if("Return")	//no enter key please!
			return

	//SEND_SIGNAL(mob,


	if(holder)
		holder.key_down(_key, src)
	if(mob.focus)
		mob.focus.key_down(_key, src)

/client/verb/keyUp(_key as text)
	set instant = TRUE
	set hidden = TRUE

	if(input_sanity_check(src, _key))
		return

	keys_held -= _key
	var/movement = SSinput.movement_keys[_key]
	if(!(next_move_dir_add & movement))
		next_move_dir_sub |= movement

	if(holder)
		holder.key_up(_key, src)
	if(mob.focus)
		mob.focus.key_up(_key, src)

// Called every game tick
/client/keyLoop()
	if(holder)
		holder.keyLoop(src)
	if(mob?.focus)
		mob.focus.keyLoop(src)
