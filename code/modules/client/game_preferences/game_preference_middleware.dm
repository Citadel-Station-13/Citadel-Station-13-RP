//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/// key value ckey = value
GLOBAL_LIST_INIT(game_preference_middleware, init_game_preference_middleware())

/proc/init_game_preference_middleware()
	var/list/keyed_middleware = list()
	for(var/datum/game_preference_middleware/middleware as anything in subtypesof(/datum/game_preference_middleware))
		middleware = new middleware
		keyed_middleware[middleware.key] = middleware
	GLOB.game_preference_middleware = keyed_middleware
	return keyed_middleware

/datum/game_preference_middleware
	/// key
	var/key
	/// tgui interface
	var/tgui_interface

/**
 * return TRUE to stop handling
 */
/datum/game_preference_middleware/proc/handle_topic(datum/game_preferences/prefs, action, list/params)	
	#warn impl

/datum/game_preference_middleware/ui_static_data(mob/user, datum/tgui/ui, is_module)
	. = ..()

	var/datum/game_preferences/prefs = ui.src_object
	if(!istype(prefs))
		return
		
	.["$tgui"] = tgui_interface

	#warn impl

/datum/game_preference_middleware/ui_data(mob/user, datum/tgui/ui)
	. = ..()

	var/datum/game_preferences/prefs = ui.src_object
	if(!istype(prefs))
		return
		
	#warn impl
