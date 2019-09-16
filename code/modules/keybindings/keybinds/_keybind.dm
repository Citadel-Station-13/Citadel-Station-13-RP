/proc/get_all_keybind_datums()
	. = list()
	for(var/path in subtypesof(/datum/keybind))
		var/datum/keybind/KB = path
		if(initial(KB.abstract_type) != path)
			. += new path

/datum/keybind
	//User-facing fluff
	var/name = "ABSTRACT KEYBIND (ERROR)"
	var/desc = "You should not be seeing this! Contact a coder."
	var/category = KEYBIND_CATEGORY_MISC
	//Comsigs to trigger
	var/keyup_signal = COMSIG_KEYBIND_DEFAULT
	var/keydown_signal = COMSIG_KEYBIND_DEFAULT
	//Default keys
	var/default_key_master = KEYBIND_KEY_NONE		//Master default
	var/default_key_hotkey = KEYBIND_KEY_NONE		//Default for hotkey mode
	var/default_key_classic = KEYBIND_KEY_NONE		//Default for non-hotkey mode

/datum/keybind/proc/keyDown(client/C)

/datum/keybind/proc/keyUp(client/C)

/datum/keybind/proc/default_hotkey_key()
	return default_key_hotkey || default_key_master

/datum/keybind/proc/default_classic_key()
	return default_key_classic || default_key_master

