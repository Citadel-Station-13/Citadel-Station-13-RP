//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

GLOBAL_DATUM(toml_config, /datum/toml_config)

/datum/toml_config
	/// Entries by type.
	VAR_PRIVATE/list/datum/toml_config_entry/keyed_entries
/**
 * HEY! LISTEN! By calling this proc you are affirming that:
 *
 * * The entry type you are passing in is static and not a variable that can be tampered with.
 * * The value you get will be immediately consumed in a non-VV-able manner.
 */
/datum/toml_config/proc/get_sensitive_entry(datum/toml_config_entry/entry_type)

/**
 * HEY! LISTEN! By calling this proc you are affirming that:
 *
 * * The entry type you are passing in is static and not a variable that can be tampered with.
 * * The value you are passing in is trusted and validated and not a variable that can be tampered with.
 */
/datum/toml_config/proc/set_sensitive_entry(datum/toml_config_entry/entry_type, value)

/datum/toml_config/proc/get_entry(datum/toml_config_entry/entry_type)

/datum/toml_config/proc/set_entry(datum/toml_config_entry/entry_type, value)

/**
 * Automatically loads default config, and the server's config file.
 */
/datum/toml_config/proc/reload()
	reset()
	load("config.default/config.toml")
	load("config/config.toml")

/**
 * Resets the configuration.
 */
/datum/toml_config/proc/reset()

/**
 * Loads from a given layer.
 * * This will not reset the configuration. Repeated calls to load will allow for layered configuration.
 *
 * HEY! LISTEN! By calling this proc you are affirming that:
 * * The file you are passing in is trusted and not a variable that can be tampered with via VV.
 */
/datum/toml_config/proc/load(filelike)

#warn impl
