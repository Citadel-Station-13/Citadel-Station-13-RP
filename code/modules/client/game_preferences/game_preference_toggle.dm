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
	/// priority - higher means it appears first. only valid within the same category.
	var/priority = 0
	/// legacy import id
	var/legacy_key
	var/default_value = TRUE

/datum/game_preference_toggle/proc/toggled(client/user, state)
	return

/datum/game_preference_toggle/proc/is_visible(client/user)
	return TRUE

#warn impl

#warn unit test key uniqueness


#warn use GAME_PREFERENCE_TOGGLE_VERB_DECLARE(NAME, TOGGLEPATH)

#warn impl all toggles below

/datum/game_preference_toggle/admin
	abstract_type = /datum/game_preference_toggle/admin
	category = "Admin"

/datum/game_preference_toggle/admin/is_visible(client/user)
	return check_rights(C = user)

#warn impl

/datum/game_preference_toggle/chat
	abstract_type = /datum/game_preference_toggle/chat
	category = "Chat"

/datum/game_preference_toggle/chat/ooc
	name = "OOC enabled"
	description = "Toggles whether you see OOC (Out of Character) chat."
	legacy_key = "CHAT_OOC"
	key = "ToggleOOC"

/datum/game_preference_toggle/chat/looc
	name = "LOOC enabled"
	description = "Toggles whether you see LOOC (Local Out of Character) chat."
	legacy_key = "CHAT_LOOC"
	key = "ToggleLOOC"

/datum/game_preference_toggle/chat/dead
	name = "Deadchat enabled"
	description = "Toggles whether you see dead chat."
	legacy_key = "CHAT_DEAD"
	key = "ToggleDeadchat"

#warn impl

/datum/game_preference_toggle/game
	abstract_type = /datum/game_preference_toggle/game
	category = "Game"

/datum/game_preference_toggle/game/mob_tooltips
	name = "Mob Tooltips"
	key = "MobTooltips"
	legacy_key = "MOB_TOOLTIPS"

#warn impl

/datum/game_preference_toggle/ambience
	abstract_type = /datum/game_preference_toggle/ambience
	category = "Sound - Ambience"

#warn impl

/datum/game_preference_toggle/sfx
	abstract_type = /datum/game_preference_toggle/sfx
	category = "Sound - Effects"

#warn impl

/datum/game_preference_toggle/music
	abstract_type = /datum/game_preference_toggle/music
	category = "Sound - Music"

/datum/game_preference_toggle/music/lobby
	name = "Lobby Music"
	description = "Play music in the lobby."
	key = "LobbyMusic"
	legacy_key = "SOUND_LOBBY"

/datum/game_preference_toggle/music/lobby/toggled(client/user, state)
	if(state)
		user.mob?.playtitlemusic()
	else
		user.mob?.media?.stop_music()

/datum/game_preference_toggle/music/admin
	name = "Admin Music"
	description = "Play admin MIDIs (or really just music nowadays)."
	key = "AdminMusic"
	legacy_key = "SOUND_MIDI"

/datum/game_preference_toggle/music/jukebox
	name = "Jukebox Music"
	description = "Play in-game jukebox music."
	key = "JukeboxMusic"
	legacy_key = "SOUND_JUKEBOX"

/datum/game_preference_toggle/music/jukebox/toggled(client/user, state)
	// todo: jukebox / music rework
	if(state)
		user.mob?.update_music()
	else
		user.mob?.stop_all_music()

// todo: this should probably not be in toggles

/datum/game_preference_toggle/vore_sounds
	abstract_type = /datum/game_preference_toggle/vore_sounds
	category = "Sound - Vore"

/datum/game_preference_toggle/observer
	abstract_type = /datum/game_preference_toggle/observer
	category = "Observer"

#warn impl
