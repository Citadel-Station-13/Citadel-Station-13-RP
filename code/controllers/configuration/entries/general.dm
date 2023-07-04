/datum/config_entry/flag/minimaps_enabled
	default = TRUE

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

/datum/config_entry/flag/cache_assets
	default = TRUE

/// allows admins with relevant permissions to have their own ooc colour
/datum/config_entry/flag/allow_admin_ooccolor
	default = TRUE

/datum/config_entry/number/rounds_until_hard_restart
	default = -1
	min_val = 0

/// Enable or disable the toast notification when the the instance finishes initializing.
/datum/config_entry/flag/toast_notification_on_init
