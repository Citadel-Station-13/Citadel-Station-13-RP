//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/game_preference_middleware/toggles
	key = "toggles"

/datum/game_preference_middleware/toggles/handle_reset(datum/game_preferences/prefs)
	. = ..()
	prefs.toggles_by_key = list()
	for(var/key in GLOB.game_preference_toggles)
		var/datum/game_preference_toggle/toggle = GLOB.game_preference_toggles[key]
		prefs.toggles_by_key[toggle.key] = toggle.default_value

	prefs.push_ui_modules(updates = list((key) = list(
		"toggles" = prefs.toggles_by_key,
	)))

/datum/game_preference_middleware/toggles/handle_topic(datum/game_preferences/prefs, action, list/params)
	. = ..()
	if(.)
		return
	switch(action)
		if("reset")
			handle_reset(prefs)
			return TRUE
		if("toggle")
			var/key = params["key"]
			if(isnull(GLOB.game_preference_toggles[key]))
				return TRUE
			prefs.toggle(key)
			prefs.push_ui_modules(updates = list((key) = list(
				"toggles" = prefs.toggles_by_key,
			)))
			return TRUE

/datum/game_preference_middleware/toggles/ui_static_data(mob/user, datum/tgui/ui, is_module)
	. = ..()
	var/datum/game_preferences/prefs = ui.src_object
	.["toggles"] = prefs.toggles_by_key

/datum/game_preference_middleware/toggles/handle_sanitize(datum/game_preferences/prefs)
	. = ..()
	prefs.toggles_by_key = sanitize_islist(prefs.toggles_by_key)
	for(var/key in prefs.toggles_by_key)
		var/datum/game_preference_toggle/toggle = GLOB.game_preference_toggles[key]
		if(isnull(toggle))
			prefs.toggles_by_key -= key
			continue
		prefs.toggles_by_key[key] = !!prefs.toggles_by_key[key]
