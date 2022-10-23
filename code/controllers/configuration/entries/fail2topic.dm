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
