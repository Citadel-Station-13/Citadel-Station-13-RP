//* Fail2Topic - Topic DoS Guard System *//

/datum/config_entry/number/fail2topic_rate_limit
	default = 10 //Deciseconds

/datum/config_entry/number/fail2topic_max_fails
	default = 5

/datum/config_entry/string/fail2topic_rule_name
	default = "_dd_fail2topic"
	protection = CONFIG_ENTRY_LOCKED //Affects physical server configuration, no touchies!!

/datum/config_entry/flag/fail2topic_enabled
	default = TRUE

/datum/config_entry/number/topic_max_size
	default = 1048576

/datum/config_entry/keyed_list/topic_rate_limit_whitelist
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_FLAG

//* IPIntel - VPN Intelligence System *//

/datum/config_entry/string/ipintel_email

/datum/config_entry/string/ipintel_email/ValidateAndSet(str_val)
	return str_val != "ch@nge.me" && ..()

/datum/config_entry/number/ipintel_rating_bad
	config_entry_value = 1
	integer = FALSE
	min_val = 0
	max_val = 1

/datum/config_entry/number/ipintel_save_good
	config_entry_value = 12
	min_val = 0

/datum/config_entry/number/ipintel_save_bad
	config_entry_value = 1
	min_val = 0

/datum/config_entry/string/ipintel_domain
	config_entry_value = "check.getipintel.net"

//* Age Verification System *//

/datum/config_entry/flag/age_verification //are we using the automated age verification which asks users if they're 18+?

/datum/config_entry/flag/age_verification_autoban

//* Miscellaneous Security Checks *//

// todo: implement
/// Check for CID Randomizers
/datum/config_entry/flag/check_cid_randomizer




/datum/config_entry/flag/panic_bunker	// prevents people the server hasn't seen before from connecting

/datum/config_entry/number/panic_bunker_living // living time in minutes that a player needs to pass the panic bunker. they pass **if they are above this amount**
	config_entry_value = 0		// default: <= 0 meaning any playtime works. -1 to disable criteria.
	integer = TRUE

/datum/config_entry/number/panic_bunker_living_vpn
	config_entry_value = 0		// default: <= 0 meaning anytime works. -1 to disable criteria.
	integer = TRUE

/datum/config_entry/string/panic_bunker_message
	config_entry_value = "Sorry but the server is currently not accepting connections from never before seen players."

/datum/config_entry/string/panic_server_name

/datum/config_entry/string/panic_server_name/ValidateAndSet(str_val)
	return str_val != "\[Put the name here\]" && ..()

/datum/config_entry/string/panic_server_address	//Reconnect a player this linked server if this server isn't accepting new players

/datum/config_entry/string/panic_server_address/ValidateAndSet(str_val)
	return str_val != "byond://address:port" && ..()

/datum/config_entry/number/max_bunker_days
	config_entry_value = 7
	min_val = 1

/datum/config_entry/number/notify_new_player_age	// how long do we notify admins of a new player
	min_val = -1

/datum/config_entry/number/notify_new_player_account_age	// how long do we notify admins of a new byond account
	min_val = 0
