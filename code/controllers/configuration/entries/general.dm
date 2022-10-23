/datum/config_entry/flag/minimaps_enabled
	default = TRUE

/datum/config_entry/number/max_bunker_days
	default = 7
	min_val = 1

/datum/config_entry/string/invoke_youtubedl
	protection = CONFIG_ENTRY_LOCKED | CONFIG_ENTRY_HIDDEN

/datum/config_entry/number/client_warn_version
	default = null
	min_val = 500

/datum/config_entry/number/client_warn_version
	default = null
	min_val = 500

/datum/config_entry/string/client_warn_message
	default = "Your version of byond may have issues or be blocked from accessing this server in the future."

/datum/config_entry/flag/client_warn_popup

/datum/config_entry/number/client_error_version
	default = null
	min_val = 500

/datum/config_entry/string/client_error_message
	default = "Your version of byond is too old, may have issues, and is blocked from accessing this server."

/datum/config_entry/number/client_error_build
	default = null
	min_val = 0

/datum/config_entry/string/community_shortname

/datum/config_entry/string/community_link

/datum/config_entry/string/tagline
	default = "<br><small><a href='https://discord.gg/citadelstation'>Roleplay focused 18+ server with extensive species choices.</a></small></br>"

/datum/config_entry/flag/usetaglinestrings

/datum/config_entry/flag/cache_assets
	default = TRUE

/datum/config_entry/flag/show_irc_name

/// allows admins with relevant permissions to have their own ooc colour
/datum/config_entry/flag/allow_admin_ooccolor
	default = TRUE
