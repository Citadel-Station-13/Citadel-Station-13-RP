/datum/preferences
	var/preferences_enabled = null
	var/preferences_disabled = null

/datum/category_item/player_setup_item/player_global/settings
	name = "Settings"
	sort_order = 2

/datum/category_item/player_setup_item/player_global/settings/load_preferences(var/savefile/S)
	S["default_slot"]	      >> pref.default_slot

/datum/category_item/player_setup_item/player_global/settings/save_preferences(var/savefile/S)
	S["default_slot"]         << pref.default_slot

/datum/category_item/player_setup_item/player_global/settings/sanitize_preferences()
	pref.default_slot	= sanitize_integer(pref.default_slot, 1, config_legacy.character_slots, initial(pref.default_slot))
