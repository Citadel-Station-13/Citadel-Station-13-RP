//this works as is to create a single checked item, but has no back end code for toggleing the check yet
#define TOGGLE_CHECKBOX(PARENT, CHILD) PARENT/CHILD/abstract = TRUE;PARENT/CHILD/checkbox = CHECKBOX_TOGGLE;PARENT/CHILD/verb/CHILD

//Example usage TOGGLE_CHECKBOX(datum/verbs/menu/Settings/Ghost/chatterbox, toggle_ghost_ears)()

//override because we don't want to save preferences twice.
/datum/verbs/menu/Settings/Set_checked(client/C, verbpath)
	if (checkbox == CHECKBOX_GROUP)
		C.prefs.menuoptions[type] = verbpath
	else if (checkbox == CHECKBOX_TOGGLE)
		var/checked = Get_checked(C)
		checked = (checked ? TRUE : FALSE) //check sanitizatio
		C.prefs.menuoptions[type] = !checked
		winset(C, "[verbpath]", "is-checked = [!checked]")

/datum/verbs/menu/Settings/verb/setup_character()
	set name = "Game Preferences"
	set category = "Preferences"
	set desc = "Open Game Preferences Window"
	// usr.client.prefs.current_tab = 1
	usr.client.prefs.ShowChoices(usr)

//toggles
/datum/verbs/menu/Settings/Ghost/chatterbox
	name = "Chat Box Spam"

TOGGLE_CHECKBOX(/datum/verbs/menu/Settings/Ghost/chatterbox, toggle_ghost_ears)()
	set name = "Show/Hide GhostEars"
	set category = "Preferences"
	set desc = "See All Speech"

	var/pref_path = /datum/client_preference/ghost_ears
	usr.client.toggle_preference(pref_path)
	to_chat(usr, "As a ghost, you will now [(usr.is_preference_enabled(pref_path)) ? "see all speech in the world" : "only see speech from nearby mobs"].")
	SScharacter_setup.queue_preferences_save(usr.client.prefs)

	feedback_add_details("admin_verb","TGEars") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
/datum/verbs/menu/Settings/Ghost/chatterbox/toggle_ghost_ears/Get_checked(client/C)
	return C.is_preference_enabled(/datum/client_preference/ghost_ears)

TOGGLE_CHECKBOX(/datum/verbs/menu/Settings/Ghost/chatterbox, toggle_ghost_sight)()
	set name = "Show/Hide GhostSight"
	set category = "Preferences"
	set desc = "See All Emotes"

	var/pref_path = /datum/client_preference/ghost_sight
	usr.client.toggle_preference(pref_path)
	to_chat(usr, "As a ghost, you will now [(usr.is_preference_enabled(pref_path)) ? "see all emotes in the world" : "only see emotes from nearby mobs"].")
	SScharacter_setup.queue_preferences_save(usr.client.prefs)
	feedback_add_details("admin_verb","TGVision") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
/datum/verbs/menu/Settings/Ghost/chatterbox/toggle_ghost_sight/Get_checked(client/C)
	return C.is_preference_enabled(/datum/client_preference/ghost_sight)

TOGGLE_CHECKBOX(/datum/verbs/menu/Settings/Ghost/chatterbox, toggle_ghost_radio)()
	set name = "Show/Hide GhostRadio"
	set category = "Preferences"
	set desc = "See All Radio Chatter"

	var/pref_path = /datum/client_preference/ghost_radio
	usr.client.toggle_preference(pref_path)
	to_chat(usr, "As a ghost, you will now [(usr.is_preference_enabled(pref_path)) ? "see radio chatter" : "not see radio chatter"].")
	SScharacter_setup.queue_preferences_save(usr.client.prefs)
	feedback_add_details("admin_verb","TGRadio") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
/datum/verbs/menu/Settings/Ghost/chatterbox/toggle_ghost_radio/Get_checked(client/C)
	return C.is_preference_enabled(/datum/client_preference/ghost_radio)


TOGGLE_CHECKBOX(/datum/verbs/menu/Settings/Sound, toggletitlemusic)()
	set name = "Hear/Silence Lobby Music"
	set category = "Preferences"
	set desc = "Hear Music In Lobby"

	var/pref_path = /datum/client_preference/play_lobby_music
	usr.client.toggle_preference(pref_path)
	SScharacter_setup.queue_preferences_save(usr.client.prefs)
	if(usr.is_preference_enabled(pref_path))
		to_chat(usr, "You will now hear music in the game lobby.")
		//if(isnewplayer(usr))
		//	usr.client.playtitlemusic()
	else
		to_chat(usr, "You will no longer hear music in the game lobby.")
		usr.stop_sound_channel(CHANNEL_LOBBYMUSIC)
	feedback_add_details("admin_verb","TLobMusic") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
/datum/verbs/menu/Settings/Sound/toggletitlemusic/Get_checked(client/C)
	return C.is_preference_enabled(/datum/client_preference/play_lobby_music)


TOGGLE_CHECKBOX(/datum/verbs/menu/Settings/Sound, togglemidis)()
	set name = "Hear/Silence Midis"
	set category = "Preferences"
	set desc = "Hear Admin Triggered Sounds (Midis)"

	var/pref_path = /datum/client_preference/play_admin_midis
	usr.client.toggle_preference(pref_path)
	SScharacter_setup.queue_preferences_save(usr.client.prefs)
	if(usr.is_preference_enabled(pref_path))
		to_chat(usr, "You will now hear any sounds uploaded by admins.")
	else
		to_chat(usr, "You will no longer hear sounds uploaded by admins")
		usr.stop_sound_channel(CHANNEL_ADMIN)
		var/client/C = usr.client
		if(C && C.chatOutput && !C.chatOutput.broken && C.chatOutput.loaded)
			C.chatOutput.stopMusic()
	feedback_add_details("admin_verb","TAMidis") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
/datum/verbs/menu/Settings/Sound/togglemidis/Get_checked(client/C)
	return C.is_preference_enabled(/datum/client_preference/play_admin_midis)


TOGGLE_CHECKBOX(/datum/verbs/menu/Settings/Sound, toggle_instruments)()
	set name = "Hear/Silence Instruments"
	set category = "Preferences"
	set desc = "Hear In-game Instruments"

	var/pref_path = /datum/client_preference/instrument_toggle
	usr.client.toggle_preference(pref_path)
	SScharacter_setup.queue_preferences_save(usr.client.prefs)
	if(usr.is_preference_enabled(pref_path))
		to_chat(usr, "You will now hear people playing musical instruments.")
	else
		to_chat(usr, "You will no longer hear musical instruments.")
	feedback_add_details("admin_verb","THInstm") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
/datum/verbs/menu/Settings/Sound/toggle_instruments/Get_checked(client/C)
	return C.is_preference_enabled(/datum/client_preference/instrument_toggle)


TOGGLE_CHECKBOX(/datum/verbs/menu/Settings/Sound, Toggle_Soundscape)()
	set name = "Hear/Silence Ambience"
	set category = "Preferences"
	set desc = "Hear Ambient Sound Effects"

	var/pref_path = /datum/client_preference/play_ambiance
	usr.client.toggle_preference(pref_path)
	SScharacter_setup.queue_preferences_save(usr.client.prefs)
	if(usr.is_preference_enabled(pref_path))
		to_chat(usr, "You will now hear ambient sounds.")
	else
		to_chat(usr, "You will no longer hear ambient sounds.")
		usr.stop_sound_channel(CHANNEL_AMBIENCE)
		usr.stop_sound_channel(CHANNEL_BUZZ)
	feedback_add_details("admin_verb","TAmbience") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
/datum/verbs/menu/Settings/Sound/Toggle_Soundscape/Get_checked(client/C)
	return C.is_preference_enabled(/datum/client_preference/play_ambiance)


/datum/verbs/menu/Settings/Sound/verb/stop_client_sounds()
	set name = "Stop Sounds"
	set category = "Preferences"
	set desc = "Stop Current Sounds"
	SEND_SOUND(usr, sound(null))
	var/client/C = usr.client
	if(C && C.chatOutput && !C.chatOutput.broken && C.chatOutput.loaded)
		C.chatOutput.stopMusic()
	feedback_add_details("admin_verb","stopsoundclient") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


TOGGLE_CHECKBOX(/datum/verbs/menu/Settings, listen_ooc)()
	set name = "Show/Hide OOC"
	set category = "Preferences"
	set desc = "Show OOC Chat"

	var/pref_path = /datum/client_preference/show_ooc
	usr.client.toggle_preference(pref_path)
	SScharacter_setup.queue_preferences_save(usr.client.prefs)
	to_chat(usr, "You will [(usr.is_preference_enabled(pref_path)) ? "now" : "no longer"] see messages on the OOC channel.")
	feedback_add_details("admin_verb","TOOC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
/datum/verbs/menu/Settings/listen_ooc/Get_checked(client/C)
	return C.is_preference_enabled(/datum/client_preference/show_ooc)

TOGGLE_CHECKBOX(/datum/verbs/menu/Settings, listen_looc)()
	set name = "Show/Hide LOOC"
	set category = "Preferences"
	set desc = "Toggles seeing LOOC chat"

	var/pref_path = /datum/client_preference/show_looc //wish these were defines for muh performance
	usr.client.toggle_preference(pref_path)
	SScharacter_setup.queue_preferences_save(usr.client.prefs)
	to_chat(usr, "You will [(usr.is_preference_enabled(pref_path)) ? "now" : "no longer"] see messages on the LOOC channel.")
	feedback_add_details("admin_verb","TLOOC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
/datum/verbs/menu/Settings/listen_ooc/Get_checked(client/C)
	return C.is_preference_enabled(/datum/client_preference/show_looc)


/client/verb/toggle_typing()
	set name = "Show/Hide Typing Indicator"
	set category = "Preferences"
	set desc = "Toggles the speech bubble typing indicator."

	var/pref_path = /datum/client_preference/show_typing_indicator
	usr.client.toggle_preference(pref_path)
	SScharacter_setup.queue_preferences_save(usr.client.prefs)
	to_chat(src,"You will [ (usr.is_preference_enabled(pref_path)) ? "now" : "no longer"] have the speech indicator.")
	feedback_add_details("admin_verb","TTIND") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

//Admin Preferences
/client/verb/toggle_ahelp_sound()
	set name = "Hear/Silence Adminhelps"
	set category = "Preferences"
	set desc = "Toggle hearing a notification when admin PMs are received"
	if(!holder)
		return
	var/pref_path = /datum/client_preference/holder/play_adminhelp_ping
	usr.client.toggle_preference(pref_path)
	SScharacter_setup.queue_preferences_save(usr.client.prefs)
	to_chat(src,"You will [ (usr.is_preference_enabled(pref_path)) ? "now" : "no longer"] receive noise from admin messages.")
	feedback_add_details("admin_verb","TAHelp") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_deadchat()
	set name = "Show/Hide Deadchat"
	set category = "Preferences"
	set desc = "Toggles the dead chat channel."

	var/pref_path = /datum/client_preference/show_dsay
	usr.client.toggle_preference(pref_path)
	SScharacter_setup.queue_preferences_save(usr.client.prefs)
	to_chat(src,"You will [ (usr.is_preference_enabled(pref_path)) ? "now" : "no longer"] hear dead chat as a ghost.")
	feedback_add_details("admin_verb","TDeadChat") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/client/verb/toggle_weather_sounds() //LN: I don't know if these fall under ambient noise, if they do i will axe these down.
	set name = "Toggle Weather Sounds"
	set category = "Preferences"
	set desc = "Toggles the ability to hear weather sounds while on a planet."

	var/pref_path = /datum/client_preference/weather_sounds
	usr.client.toggle_preference(pref_path)
	SScharacter_setup.queue_preferences_save(usr.client.prefs)
	to_chat(src,"You will [ (usr.is_preference_enabled(pref_path)) ? "now" : "no longer"] hear weather sounds.")
	feedback_add_details("admin_verb","TWeatherSounds") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_supermatter_hum()
	set name = "Toggle SM Hum" // Avoiding using the full 'Supermatter' name to not conflict with the Setup-Supermatter adminverb.
	set category = "Preferences"
	set desc = "Toggles the ability to hear supermatter hums."

	var/pref_path = /datum/client_preference/supermatter_hum
	usr.client.toggle_preference(pref_path)
	SScharacter_setup.queue_preferences_save(usr.client.prefs)
	to_chat(src,"You will [ (usr.is_preference_enabled(pref_path)) ? "now" : "no longer"] hear a hum from the supermatter.")
	feedback_add_details("admin_verb","TSupermatterHum") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_air_pump_hum()
	set name = "Toggle Air Pump Noise"
	set category = "Preferences"
	set desc = "Toggles Air Pumps humming"

	var/pref_path = /datum/client_preference/air_pump_noise
	usr.client.toggle_preference(pref_path)
	SScharacter_setup.queue_preferences_save(usr.client.prefs)
	to_chat(src, "You will [ (usr.is_preference_enabled(pref_path)) ? "now" : "no longer"] hear air pumps hum, start, and stop.")
	feedback_add_details("admin_verb","TAirPumpNoise")

/client/verb/toggle_jukebox()
	set name = "Toggle Jukebox"
	set category = "Preferences"
	set desc = "Toggles the playing of jukebox music."

	var/pref_path = /datum/client_preference/play_jukebox
	usr.client.toggle_preference(pref_path)
	SScharacter_setup.queue_preferences_save(usr.client.prefs)
	to_chat(src, "You will [ (usr.is_preference_enabled(pref_path)) ? "now" : "no longer"] hear jukebox music.")
	feedback_add_details("admin_verb","TJukebox") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_be_special(role in be_special_flags)
	set name = "Toggle SpecialRole Candidacy"
	set category = "Preferences"
	set desc = "Toggles which special roles you would like to be a candidate for, during events."

	var/role_flag = be_special_flags[role]
	if(!role_flag)
		return

	prefs.be_special ^= role_flag
	SScharacter_setup.queue_preferences_save(prefs)
	to_chat(src,"You will [(prefs.be_special & role_flag) ? "now" : "no longer"] be considered for [role] events (where possible).")
	feedback_add_details("admin_verb","TBeSpecial") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/client/verb/toggle_safe_firing()
	set name = "Toggle Gun Firing Intent Requirement"
	set category = "Preferences"
	set desc = "Toggles between safe and dangerous firing. Safe requires a non-help intent to fire, dangerous can be fired on help intent."

	var/pref_path = /datum/client_preference/safefiring
	usr.client.toggle_preference(pref_path)
	SScharacter_setup.queue_preferences_save(prefs)
	to_chat(src,"You will now use [(usr.is_preference_enabled(/datum/client_preference/safefiring)) ? "safe" : "dangerous"] firearms firing.")
	feedback_add_details("admin_verb","TFiringMode") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_mob_tooltips()
	set name = "Toggle Mob Tooltips"
	set category = "Preferences"
	set desc = "Toggles displaying name/species over mobs when moused over."

	var/pref_path = /datum/client_preference/mob_tooltips
	usr.client.toggle_preference(pref_path)
	SScharacter_setup.queue_preferences_save(prefs)
	to_chat(src,"You will now [(usr.is_preference_enabled(/datum/client_preference/mob_tooltips)) ? "see" : "not see"] mob tooltips.")
	feedback_add_details("admin_verb","TMobTooltips") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


//Toggles for Staff
//Developers

/client/proc/toggle_debug_logs()
	set name = "Toggle Debug Logs"
	set category = "Preferences"
	set desc = "Toggles debug logs."

	var/pref_path = /datum/client_preference/debug/show_debug_logs
	if(check_rights(R_ADMIN|R_DEBUG))
		usr.client.toggle_preference(pref_path)
		to_chat(src,"You will [ (usr.is_preference_enabled(pref_path)) ? "now" : "no longer"] receive debug logs.")
		SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TBeSpecial") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

//Mods
/client/proc/toggle_attack_logs()
	set name = "Toggle Attack Logs"
	set category = "Preferences"
	set desc = "Toggles attack logs."

	var/pref_path = /datum/client_preference/mod/show_attack_logs

	if(check_rights(R_ADMIN|R_MOD))
		usr.client.toggle_preference(pref_path)
		to_chat(src,"You will [ (usr.is_preference_enabled(pref_path)) ? "now" : "no longer"] receive attack logs.")
		SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TBeSpecial") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
