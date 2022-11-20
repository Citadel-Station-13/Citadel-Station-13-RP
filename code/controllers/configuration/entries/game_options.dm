/datum/config_entry/string/max_viewport_size
	default = "19x15"

/datum/config_entry/string/max_viewport_size/ValidateAndSet(str_val)
	if(!istext(str_val))
		return FALSE
	var/list/split = splittext(str_val, "x")
	if(length(split) != 2)
		return FALSE
	var/width = text2num(split[1])
	var/height = text2num(split[2])
	if(height < 1 || width < 1 || height > 67 || width > 67)
		return FALSE
	. = ..()
	if(!.)
		return
	config.update_player_viewsize()

/*
/datum/config_entry/string/game_viewport_size
	default = "19x15"

/datum/config_entry/string/max_viewport_size/ValidateAndSet(str_val)
	. = ..()
*/
//! BYONd world.view is immutable, this config is left here as a todo. If it's still immutable by, say, 516, remove it.

/datum/config_entry/number/starlight
	default = 2

/datum/config_entry/keyed_list/engine_submap
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_NUM
	lowercase = TRUE

/// Set to FALSE to disable holidays (you monster)
/datum/config_entry/flag/allow_holidays
	default = TRUE

/datum/config_entry/flag/nightshifts_enabled
	default = TRUE

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

/datum/config_entry/flag/emojis
	default = TRUE
