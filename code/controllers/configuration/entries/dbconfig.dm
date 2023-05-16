/datum/config_entry/flag/sql_enabled // for sql switching
	protection = CONFIG_ENTRY_LOCKED

/datum/config_entry/string/sql_server_prefix
	protection = CONFIG_ENTRY_LOCKED

/datum/config_entry/string/sql_unified_prefix
	protection = CONFIG_ENTRY_LOCKED

/datum/config_entry/string/sql_address
	protection = CONFIG_ENTRY_HIDDEN | CONFIG_ENTRY_LOCKED
	config_entry_value = "localhost"

/datum/config_entry/number/sql_port
	protection = CONFIG_ENTRY_HIDDEN | CONFIG_ENTRY_LOCKED
	config_entry_value = 3306

/datum/config_entry/string/sql_user
	protection = CONFIG_ENTRY_HIDDEN | CONFIG_ENTRY_LOCKED

/datum/config_entry/string/sql_password
	protection = CONFIG_ENTRY_HIDDEN | CONFIG_ENTRY_LOCKED

/datum/config_entry/string/sql_database
	protection = CONFIG_ENTRY_HIDDEN | CONFIG_ENTRY_LOCKED

/datum/config_entry/number/query_debug_log_timeout
	config_entry_value = 70
	min_val = 1
	protection = CONFIG_ENTRY_LOCKED
	deprecated_by = /datum/config_entry/number/blocking_query_timeout

/datum/config_entry/number/query_debug_log_timeout/DeprecationUpdate(value)
	return value

/datum/config_entry/number/async_query_timeout
	config_entry_value = 10
	min_val = 0
	protection = CONFIG_ENTRY_LOCKED

/datum/config_entry/number/blocking_query_timeout
	config_entry_value = 5
	min_val = 0
	protection = CONFIG_ENTRY_LOCKED

/datum/config_entry/number/bsql_thread_limit
	config_entry_value = 50
	min_val = 1
