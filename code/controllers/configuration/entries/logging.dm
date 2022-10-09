/// This will notify admins and write to a file any time a new player (byond or your server) connects.
/datum/config_entry/flag/paranoia_logging

/// Logs tgui_Topic client calls.
/datum/config_entry/flag/emergency_tgui_logging
	default = FALSE

/// Log messages sent in OOC.
/datum/config_entry/flag/log_ooc

/// Log login/logout.
/datum/config_entry/flag/log_access

/// Config entry which special logging of failed logins under suspicious circumstances.
/datum/config_entry/flag/log_suspicious_login

/// Log client say.
/datum/config_entry/flag/log_say

/// Log admin actions.
/datum/config_entry/flag/log_admin
	protection = CONFIG_ENTRY_LOCKED

/// Log debug output.
/datum/config_entry/flag/log_debug

/// Log prayers.
/datum/config_entry/flag/log_prayer

/// Log silicons.
/datum/config_entry/flag/log_silicon

/datum/config_entry/flag/log_law
	deprecated_by = /datum/config_entry/flag/log_silicon

/datum/config_entry/flag/log_law/DeprecationUpdate(value)
	return value

/// Log usage of tools.
/datum/config_entry/flag/log_tools

/// Log game events.
/datum/config_entry/flag/log_game

/// Log mech data.
/datum/config_entry/flag/log_mecha

/// Log virology data.
/datum/config_entry/flag/log_virus

/// Log assets.
/datum/config_entry/flag/log_asset

/// Log voting.
/datum/config_entry/flag/log_vote

/// Log client whisper.
/datum/config_entry/flag/log_whisper

/// Log attack messages.
/datum/config_entry/flag/log_attack

/// Log emotes.
/datum/config_entry/flag/log_emote

/// Log economy actions.
/datum/config_entry/flag/log_econ

/// Log traitor objectives.
/datum/config_entry/flag/log_traitor

/// Log admin chat messages.
/datum/config_entry/flag/log_adminchat
	protection = CONFIG_ENTRY_LOCKED

/// Log pda messages.
/datum/config_entry/flag/log_pda

/// Log uplink/spellbook/codex ciatrix purchases and refunds.
/datum/config_entry/flag/log_uplink

/// Log telecomms messages.
/datum/config_entry/flag/log_telecomms

/// Log certain expliotable parrots and other such fun things in a JSON file of twitter valid phrases.
/datum/config_entry/flag/log_twitter

/// Log all world.Topic() calls.
/datum/config_entry/flag/log_world_topic

/// Log crew manifest to separate file.
/datum/config_entry/flag/log_manifest

/// Log roundstart divide occupations debug information to a file.
/datum/config_entry/flag/log_job_debug

/// Log shuttle related actions, ie shuttle computers, shuttle manipulator, emergency console.
/datum/config_entry/flag/log_shuttle

/// Logs all timers in buckets on automatic bucket reset. (Useful for timer debugging)
/datum/config_entry/flag/log_timers_on_bucket_reset

/// Logs all links clicked in-game/Topic() calls. Could be used for debugging and tracking down exploits.
/datum/config_entry/flag/log_hrefs

/// Logs world.log to a file.
/datum/config_entry/flag/log_runtime

/// Logs world.Topic() calls to a file.
/datum/config_entry/flag/log_topic
