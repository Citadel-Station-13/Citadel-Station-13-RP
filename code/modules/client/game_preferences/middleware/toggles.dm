//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/datum/game_preference_middleware/toggles
	name = "Toggles"
	key = "toggles"

/datum/game_preference_middleware/toggles/handle_reset(datum/game_preferences/prefs)
	. = ..()
	prefs.toggles_by_key = list()
	for(var/key in SSpreferences.toggles_by_key)
		var/datum/game_preference_toggle/toggle = SSpreferences.toggles_by_key[key]
		prefs.toggles_by_key[toggle.key] = toggle.default_value

	prefs.push_ui_nested_data(updates = list((src.key) = list(
		"states" = prefs.toggles_by_key,
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
			if(isnull(SSpreferences.toggles_by_key[key]))
				return TRUE
			prefs.set_toggle(key, !!params["val"])
			// todo: optimize this
			prefs.push_ui_nested_data(updates = list((src.key) = list(
				"states" = prefs.toggles_by_key,
			)))
			prefs.mark_dirty()
			return TRUE

/datum/game_preference_middleware/toggles/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()
	var/datum/game_preferences/prefs = ui.src_object
	var/list/collected_toggles = list()
	for(var/key in SSpreferences.toggles_by_key)
		var/datum/game_preference_toggle/toggle = SSpreferences.toggles_by_key[key]
		if(!toggle.is_visible(user?.client))
			continue
		collected_toggles[toggle.key] = toggle.tgui_preference_schema()
	.["toggles"] = collected_toggles
	.["states"] = prefs.toggles_by_key

/datum/game_preference_middleware/toggles/handle_sanitize(datum/game_preferences/prefs)
	. = ..()
	prefs.toggles_by_key = sanitize_islist(prefs.toggles_by_key)
	for(var/key in prefs.toggles_by_key)
		var/datum/game_preference_toggle/toggle = SSpreferences.toggles_by_key[key]
		if(isnull(toggle))
			prefs.toggles_by_key -= key
			continue
		prefs.toggles_by_key[key] = !!prefs.toggles_by_key[key]
