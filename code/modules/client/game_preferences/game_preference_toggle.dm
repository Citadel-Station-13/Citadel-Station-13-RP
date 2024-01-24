//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

GLOBAL_LIST_INIT(game_preference_toggles, init_game_preference_toggles())

/proc/init_game_preference_toggles()
	. = list()
	for(var/datum/game_preference_toggle/casted as anything in subtypesof(/datum/game_preference_toggle))
		if(initial(casted.abstract_type) == casted)
			continue
		casted = new casted
		if(!isnull(.[casted.key]))
			STACK_TRACE("dupe key between [casted.type] and [.[casted.key]:type]")
			continue
		.[casted.key] = casted

/proc/fetch_game_preference_toggle(datum/game_preference_toggle/togglelike)
	if(ispath(togglelike))
		togglelike = initial(togglelike.key)
	else if(istype(togglelike))
	else
		togglelike = GLOB.game_preference_toggles[togglelike]
	return togglelike

/datum/game_preference_toggle
	abstract_type = /datum/game_preference_toggle
	var/name = "A Toggle"
	var/description = "Someone fucked up"
	var/enabled_name = "On"
	var/disabled_name = "Off"
	/// must be unique
	var/key
	var/category = "Misc"
	/// legacy import id - set if it's using new global prefs system
	var/legacy_global_key
	/// legacy import id - set if it's using old savefile direct write
	var/legacy_savefile_key
	var/default_value = TRUE


#warn impl

#warn unit test key uniqueness


#warn use GAME_PREFERENCE_TOGGLE_VERB_DECLARE(NAME, TOGGLEPATH)

#warn impl all toggles below
