//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

// todo: maybe rename to config? or keep it as Configuration to keep with naming scheme of other 'system / backend' modules like the MC?
GLOBAL_REAL(Configuration, /datum/controller/toml_configuration)

// todo: /datum/controller/configuration
// todo: needs stronger vv guarding; it still exposes list refs.
/datum/controller/toml_configuration
	/// Entries by type.
	VAR_PRIVATE/list/datum/toml_config_entry/typed_entries
	/// Entries as same structure as the underlying toml/json
	VAR_PRIVATE/list/datum/toml_config_entry/keyed_entries

	/// TODO: database whitelist when this is stupid
	/// species id = list(ckeys)
	VAR_PRIVATE/list/species_whitelist
	/// TODO: database whitelist when this is stupid
	/// language id = list(ckeys)
	VAR_PRIVATE/list/language_whitelist
	/// TODO: database whitelist when this is stupid
	/// role id = list(ckeys)
	VAR_PRIVATE/list/role_whitelist

/datum/controller/toml_configuration/CanProcCall(procname)
	switch(procname)
		if(NAMEOF_PROC(src, New), NAMEOF_PROC(src, Destroy), NAMEOF_PROC(src, Initialize))
			return FALSE
		if(NAMEOF_PROC(src, get_entry), NAMEOF_PROC(src, set_entry))
			return FALSE
		if(NAMEOF_PROC(src, get_sensitive_entry), NAMEOF_PROC(src, set_sensitive_entry))
			return FALSE
		if(NAMEOF_PROC(src, reload))
			return FALSE
		if(NAMEOF_PROC(src, reset), NAMEOF_PROC(src, load), NAMEOF_PROC(src, load_impl))
			return FALSE
		if(NAMEOF_PROC(src, reset_whitelist), NAMEOF_PROC(src, load_whitelist), NAMEOF_PROC(src, load_whitelist_impl))
			return FALSE
	return ..()

/datum/controller/toml_configuration/vv_edit_var(var_name, var_value, mass_edit, raw_edit)
	switch(var_name)
		if(NAMEOF(src, keyed_entries))
			return FALSE
		if(NAMEOF(src, typed_entries))
			return FALSE
	return ..()

/datum/controller/toml_configuration/New()
	if(Configuration != src)
		if(Configuration)
			qdel(Configuration)
		Configuration = src

/datum/controller/toml_configuration/Initialize()
	keyed_entries = list()
	typed_entries = list()
	for(var/datum/toml_config_entry/path as anything in typesof(/datum/toml_config_entry))
		if(initial(path.abstract_type) == path)
			continue
		var/datum/toml_config_entry/entry = new path
		typed_entries[entry.type] = entry
		var/list/nesting = splittext(entry.category, ".")
		var/list/current_list = keyed_entries
		for(var/i in 1 to length(nesting))
			LAZYINITLIST(current_list[nesting[i]])
			current_list = current_list[nesting[i]]
		current_list[entry.key] = entry
	reload()

/datum/controller/toml_configuration/stat_key()
	return "Configuration (New):"

/datum/controller/toml_configuration/stat_entry()
	return "Edit"

/**
 * HEY! LISTEN! By calling this proc you are affirming that:
 *
 * * The entry type you are passing in is static and not a variable that can be tampered with.
 * * The value you get will be immediately consumed in a non-VV-able manner.
 */
/datum/controller/toml_configuration/proc/get_sensitive_entry(datum/toml_config_entry/entry_type)
	// todo: cache / optimize maybe? would help to store everything in a vv-hidden list.
	var/datum/toml_config_entry/entry = typed_entries[entry_type]
	if(!entry)
		return
	if(!entry.sensitive)
		CRASH("attempted to get sensitive entry with sensitive get entry.")
	return entry.value

/**
 * HEY! LISTEN! By calling this proc you are affirming that:
 *
 * * The entry type you are passing in is static and not a variable that can be tampered with.
 * * The value you are passing in is trusted and validated and not a variable that can be tampered with.
 */
/datum/controller/toml_configuration/proc/set_sensitive_entry(datum/toml_config_entry/entry_type, value)
	// todo: cache / optimize maybe? would help to store everything in a vv-hidden list.
	var/datum/toml_config_entry/entry = typed_entries[entry_type]
	if(!entry)
		return
	if(entry.sensitive)
		CRASH("attempted to set non-sensitive entry with sensitive set entry.")
	entry.value = value

/datum/controller/toml_configuration/proc/get_entry(datum/toml_config_entry/entry_type)
	// todo: cache / optimize maybe? would help to store everything in a vv-hidden list.
	var/datum/toml_config_entry/entry = typed_entries[entry_type]
	if(!entry)
		return
	if(entry.sensitive)
		CRASH("attempted to get sensitive entry with normal get entry.")
	return entry.value

/datum/controller/toml_configuration/proc/set_entry(datum/toml_config_entry/entry_type, value)
	// todo: cache / optimize maybe? would help to store everything in a vv-hidden list.
	var/datum/toml_config_entry/entry = typed_entries[entry_type]
	if(!entry)
		return
	if(entry.sensitive)
		CRASH("attempted to set sensitive entry with normal set entry.")
	entry.value = value

/datum/controller/toml_configuration/proc/admin_reload()
	reload()

/**
 * Automatically loads default config, and the server's config file.
 *
 * todo: allow for overriding directories
 */
/datum/controller/toml_configuration/proc/reload()
	reset()
	load("config.default/config.toml")

	if(fexists("config/config.toml"))
		load("config/config.toml")

	reset_whitelist()
	load_whitelist("config.default/whitelist.toml")

	if(fexists("config/whitelist.toml"))
		load_whitelist("config/whitelist.toml")

/**
 * Resets the configuration.
 */
/datum/controller/toml_configuration/proc/reset()
	for(var/path in typed_entries)
		var/datum/toml_config_entry/entry = typed_entries[path]
		entry.reset()

/**
 * Loads from a given layer.
 * * This will not reset the configuration. Repeated calls to load will allow for layered configuration.
 *
 * HEY! LISTEN! By calling this proc you are affirming that:
 * * The file you are passing in is trusted and not a variable that can be tampered with via VV.
 */
/datum/controller/toml_configuration/proc/load(filelike)
	var/list/decoded
	if(istext(filelike))
		if(!fexists(filelike))
			CRASH("failed to load [filelike]: does not exist")
		decoded = rustg_read_toml_file(filelike)
	else if(isfile(filelike))
		// noa path, it might be rsc cache; rust_g can't read that directly.
		fdel("tmp/config/loading.toml")
		fcopy(filelike, "tmp/config/loading.toml")
		decoded = rustg_read_toml_file("tmp/config/loading.toml")
		fdel("tmp/config/loading.toml")
	if(!decoded)
		CRASH("failed to decode config [filelike]!")

	load_impl(decoded, keyed_entries)

/datum/controller/toml_configuration/proc/load_impl(list/decoded_list, list/entry_list)
	if(!decoded_list || !entry_list)
		return
	for(var/key in decoded_list)
		var/value = decoded_list[key]
		if(islist(value))
			var/list/next_entry_list = entry_list[key]
			if(!islist(next_entry_list))
				// todo: warn
			else
				load_impl(value, next_entry_list[key])
		else
			var/datum/toml_config_entry/entry = entry_list[key]
			if(!istype(entry))
				// todo: warn
			else
				entry.apply(value)

/datum/controller/toml_configuration/proc/reset_whitelist()
	role_whitelist = list()
	species_whitelist = list()
	language_whitelist = list()

/datum/controller/toml_configuration/proc/load_whitelist(filelike)
	var/list/decoded
	if(istext(filelike))
		if(!fexists(filelike))
			CRASH("failed to load [filelike]: does not exist")
		decoded = rustg_read_toml_file(filelike)
	else if(isfile(filelike))
		// noa path, it might be rsc cache; rust_g can't read that directly.
		fdel("tmp/config/loading.toml")
		fcopy(filelike, "tmp/config/loading.toml")
		decoded = rustg_read_toml_file("tmp/config/loading.toml")
		fdel("tmp/config/loading.toml")
	if(!decoded)
		CRASH("failed to decode config [filelike]!")

	load_whitelist_impl(decoded)

/datum/controller/toml_configuration/proc/load_whitelist_impl(list/decoded_list)
	if(!decoded_list)
		return

	var/list/role_whitelist = sanitize_islist(deep_copy_list(decoded_list["whitelist"]?["role"]))
	var/list/language_whitelist = sanitize_islist(deep_copy_list(decoded_list["whitelist"]?["language"]))
	var/list/species_whitelist = sanitize_islist(deep_copy_list(decoded_list["whitelist"]?["species"]))

	// fixup: make everything ckeys
	for(var/list/root_list as anything in list(
		role_whitelist,
		language_whitelist,
		species_whitelist,
	))
		for(var/i in 1 to length(root_list))
			var/id = root_list[i]
			var/list/ckey_list = root_list[id]
			for(var/j in 1 to length(ckey_list))
				ckey_list[j] = ckey(ckey_list[j])

	src.role_whitelist = merge_2_nested_list(src.role_whitelist, role_whitelist)
	src.language_whitelist = merge_2_nested_list(src.language_whitelist, language_whitelist)
	src.species_whitelist = merge_2_nested_list(src.species_whitelist, species_whitelist)

/datum/controller/toml_configuration/proc/check_species_whitelist(id, ckey)
	return ckey(ckey) in species_whitelist[id]

/datum/controller/toml_configuration/proc/check_role_whitelist(id, ckey)
	return ckey(ckey) in role_whitelist[id]

/datum/controller/toml_configuration/proc/check_language_whitelist(id, ckey)
	return ckey(ckey) in language_whitelist[id]

/datum/controller/toml_configuration/proc/get_all_species_whitelists_for_ckey(ckey)
	. = list()
	for(var/id in species_whitelist)
		if(ckey in species_whitelist[id])
			. += id

/datum/controller/toml_configuration/proc/get_all_role_whitelists_for_ckey(ckey)
	. = list()
	for(var/id in role_whitelist)
		if(ckey in role_whitelist[id])
			. += id

/datum/controller/toml_configuration/proc/get_all_language_whitelists_for_ckey(ckey)
	. = list()
	for(var/id in language_whitelist)
		if(ckey in language_whitelist[id])
			. += id
