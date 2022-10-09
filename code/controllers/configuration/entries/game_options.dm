//! ### ALERT LEVELS ### !//

/datum/config_entry/string/alert_desc_green
/datum/config_entry/string/alert_desc_blue_upto
/datum/config_entry/string/alert_desc_blue_downto
/datum/config_entry/string/alert_desc_yellow_upto
/datum/config_entry/string/alert_desc_yellow_downto
/datum/config_entry/string/alert_desc_violet_upto
/datum/config_entry/string/alert_desc_violet_downto
/datum/config_entry/string/alert_desc_orange_upto
/datum/config_entry/string/alert_desc_orange_downto
/datum/config_entry/string/alert_desc_red_upto
/datum/config_entry/string/alert_desc_red_downto
/datum/config_entry/string/alert_desc_delta



//! ### FETISH CONTENT ### !//

/// If the important_items survive digestion.
/datum/config_entry/flag/items_survive_digestion



//! ### GENERAL ### !//

/// Set to FALSE to disable holidays (you monster)
/datum/config_entry/flag/allow_holidays

/datum/config_entry/keyed_list/engine_submap
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_NUM
	lowercase = TRUE

/datum/config_entry/flag/starlight

/datum/config_entry/flag/nightshifts_enabled

/datum/config_entry/flag/emojis



//! ### MISC ### !//
//? Config options which, of course, don't fit into previous categories.

/// Whether or not humans show an area message when they die.
/datum/config_entry/flag/show_human_death_message

/// Enable loyalty implants to spawn on your server.
/datum/config_entry/flag/use_loyalty_implants



//! ### MOB MOVEMENT ### !//
//? To speed things up make the number negative, to slow things down, make the number positive.

//! ## Global Modifiers

/// Modifies the run speed of all mobs before the mob-specific modifiers are applied.
/datum/config_entry/number/run_speed
	default = 2

/// Modifies the walk speed of all mobs before the mob-specific modifiers are applied.
/datum/config_entry/number/walk_speed
	default = 5


//! ## Specific Modifiers

/// Affect the movement of humans.
/datum/config_entry/number/human_delay

/// Affect the movement of robots.
/datum/config_entry/number/robot_delay

/// Affect the movement of animals.
/datum/config_entry/number/animal_delay


//! ## Movement Audio

/**
 * Volume of footstep sound effects.
 * * Range: 1-100, Set to 0 to disable footstep sounds.
 */
/datum/config_entry/number/footstep_volume
	default = 60
	min_val = 0
	max_val = 100



//! ### PLAYER CONFIGS ### !//
/// Forbids players from joining if they have no set General flavor text.
/datum/config_entry/flag/require_flavor



//! ### PTO ### !//
/// Controls if the 'time off' system is used for determining if players can play 'Off-Duty' jobs (requires SQL).
/datum/config_entry/flag/time_off

/// If 'time off' system is on, controls whether or not players can switch on/off duty midround using timeclocks.
/datum/config_entry/flag/pto_job_change

/datum/config_entry/number/pto_cap
	default = 100
	min_val = 0
	max_val = 1000
