/datum/config_entry/number/lobby_countdown
	default = 120
	min_val = 0

/datum/config_entry/number/round_end_countdown
	default = 180
	min_val = 0

/datum/config_entry/number/lobby_gamemode_vote_delay
	default = 120
	min_val = -1		//-1 for disabled

/// if the game appears on the hub or not
/datum/config_entry/flag/hub

/datum/config_entry/number/max_hub_pop //At what pop to take hub off the server
	default = 0 //0 means disabled
	integer = TRUE
	min_val = 0
