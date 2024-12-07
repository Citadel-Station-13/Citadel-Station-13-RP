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
	/// * Does not stop get_entry and set_entry from setting our value. Those are not considered vv-protected.
	var/vv_locked = FALSE
	/// vv read disallowed
	/// * Does not automatically imply [vv_locked].
	/// * Does not stop get_entry and set_entry from pulling our value. Those are not considered vv-protected.
	var/vv_secret = FALSE
	/// sensitive
	/// * Requires get_sensitive_entry() and set_sensitive_entry() to read/write.
	/// * Does not actually imply [vv_locked] and [vv_secret].
	var/sensitive = FALSE

/datum/toml_config_entry/vv_edit_var(var_name, var_value, mass_edit, raw_edit)
	switch(var_name)
		if(NAMEOF(src, default))
			return FALSE
		if(NAMEOF(src, value))
			if(vv_locked)
				return FALSE
		if(NAMEOF(src, key))
			return FALSE
		if(NAMEOF(src, category))
			return FALSE
		if(NAMEOF(src, desc))
			return FALSE
		if(NAMEOF(src, vv_locked))
			return FALSE
		if(NAMEOF(src, vv_secret))
			return FALSE
		if(NAMEOF(src, sensitive))
			return FALSE
	return ..()

/datum/toml_config_entry/vv_get_var(var_name, resolve)
	switch(var_name)
		if(NAMEOF(src, value))
			if(vv_locked)
				return "-- secret --"
	return ..()

/datum/toml_config_entry/CanProcCall(procname)
	switch(procname)
		if(NAMEOF_PROC(src, New), NAMEOF_PROC(src, Destroy))
			return FALSE
		if(NAMEOF_PROC(src, reset))
			return FALSE
		if(NAMEOF_PROC(src, apply))
			return FALSE
	return ..()

/datum/toml_config_entry/vv_delete()
	return FALSE

/**
 * Called once when resetting.
 */
/datum/toml_config_entry/proc/reset()
	if(isnum(default))
		value = default
	else if(istext(default))
		value = default
	else if(islist(default))
		value = deep_copy_list(default)
	else
		CRASH("unexpected value in default.")

/**
 * Called once with the value from each load.
 *
 * Can be used to overlay values.
 *
 * @params
 * * raw_config_value - Raw parsed data. We own the reference to this once this proc is called.
 */
/datum/toml_config_entry/proc/apply(raw_config_value)
	value = raw_config_value
