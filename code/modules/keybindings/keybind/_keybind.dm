/datum/keybinding
	var/list/hotkey_keys
	var/list/classic_keys
	var/name
	var/full_name
	var/description = "No description provided."
	var/category = CATEGORY_MISC
	var/weight = WEIGHT_LOWEST
	// todo: what is this for / why do we have it / should we do this?
	// keybinds using primarily signals is kind of a :/
	// because said components can't really inject keybind data into prefs..
	var/keybind_signal

/datum/keybinding/New()
	// Default keys to the master "hotkey_keys"
	if(LAZYLEN(hotkey_keys) && !LAZYLEN(classic_keys))
		classic_keys = hotkey_keys.Copy()

/datum/keybinding/proc/down(client/user)
    return FALSE

/datum/keybinding/proc/up(client/user)
	return FALSE

/datum/keybinding/proc/can_use(client/user)
	return TRUE

/datum/keybinding/proc/is_visible(client/user)
	return TRUE

/**
 * Data for a GamePreferenceKeybind
 */
/datum/keybinding/proc/tgui_keybinding_data()
	return list(
		"id" = name,
		"name" = full_name,
		"desc" = description,
		"category" = category,
	)
