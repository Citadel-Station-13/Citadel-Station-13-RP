//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Config entry.
 *
 * Supports at time of writing:
 * * numbers
 * * strings
 * * (nested) lists
 * * (nested) dictionaries
 *
 * Supports at time of writing auditing VV edits to:
 * * numbers
 * * strings
 */
/datum/toml_config_entry
	abstract_type = /datum/toml_config_entry
	/// key / name
	var/key
	/// category / where this is
	var/category

	/// description of this entry
	var/desc

	/// default value
	var/default
	/// current value
	var/value

	/// vv edit disallowed
	var/vv_locked = FALSE
	/// vv read disallowed
	/// * does not automatically imply [vv_locked]
	var/vv_secret = FALSE
	/// sensitive
	/// * requires get_sensitive_entry() and set_sensitive_entry() to read/write
	/// * does not actually imply [vv_locked] and [vv_secret]
	var/sensitive = FALSE

#warn impl
