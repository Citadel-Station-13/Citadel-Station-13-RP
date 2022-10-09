/// Set to FALSE to disable holidays (you monster)
/datum/config_entry/flag/allow_holidays
	default = TRUE

/datum/config_entry/keyed_list/engine_submap
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_NUM
	lowercase = TRUE

/datum/config_entry/number/starlight
	default = 2

/datum/config_entry/flag/nightshifts_enabled
	default = TRUE

/// Forbids players from joining if they have no set General flavor text.
/datum/config_entry/flag/require_flavor
	default = FALSE

/datum/config_entry/flag/emojis
	default = TRUE



//! ### ALERT LEVELS ### !//

/datum/config_entry/string/alert_desc_green
	default = "All threats to the station have passed. Security may not have weapons visible, privacy laws are once again fully enforced."

/datum/config_entry/string/alert_desc_blue_upto
	default = "The station has received reliable information about possible hostile activity in the local area. Security staff may have weapons visible. Privacy laws are still in effect."

/datum/config_entry/string/alert_desc_blue_downto
	default = "Code Blue procedures are now in effect: The immediate threat has passed. Security staff may not have weapons drawn, but may still have weapons visible. Privacy laws are once again fully enforced."

/datum/config_entry/string/alert_desc_yellow_upto
	default = "The station has confirmed hostile activity in the local area. Security staff may have weapons visible. Random searches are permitted."

/datum/config_entry/string/alert_desc_yellow_downto
	default = "Code Yellow procedures are now in effect: The immediate security threat has been downgraded. Security staff may not have weapons drawn, but may still have weapons visible. Random searches are still permitted."

/datum/config_entry/string/alert_desc_violet_upto
	default = "A major medical emergency has been reported. Medical personnel are required to report to the Medbay immediately. Non-medical personnel are required to obey all relevant instructions from medical staff."

/datum/config_entry/string/alert_desc_violet_downto
	default = "Code Violet procedures are now in effect: Medical personnel are required to report to the Medbay immediately. Non-medical personnel are required to obey all relevant instructions from medical staff."

/datum/config_entry/string/alert_desc_orange_upto
	default = "A major engineering emergency has been reported. Engineering personnel are required to report to the affected area immediately. Non-engineering personnel are required to evacuate any affected areas and obey relevant instructions from engineering staff."

/datum/config_entry/string/alert_desc_orange_downto
	default = "Code Orange procedures are now in effect: Engineering personnel are required to report to the affected area immediately. Non-engineering personnel are required to evacuate any affected areas and obey relevant instructions from engineering staff."

/datum/config_entry/string/alert_desc_red_upto
	default = "There is an immediate serious threat to the station. Security may have weapons unholstered at all times. Random searches are allowed and advised."

/datum/config_entry/string/alert_desc_red_downto
	default = "Code Red procedures are now in effect: The station is no longer under threat of imminent destruction, but there is still an immediate serious threat to the station. Security may have weapons unholstered at all times, random searches are allowed and advised."

/datum/config_entry/string/alert_desc_delta
	default = "The station is under immediate threat of imminent destruction! All crew are instructed to obey all instructions given by heads of staff. Any violations of these orders can be punished by death. This is not a drill."



//! ### PTO ### !//
/// Controls if the 'time off' system is used for determining if players can play 'Off-Duty' jobs (requires SQL).
/datum/config_entry/flag/time_off
	default = TRUE

/// If 'time off' system is on, controls whether or not players can switch on/off duty midround using timeclocks.
/datum/config_entry/flag/pto_job_change
	default = TRUE

/datum/config_entry/number/pto_cap
	default = 100
	min_val = 0



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
	default = 0

/// Affect the movement of robots.
/datum/config_entry/number/robot_delay
	default = 0

/// Affect the movement of animals.
/datum/config_entry/number/animal_delay
	default = 0


//! ## Movement Audio

/**
 * Volume of footstep sound effects.
 * * Range: 1-100, Set to 0 to disable footstep sounds.
 */
/datum/config_entry/number/footstep_volume
	default = 60
	min_val = 0
	max_val = 100



//! ### FETISH CONTENT ### !//

/// If the important_items survive digestion.
/datum/config_entry/flag/items_survive_digestion
	default = FALSE



//! ### MISC ### !//
//? Config options which, of course, don't fit into previous categories.

/// Whether or not humans show an area message when they die.
/datum/config_entry/flag/show_human_death_message
	default = TRUE

/// Enable loyalty implants to spawn on your server.
/datum/config_entry/flag/use_loyalty_implants
	default = FALSE
