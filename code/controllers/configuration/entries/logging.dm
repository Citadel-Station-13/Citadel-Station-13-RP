/// Logs tgui_Topic client calls.
/datum/config_entry/flag/emergency_tgui_logging

/// Log login/logout.
/datum/config_entry/flag/log_access

/// Log admin actions.
/datum/config_entry/flag/log_admin
	protection = CONFIG_ENTRY_LOCKED

/// Log admin chat messages.
/datum/config_entry/flag/log_adminchat
	protection = CONFIG_ENTRY_LOCKED

/// Log assets.
/datum/config_entry/flag/log_asset

/// Log attack messages.
/datum/config_entry/flag/log_attack

/// Log debug output.
/datum/config_entry/flag/log_debug

/// Log economy actions.
// /datum/config_entry/flag/log_econ

/// Log emotes.
/datum/config_entry/flag/log_emote

/// Log game events.
/datum/config_entry/flag/log_game

/// Logs all links clicked in-game/Topic() calls. Could be used for debugging and tracking down exploits.
/datum/config_entry/flag/log_hrefs

/// Log roundstart divide occupations debug information to a file.
// /datum/config_entry/flag/log_job_debug

/// Log crew manifest to separate file.
// /datum/config_entry/flag/log_manifest

/// Log mech data.
// /datum/config_entry/flag/log_mecha

/// Log messages sent in OOC.
/datum/config_entry/flag/log_ooc

/// Log pda messages.
/datum/config_entry/flag/log_pda

/// Log prayers.
// /datum/config_entry/flag/log_prayer

/// Logs world.log to a file.
/datum/config_entry/flag/log_runtime

/// Log client say.
/datum/config_entry/flag/log_say

/// Log shuttle related actions, ie shuttle computers, shuttle manipulator, emergency console.
/datum/config_entry/flag/log_shuttle

/// Log silicons.
// /datum/config_entry/flag/log_silicon

/// Config entry which special logging of failed logins under suspicious circumstances.
/datum/config_entry/flag/log_suspicious_login
	protection = CONFIG_ENTRY_LOCKED

/// Log telecomms messages.
// /datum/config_entry/flag/log_telecomms

/// Logs all timers in buckets on automatic bucket reset. (Useful for timer debugging)
// /datum/config_entry/flag/log_timers_on_bucket_reset

/// Log usage of tools.
// /datum/config_entry/flag/log_tools

/// Logs world.Topic() calls to a file.
/datum/config_entry/flag/log_topic

/// Log traitor objectives.
// /datum/config_entry/flag/log_traitor

/// Log certain expliotable parrots and other such fun things in a JSON file of twitter valid phrases.
// /datum/config_entry/flag/log_twitter

/// Log uplink/spellbook/codex purchases and refunds.
/datum/config_entry/flag/log_uplink

/// Log virology data.
// /datum/config_entry/flag/log_virus

/// Log voting.
/datum/config_entry/flag/log_vote
	protection = CONFIG_ENTRY_LOCKED

/// Log client whisper.
/datum/config_entry/flag/log_whisper

/// This will notify admins and write to a file any time a new player (byond or your server) connects.
/datum/config_entry/flag/paranoia_logging
	protection = CONFIG_ENTRY_LOCKED
