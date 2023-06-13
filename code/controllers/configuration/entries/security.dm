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

//* Age Verification System - requires DB *//

/datum/config_entry/flag/age_verification //are we using the automated age verification which asks users if they're 18+?

/datum/config_entry/flag/age_verification_autoban

//* Miscellaneous Security Checks *//

// todo: implement
/// Check for CID Randomizers
/datum/config_entry/flag/check_cid_randomizer

//* Panic Bunker - requires DB *//

/// Full panic bunker - people who have never connected/played before get bounced off
/datum/config_entry/flag/panic_bunker

/// Partial panic bunker - Only apply panic_bunker to detected VPNs from IPIntel
/datum/config_entry/flag/vpn_bunker

/// Instead of "connected successfully at all", we check for playtime if this is set. 0 to disable.
/datum/config_entry/number/panic_bunker_playtime

/// Message shown to players who try to connect during panic bunker.
/datum/config_entry/string/panic_bunker_message
	default = "Sorry but the server is currently not accepting connections from never before seen players."
