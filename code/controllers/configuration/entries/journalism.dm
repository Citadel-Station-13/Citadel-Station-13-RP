/// enables picture store - REQUIRES SQL AND A WEB SERVER.
/datum/config_flag/flag/picture_store

#warn for both picture and newscaster, cache the table names

/// picture data SQL table
/datum/config_entry/string/picture_store_dbtable
	config_entry_value = "pictures"

/// picture data SQL table - should we use unified prefix?
/datum/config_entry/flag/picture_store_dbtable_unified
	config_entry_value = TRUE

/// folder to save pictures to. no / at end
/datum/config_entry/string/picture_store_webroot
	config_entry_value = "data/picture_store"

/datum/config_entry/string/picture_store_webroot/ValidateAndSet(str_val, during_load)
	. = ..()
	if(copytext(config_entry_value, config_entry_value.len, config_entry_value.len + 1) == "/")
		config_entry_value = copytext(config_entry_value, 1, config_entry_value.len)

/// url root to fetch picture .pngs from. no / at end.
/datum/config_entry/string/picture_store_url

/datum/config_entry/string/picture_store_url/ValidateAndSet(str_val, during_load)
	. = ..()
	if(copytext(config_entry_value, config_entry_value.len, config_entry_value.len + 1) == "/")
		config_entry_value = copytext(config_entry_value, 1, config_entry_value.len)

/// enables newscasters - REQUIRES SQL AND A WEB SERVER
/datum/config_entry/flag/newscasters_enabled

/// newscasters table prefix - will be appended with "channels", "posts", "networks", "comments"
/datum/config_entry/string/newscaster_dbtable_prefix
	config_entry_value = "newscaster"

/// newscasters table name - should we use unified prefix?
/datum/config_entry/string/newscaster_dbtable_use_unified
	config_entry_value = FALSE
