/datum/controller/subsystem/characters
	/// languages by id
	var/list/language_lookup
	/// languages by path
	var/list/language_paths
	// todo: better way to determine so we have no collisions
	/// language key cache
	var/list/language_keys
	// todo: remove
	/// language by name
	var/list/language_names

/datum/controller/subsystem/characters/proc/rebuild_languages()
	language_lookup = list()
	language_keys = list()
	language_names = list()
	language_paths = list()
	for(var/path in subtypesof(/datum/language))
		var/datum/language/L = path
		if(initial(L.abstract_type) == path)
			continue
		L = new path
		if(language_lookup[L.id])
			stack_trace("duped language id [L.id] on [path] skipped")
			continue
		if(language_names[L.name])
			stack_trace("duped language name [L.name] on [path] skipped")
			continue
		language_lookup[L.id] = L
		language_names[L.name] = L
		language_paths[path] = L
		if(!(L.language_flags & NONGLOBAL))
			language_keys[L.key] = L

	tim_sort(language_names, /proc/cmp_auto_compare, TRUE)
	tim_sort(language_keys, /proc/cmp_auto_compare)
	tim_sort(language_paths, /proc/cmp_auto_compare, TRUE)

/datum/controller/subsystem/characters/proc/resolve_language(id_path_name)
	if(ispath(id_path_name))
		return resolve_language_path(id_path_name)
	return resolve_language_id(id_path_name) || resolve_language_name(id_path_name)

// todo: deprecated
/datum/controller/subsystem/characters/proc/resolve_language_name(name)
	RETURN_TYPE(/datum/language)
	return language_names[name]

/datum/controller/subsystem/characters/proc/resolve_language_id(id)
	RETURN_TYPE(/datum/language)
	return language_lookup[id]

// todo: deprecated
/datum/controller/subsystem/characters/proc/resolve_language_path(path)
	RETURN_TYPE(/datum/language)
	ASSERT(ispath(path, /datum/language))
	return language_paths[path]

/**
 * returns all language datums
 * do NOT modify these unless you know what you are doing!
 */
/datum/controller/subsystem/characters/proc/all_languages()
	RETURN_TYPE(/list)
	. = list()
	for(var/path in language_paths)
		. += language_paths[path]

/**
 * returns all language names
 */
/datum/controller/subsystem/characters/proc/all_language_names()
	RETURN_TYPE(/list)
	. = list()
	for(var/name in language_names)
		. += name

/datum/controller/subsystem/characters/proc/resolve_language_key(key)
	return language_keys[key]
