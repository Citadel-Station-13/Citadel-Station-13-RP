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

/datum/config_entry/number/mc_tick_rate/base_mc_tick_rate
	integer = FALSE
	default = 1

/datum/config_entry/number/mc_tick_rate/high_pop_mc_tick_rate
	integer = FALSE
	default = 1.1

/datum/config_entry/number/mc_tick_rate/high_pop_mc_mode_amount
	default = 65

/datum/config_entry/number/mc_tick_rate/disable_high_pop_mc_mode_amount
	default = 60

/datum/config_entry/number/mc_tick_rate
	abstract_type = /datum/config_entry/number/mc_tick_rate

/datum/config_entry/number/mc_tick_rate/ValidateAndSet(str_val)
	. = ..()
	if (.)
		Master.UpdateTickRate()

/datum/config_entry/flag/resume_after_initializations

/datum/config_entry/flag/resume_after_initializations/ValidateAndSet(str_val)
	. = ..()
	if(. && MC_RUNNING())
		world.sleep_offline = !config_entry_value

/datum/config_entry/number/drift_dump_threshold
	default = 4 SECONDS

/datum/config_entry/number/drift_profile_delay
	default = 15 SECONDS
