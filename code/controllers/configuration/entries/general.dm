/datum/config_entry/flag/minimaps_enabled
	config_entry_value = TRUE

/datum/config_entry/number/max_bunker_days
	config_entry_value = 7
	min_val = 1

/datum/config_entry/string/invoke_youtubedl
	protection = CONFIG_ENTRY_LOCKED | CONFIG_ENTRY_HIDDEN

/datum/config_entry/number/client_warn_version
	config_entry_value = null
	min_val = 500

/datum/config_entry/number/client_warn_version
	config_entry_value = null
	min_val = 500

/datum/config_entry/string/client_warn_message
	config_entry_value = "Your version of byond may have issues or be blocked from accessing this server in the future."

/datum/config_entry/flag/client_warn_popup

/datum/config_entry/number/client_error_version
	config_entry_value = null
	min_val = 500

/datum/config_entry/string/client_error_message
	config_entry_value = "Your version of byond is too old, may have issues, and is blocked from accessing this server."

/datum/config_entry/number/client_error_build
	config_entry_value = null
	min_val = 0

/datum/config_entry/string/tagline
	config_entry_value = "<br><small><a href='https://discord.gg/citadelstation'>Roleplay focused 18+ server with extensive species choices.</a></small></br>"

/datum/config_entry/number/fps
	default = 20
	integer = FALSE
	min_val = 1
	max_val = 100   //byond will start crapping out at 50, so this is just ridic
	var/sync_validate = FALSE

/datum/config_entry/number/fps/ValidateAndSet(str_val)
	. = ..()
	if(.)
		sync_validate = TRUE
		var/datum/config_entry/number/ticklag/TL = config.entries_by_type[/datum/config_entry/number/ticklag]
		if(!TL.sync_validate)
			TL.ValidateAndSet(10 / config_entry_value)
		sync_validate = FALSE

/datum/config_entry/number/ticklag
	integer = FALSE
	var/sync_validate = FALSE

/datum/config_entry/number/ticklag/New() //ticklag weirdly just mirrors fps
	var/datum/config_entry/CE = /datum/config_entry/number/fps
	default = 10 / initial(CE.default)
	..()

/datum/config_entry/number/ticklag/ValidateAndSet(str_val)
	. = text2num(str_val) > 0 && ..()
	if(.)
		sync_validate = TRUE
		var/datum/config_entry/number/fps/FPS = config.entries_by_type[/datum/config_entry/number/fps]
		if(!FPS.sync_validate)
			FPS.ValidateAndSet(10 / config_entry_value)
		sync_validate = FALSE

/datum/config_entry/number/tick_limit_mc_init //SSinitialization throttling
	default = TICK_LIMIT_MC_INIT_DEFAULT
	min_val = 0 //oranges warned us
	integer = FALSE


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
	if(. && Master.current_runlevel)
		world.sleep_offline = !config_entry_value


/datum/config_entry/flag/log_timers_on_bucket_reset // logs all timers in buckets on automatic bucket reset (Useful for timer debugging)


/datum/config_entry/number/hard_deletes_overrun_threshold
	integer = FALSE
	min_val = 0
	default = 0.5

/datum/config_entry/number/hard_deletes_overrun_limit
	default = 0
	min_val = 0
