//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/// key value id = middleware instance
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
	
/**
 * return TRUE to stop handling
 * 
 * we assume the 'usr' has been validated by the prefs datum!
 */
/datum/game_preference_middleware/proc/handle_topic(datum/game_preferences/prefs, action, list/params)
	return FALSE

/**
 * when we want to reset whatever this handles
 */
/datum/game_preference_middleware/proc/handle_reset(datum/game_preferences/prefs)
	return

/**
 * sanitize everything
 */
/datum/game_preference_middleware/proc/handle_sanitize(datum/game_preferences/prefS)
	return

/**
 * on initial load
 */
/datum/game_preference_middleware/proc/on_initial_load(datum/game_preferences/prefs)
	return
