/datum/config_entry/flag/emergency_tgui_logging
	default = FALSE

/// log messages sent in OOC
/datum/config_entry/flag/log_ooc

/// log login/logout
/datum/config_entry/flag/log_access

/// Config entry which special logging of failed logins under suspicious circumstances.
/datum/config_entry/flag/log_suspicious_login

/// log client say
/datum/config_entry/flag/log_say

/// log admin actions
/datum/config_entry/flag/log_admin
	protection = CONFIG_ENTRY_LOCKED

/// log prayers
/datum/config_entry/flag/log_prayer

/// log silicons
/datum/config_entry/flag/log_silicon

/datum/config_entry/flag/log_law
	deprecated_by = /datum/config_entry/flag/log_silicon

/datum/config_entry/flag/log_law/DeprecationUpdate(value)
	return value

/// log usage of tools
/datum/config_entry/flag/log_tools

/// log game events
/datum/config_entry/flag/log_game

/// log mech data
/datum/config_entry/flag/log_mecha

/// log virology data
/datum/config_entry/flag/log_virus

/// log assets
/datum/config_entry/flag/log_asset

/// log voting
/datum/config_entry/flag/log_vote

/// log client whisper
/datum/config_entry/flag/log_whisper

/// log attack messages
/datum/config_entry/flag/log_attack

/// log emotes
/datum/config_entry/flag/log_emote

/// log economy actions
/datum/config_entry/flag/log_econ

/// log traitor objectives
/datum/config_entry/flag/log_traitor

/// log admin chat messages
/datum/config_entry/flag/log_adminchat
	protection = CONFIG_ENTRY_LOCKED

/// log pda messages
/datum/config_entry/flag/log_pda

/// log uplink/spellbook/codex ciatrix purchases and refunds
/datum/config_entry/flag/log_uplink

/// log telecomms messages
/datum/config_entry/flag/log_telecomms

/// log certain expliotable parrots and other such fun things in a JSON file of twitter valid phrases.
/datum/config_entry/flag/log_twitter

/// log all world.Topic() calls
/datum/config_entry/flag/log_world_topic

/// log crew manifest to separate file
/datum/config_entry/flag/log_manifest

/// log roundstart divide occupations debug information to a file
/datum/config_entry/flag/log_job_debug

/// log shuttle related actions, ie shuttle computers, shuttle manipulator, emergency console
/datum/config_entry/flag/log_shuttle

/// logs all timers in buckets on automatic bucket reset (Useful for timer debugging)
/datum/config_entry/flag/log_timers_on_bucket_reset
