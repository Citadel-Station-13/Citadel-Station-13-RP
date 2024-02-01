
/datum/client_preference
	var/description
	var/key
	var/enabled_by_default = TRUE
	var/enabled_description = "Yes"
	var/disabled_description = "No"

/datum/client_preference/proc/may_toggle(var/mob/preference_mob)
	return TRUE

/datum/client_preference/proc/toggled(var/mob/preference_mob, var/enabled)
	return

/*********************
* Player Preferences *
*********************/

/datum/client_preference/ghost_ears
	description ="Ghost ears"
	key = "CHAT_GHOSTEARS"
	enabled_description = "All Speech"
	disabled_description = "Nearby"

/datum/client_preference/ghost_sight
	description ="Ghost sight"
	key = "CHAT_GHOSTSIGHT"
	enabled_description = "All Emotes"
	disabled_description = "Nearby"

/datum/client_preference/ghost_radio
	description ="Ghost radio"
	key = "CHAT_GHOSTRADIO"
	enabled_description = "All Chatter"
	disabled_description = "Nearby"

/datum/client_preference/chat_tags
	description ="Chat tags"
	key = "CHAT_SHOWICONS"
	enabled_description = "Show"
	disabled_description = "Hide"

/datum/client_preference/air_pump_noise
	description ="Air Pump Ambient Noise"
	key = "SOUND_AIRPUMP"
	enabled_description = "Audible"

/datum/client_preference/subtle_see
	description = "Subtle Emotes"
	key = "SUBTLE_SEE"
	enabled_description = "Show"
	disabled_description = "Hide"

/datum/client_preference/ambient_occlusion
	description = "Fake Ambient Occlusion"
	key = "AMBIENT_OCCLUSION_PREF"
	enabled_by_default = FALSE
	enabled_description = "On"
	disabled_description = "Off"

/datum/client_preference/ambient_occlusion/toggled(var/mob/preference_mob, var/enabled)
	. = ..()
	if(preference_mob.client)
		preference_mob?.using_perspective?.planes?.sync_owner(preference_mob.client)

/datum/client_preference/anonymous_ghost_chat
	description = "Anonymous Ghost Chat"
	key = "ANON_GHOST_CHAT"
	enabled_by_default = FALSE
	enabled_description = "Hide ckey"
	disabled_description = "Show ckey"

/datum/client_preference/show_in_advanced_who
	description = "Show my status in advanced who"
	key = "SHOW_IN_ADVANCED_WHO"
	enabled_by_default = TRUE
	enabled_description = "Visible"
	disabled_description = "Hidden"

/datum/client_preference/announce_ghost_joinleave
	description = "Announce joining/leaving as a ghost/observer"
	key = "ANNOUNCE_GHOST_JOINLEAVE"
	enabled_by_default = TRUE
	enabled_description = "Announce"
	disabled_description = "Silent"

#warn this goes to proper graphics section
/datum/client_preference/parallax
	description = "Parallax (fancy space, disable for FPS issues"
	key = "PARALLAX_ENABLED"
	enabled_description = "Enabled"
	disabled_description = "Disabled"

/datum/client_preference/parallax/toggled(mob/preference_mob, enabled)
	. = ..()
	preference_mob?.client?.parallax_holder?.reset()

/********************
* Staff Preferences *
********************/

/datum/client_preference/holder/play_adminhelp_ping
	description = "Adminhelps"
	key = "SOUND_ADMINHELP"
	enabled_description = "Hear"
	disabled_description = "Silent"

/datum/client_preference/holder/show_rlooc
	description ="Remote LOOC chat"
	key = "CHAT_RLOOC"
	enabled_description = "Show"
	disabled_description = "Hide"

/datum/client_preference/holder/obfuscate_stealth_dsay
	description = "Obfuscate Stealthmin Dsay"
	key = "OBFUSCATE_STEALTH_DSAY"
	enabled_by_default = FALSE
	enabled_description = "On"
	disabled_description = "Off"

/datum/client_preference/holder/stealth_ghost_mode
	description = "Stealthmin Ghost Mode"
	key = "STEALTH_GHOST_MODE"
	enabled_by_default = FALSE
	enabled_description = "Obfuscate Ghost"
	disabled_description = "Normal Ghost"

/datum/client_preference/language_indicator
	description = "Language Indicators"
	key = "LANGUAGE_INDICATOR"
	enabled_description = "Show"
	disabled_description = "Hide"
