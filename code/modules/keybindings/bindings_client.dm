/client

	/// Amount of keydowns in the last keysend checking interval
	var/client_keysend_amount = 0
	/// World tick time where client_keysend_amount will reset
	var/next_keysend_reset = 0
	/// World tick time where keysend_tripped will reset back to false
	var/next_keysend_trip_reset = 0
	/// When set to true, user will be autokicked if they trip the keysends in a second limit again
	var/keysend_tripped = FALSE
	/// custom movement keys for this client
	var/list/movement_keys = list()

// Clients aren't datums so we have to define these procs indpendently.
// These verbs are called for all key press and release events
/client/verb/keyDown(_key as text)
	set instant = TRUE
	set hidden = TRUE

	if(!preferences.initialized)
		return

	client_keysend_amount += 1

	var/cache = client_keysend_amount

	if(keysend_tripped && next_keysend_trip_reset <= world.time)
		keysend_tripped = FALSE

	if(next_keysend_reset <= world.time)
		client_keysend_amount = 0
		next_keysend_reset = world.time + (1 SECONDS)

	//The "tripped" system is to confirm that flooding is still happening after one spike
	//not entirely sure how byond commands interact in relation to lag
	//don't want to kick people if a lag spike results in a huge flood of commands being sent
	if(cache >= MAX_KEYPRESS_AUTOKICK)
		if(!keysend_tripped)
			keysend_tripped = TRUE
			next_keysend_trip_reset = world.time + (2 SECONDS)
		else
			log_admin("Client [ckey] was just autokicked for flooding keyDowns; likely abuse but potentially lagspike.")
			message_admins("Client [ckey] was just autokicked for flooding keyDowns; likely abuse but potentially lagspike.")
			qdel(src)
			return

	///Check if the key is short enough to even be a real key
	if(LAZYLEN(_key) > MAX_KEYPRESS_COMMANDLENGTH)
		to_chat(src, "<span class='userdanger'>Invalid KeyDown detected! You have been disconnected from the server automatically.</span>")
		log_admin("Client [ckey] just attempted to send an invalid keyDown - [_key]. Keymessage was over [MAX_KEYPRESS_COMMANDLENGTH] characters, autokicking due to likely abuse.")
		message_admins("Client [ckey] just attempted to send an invalid keyDown - [_key]. Keymessage was over [MAX_KEYPRESS_COMMANDLENGTH] characters, autokicking due to likely abuse.")
		qdel(src)
		return

	if(_key == "Tab")
		ForceAllKeysUp()		//groan, more hacky kevcode
		return

	if(length(keys_held) > MAX_HELD_KEYS)
		keys_held.Cut(1,2)
	keys_held[_key] = TRUE
	var/movement = movement_keys[_key]
	if(!(next_move_dir_sub & movement) && !keys_held["Ctrl"])
		next_move_dir_add |= movement

	// Client-level keybindings are ones anyone should be able to do at any time
	// Things like taking screenshots, hitting tab, and adminhelps.
	var/AltMod = keys_held["Alt"] ? "Alt" : ""
	var/CtrlMod = keys_held["Ctrl"] ? "Ctrl" : ""
	var/ShiftMod = keys_held["Shift"] ? "Shift" : ""
	var/full_key
	switch(_key)
		if("Alt", "Ctrl", "Shift")
			full_key = "[AltMod][CtrlMod][ShiftMod]"
		else
			full_key = "[AltMod][CtrlMod][ShiftMod][_key]"
	var/keycount = 0
	for(var/kb_name in preferences?.keybindings[full_key])
		keycount++
		var/datum/keybinding/kb = GLOB.keybindings_by_name[kb_name]
		if(kb.can_use(src) && kb.down(src) && keycount >= MAX_COMMANDS_PER_KEY)
			break

	if(mob.key_intercept?.key_down(_key, src))
		return
	mob.key_focus?.key_down(_key, src)

/// Keyup's all keys held down.
/client/proc/ForceAllKeysUp()
	// simulate a user releasing all keys except for the mod keys. groan. i hate this. thanks, byond. why aren't keyups able to be forced to fire on macro change aoaoaoao.
	// groan
	for(var/key in keys_held)		// all of these won't be the 3 mod keys.
		if((key == "Ctrl") || (key == "Alt") || (key == "Shift"))
			continue
		keyUp("[key]")

/client/verb/keyUp(_key as text)
	set instant = TRUE
	set hidden = TRUE

	client_keysend_amount += 1

	var/cache = client_keysend_amount

	if(keysend_tripped && next_keysend_trip_reset <= world.time)
		keysend_tripped = FALSE

	if(next_keysend_reset <= world.time)
		client_keysend_amount = 0
		next_keysend_reset = world.time + (1 SECONDS)

	//The "tripped" system is to confirm that flooding is still happening after one spike
	//not entirely sure how byond commands interact in relation to lag
	//don't want to kick people if a lag spike results in a huge flood of commands being sent
	if(cache >= MAX_KEYPRESS_AUTOKICK)
		if(!keysend_tripped)
			keysend_tripped = TRUE
			next_keysend_trip_reset = world.time + (2 SECONDS)
		else
			log_admin("Client [ckey] was just autokicked for flooding keyUps; likely abuse but potentially lagspike.")
			message_admins("Client [ckey] was just autokicked for flooding keyUp; likely abuse but potentially lagspike.")
			qdel(src)
			return

	///Check if the key is short enough to even be a real key
	if(LAZYLEN(_key) > MAX_KEYPRESS_COMMANDLENGTH)
		to_chat(src, "<span class='userdanger'>Invalid KeyUp detected! You have been disconnected from the server automatically.</span>")
		log_admin("Client [ckey] just attempted to send an invalid keyUp - [_key]. Keymessage was over [MAX_KEYPRESS_COMMANDLENGTH] characters, autokicking due to likely abuse.")
		message_admins("Client [ckey] just attempted to send an invalid keyUp - [_key]. Keymessage was over [MAX_KEYPRESS_COMMANDLENGTH] characters, autokicking due to likely abuse.")
		qdel(src)
		return

	keys_held -= _key
	var/movement = movement_keys[_key]
	if(!(next_move_dir_add & movement))
		next_move_dir_sub |= movement

	// We don't do full key for release, because for mod keys you
	// can hold different keys and releasing any should be handled by the key binding specifically
	for (var/kb_name in preferences?.keybindings[_key])
		var/datum/keybinding/kb = GLOB.keybindings_by_name[kb_name]
		if(kb.can_use(src) && kb.up(src))
			break

	if(mob.key_intercept?.key_up(_key, src))
		return
	mob.key_focus?.key_up(_key, src)

// Called every game tick
/client/keyLoop()
	if(mob.key_intercept?.keyLoop(src))
		return
	mob.key_focus?.keyLoop(src)

/client/proc/update_movement_keys(datum/game_preferences/direct_prefs)
	var/datum/game_preferences/D = preferences || direct_prefs
	if(!D?.keybindings)
		return
	movement_keys = list()
	for(var/key in D.keybindings)
		for(var/kb_name in D.keybindings[key])
			switch(kb_name)
				if("North")
					movement_keys[key] = NORTH
				if("East")
					movement_keys[key] = EAST
				if("West")
					movement_keys[key] = WEST
				if("South")
					movement_keys[key] = SOUTH

/**
 * Returns a list of human-readable (usually) keys.
 */
/client/proc/get_keys_for_keybind(datum/keybinding/binding_or_path) as /list
	if(!preferences?.initialized)
		return list()
	var/bind_id = ispath(binding_or_path) ? binding_or_path::name : binding_or_path.name
	. = list()
	for(var/key in preferences.keybindings)
		if(bind_id in preferences.keybindings[key])
			. += key

/**
 * Returns a string that can be interpolated in tgui-chat to allow a quick click to rebind keys
 *
 * todo: for now, this just returns a string without the keybind UI open link.
 */
/client/proc/print_keys_for_keybind_with_prefs_link(datum/keybinding/binding_or_path, append) as text
	var/list/keys = get_keys_for_keybind(binding_or_path)
	return length(keys) ? "<b>([english_list(keys)])</b>[append]" : "<b>(Unbound)</b>[append]"
