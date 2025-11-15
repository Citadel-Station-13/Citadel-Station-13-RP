//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

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

/datum/game_preference_toggle/proc/tgui_preference_schema()
	return list(
		"key" = key,
		"category" = category,
		"priority" = priority,
		"default" = default_value,
		"name" = name,
		"desc" = description,
		"enabled" = enabled_name,
		"disabled" = disabled_name,
	)

/datum/game_preference_toggle/admin
	abstract_type = /datum/game_preference_toggle/admin
	category = "Admin"

/datum/game_preference_toggle/admin/is_visible(client/user)
	return check_rights(C = user, show_msg = FALSE)

/datum/game_preference_toggle/admin/global_looc
	name = "Remote LOOC Sight"
	description = "See all LOOC, regardless of location."
	key = "admin_global_looc"
	default_value = TRUE
	legacy_key = "CHAT_RLOOC"

/datum/game_preference_toggle/admin/obfuscate_stealth_dsay
	name = "Obfuscate Stealthmin Dsay"
	description = "Randomize ckey to a list of joke ckeys when dsay'ing while stealthed."
	key = "admin_obfuscate_stealth_dsay"
	default_value = TRUE
	legacy_key = "OBFUSCATE_STEALTH_DSAY"

/datum/game_preference_toggle/admin/stealth_hides_ghost
	name = "Stealthmin Hides Ghost"
	description = "Hide your ghost while stealthed."
	key = "admin_hide_stealth_ghost"
	default_value = TRUE

/datum/game_preference_toggle/chat
	abstract_type = /datum/game_preference_toggle/chat
	category = "Chat"

/datum/game_preference_toggle/chat/ooc
	name = "OOC enabled"
	description = "Toggles whether you see OOC (Out of Character) chat."
	legacy_key = "CHAT_OOC"
	key = "toggle_ooc"

/datum/game_preference_toggle/chat/looc
	name = "LOOC enabled"
	description = "Toggles whether you see LOOC (Local Out of Character) chat."
	legacy_key = "CHAT_LOOC"
	key = "toggle_looc"

/datum/game_preference_toggle/chat/dsay
	name = "Deadchat enabled"
	description = "Toggles whether you see dead chat."
	legacy_key = "CHAT_DEAD"
	key = "toggle_deadchat"

/datum/game_preference_toggle/chat/legacy_chat_tags
	name = "Chat Tags"
	description = "Legacy chat visual system for tags to the left of messages; you should likely keep this on."
	key = "legacy_chat_tags"
	default_value = TRUE
	legacy_key = "CHAT_SHOWICONS"

/datum/game_preference_toggle/chat/language_indicators
	name = "Language Indicators"
	description = "Show language indicators in the chat when you hear a known language."
	key = "language_indicators"
	default_value = TRUE
	legacy_key = "LANGUAGE_INDICATOR"

/datum/game_preference_toggle/game
	abstract_type = /datum/game_preference_toggle/game
	category = "Game"

/datum/game_preference_toggle/game/mob_tooltips
	name = "Mob Tooltips"
	key = "mob_tooltips"
	legacy_key = "MOB_TOOLTIPS"

/datum/game_preference_toggle/game/vocal_cues
	name = "Vocal Cues on Chat"
	key = "vocal_cues"
	description = "Enables playing a sound on hearing someone speak / act."

/datum/game_preference_toggle/game/overhead_chat
	name = "Overhead Chat"
	key = "runechat"
	legacy_key = "OVERHEAD_CHAT"
	description = "Enable rendering messages sent by mobs over their icon on the map."

/datum/game_preference_toggle/game/help_intent_firing
	name = "Help Intent Gun Safety"
	description = "If on, do not allow firing weapons in help intent."
	key = "help_intent_gun_safety"
	legacy_key = "HELP_INTENT_SAFETY"
	default_value = FALSE

/datum/game_preference_toggle/game/legacy_name_highlight
	name = "Emphasize Name Mentions"
	description = "Enlargen messages calling you by name."
	key = "legacy_name_mention"
	legacy_key = "CHAT_MENTION"

/datum/game_preference_toggle/ambience
	abstract_type = /datum/game_preference_toggle/ambience
	category = "Sound - Ambience"

/datum/game_preference_toggle/ambience/area_ambience
	name = "Area Ambience"
	key = "area_ambience"
	default_value = TRUE

/datum/game_preference_toggle/ambience/supermatter_hum
	name = "Supermatter Hum"
	key = "supermatter_ambience"
	legacy_key = "SOUND_SUPERMATTER"
	default_value = TRUE

/datum/game_preference_toggle/ambience/weather
	name = "Weather Sounds"
	key = "weather_ambience"
	legacy_key = "SOUND_WEATHER"
	default_value = TRUE

/datum/game_preference_toggle/ambience/atmospherics
	name = "Atmos Machinery Sounds"
	key = "atmos_machine_ambience"
	default_value = TRUE
	legacy_key = "SOUND_AIRPUMP"

/datum/game_preference_toggle/sfx
	abstract_type = /datum/game_preference_toggle/sfx
	category = "Sound - Effects"

/datum/game_preference_toggle/sfx/instruments
	name = "Instruments"
	description = "Play sounds from in-game instruments."
	key = "instrument_music"
	legacy_key = "SOUND_INSTRUMENT"

/datum/game_preference_toggle/music
	abstract_type = /datum/game_preference_toggle/music
	category = "Sound - Music"

/datum/game_preference_toggle/music/lobby
	name = "Lobby Music"
	description = "Play music in the lobby."
	key = "lobby_music"
	legacy_key = "SOUND_LOBBY"

/datum/game_preference_toggle/music/lobby/toggled(client/user, state)
	if(state)
		user.playtitlemusic()
	else
		user.media?.stop_music()

/datum/game_preference_toggle/music/admin
	name = "Admin Music"
	description = "Play admin MIDIs (or really just music nowadays)."
	key = "admin_music"
	legacy_key = "SOUND_MIDI"

/datum/game_preference_toggle/music/jukebox
	name = "Jukebox Music"
	description = "Play in-game jukebox music."
	key = "jukebox_music"
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

/datum/game_preference_toggle/vore_sounds/eating_noises
	name = "Eating Noises"
	key = "vore_eating_sounds"
	default_value = FALSE
	legacy_key = "EATING_NOISES"

/datum/game_preference_toggle/vore_sounds/digestion_noises
	name = "Digestion Noises"
	key = "vore_digestion_sounds"
	default_value = FALSE
	legacy_key = "DIGEST_NOISES"

/datum/game_preference_toggle/observer
	abstract_type = /datum/game_preference_toggle/observer
	category = "Observer"

/datum/game_preference_toggle/observer/ghost_ears
	name = "Hear All Speech"
	description = "Hear all speech, regardless of distance"
	key = "ghost_ears"
	default_value = TRUE
	legacy_key = "CHAT_GHOSTEARS"

/datum/game_preference_toggle/observer/ghost_sight
	name = "See All Emotes"
	description = "See all emotes, regardless of distance"
	key = "ghost_sight"
	default_value = TRUE
	legacy_key = "CHAT_GHOSTSIGHT"

/datum/game_preference_toggle/observer/ghost_radio
	name = "Hear All Radio"
	description = "Hear all radio chatter, regardless of distance"
	key = "ghost_radio"
	default_value = TRUE
	legacy_key = "CHAT_GHOSTRADIO"

/datum/game_preference_toggle/observer/ghost_subtle
	name = "See Subtle Emotes"
	description = "See subtle emotes"
	key = "ghost_subtle"
	default_value = TRUE
	legacy_key = "SUBTLE_SEE"

/datum/game_preference_toggle/presence
	abstract_type = /datum/game_preference_toggle/presence
	category = "Presence"

/datum/game_preference_toggle/presence/anonymous_ghost_chat
	name = "Anonymous Ghost Chat"
	description = "Hide your ckey when speaking in deadchat."
	key = "hide_ckey_from_deadchat"
	default_value = TRUE

/datum/game_preference_toggle/presence/show_advanced_who
	name = "Show Status in Advanced Who"
	description = "Show your playing status in advanced who."
	key = "advanced_who_status"
	default_value = FALSE

/datum/game_preference_toggle/presence/announce_ghost_joinleave
	name = "Announce Observer Join/Leave"
	description = "Announce to deadchat when you enter or exit deadchat."
	key = "announce_ghost_joinleave"
	default_value = FALSE
