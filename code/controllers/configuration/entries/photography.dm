/**
 * [value]/pic.png is where we serve
 */
/datum/config_entry/string/picture_webroot
	protection = CONFIG_ENTRY_LOCKED

/**
 * [value]/pic.png is where we store
 */
/datum/config_entry/string/picture_storage
	protection = CONFIG_ENTRY_LOCKED

/**
 * is persistent picture system enabled?
 * requires SQL, storage, and webroot.
 */
/datum/config_entry/flag/picture_persistent
	protection = CONFIG_ENTRY_LOCKED
