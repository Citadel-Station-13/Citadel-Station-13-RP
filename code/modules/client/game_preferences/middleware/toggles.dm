//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/game_preference_middleware/toggles
	key = "toggles"

/datum/game_preference_middleware/toggles/handle_reset(datum/game_preferences/prefs)
	#warn impl

/datum/game_preference_middleware/toggles/handle_topic(datum/game_preferences/prefs, action, list/params)
	. = ..()
	if(.)
		return
	switch(action)
		if("reset")
			handle_reset(prefs)
			return TRUE
		if("toggle")
			var/id = params["id"]
	#warn impl

/datum/game_preference_middleware/toggles/on_initial_load(datum/game_preferences/prefs)
	#warn impl

/datum/game_preference_middleware/toggles/handle_sanitize(datum/game_preferences/prefs)
	#warn impl

/datum/game_preference_middleware/toggles/ui_static_data(mob/user, datum/tgui/ui, is_module)
	. = ..()

/datum/game_preference_middleware/toggles/ui_data(mob/user, datum/tgui/ui, is_module)
	. = ..()
	
