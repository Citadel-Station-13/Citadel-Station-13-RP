//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/game_preference_entry/simple_color/admin_ooc_color
	name = "OOC Color (Admin)"
	description = "Choose your OOC color. Do not make it too eye-searing. Set to #000001 or reset to default to sync with server color."
	key = "admin_ooc_color"
	category = "Game"
	subcategory = ""
	default_value = null
	legacy_savefile_key = "ooccolor"

/datum/game_preference_entry/simple_color/ooc_color/is_visible(client/user)
	return check_rights(C = user) && CONFIG_GET(flag/allow_admin_ooccolor)

// todo: should we make things nullable? it's a weird pattern but...
/datum/game_preference_entry/simple_color/ooc_color/default_value(client/user)
	return "#000001"
