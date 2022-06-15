/// enables picture store - REQUIRES SQL AND A WEB SERVER.

/// picture data SQL table
/datum/config_entry/string/picture_store_dbtable
	config_entry_value = "picture_store"

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

