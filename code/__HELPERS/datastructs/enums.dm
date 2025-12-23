
//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * All enum datums
 */
GLOBAL_LIST(enums)
/**
 * All enum datums by path
 */
GLOBAL_LIST(enums_by_path)
/**
 * All enum datums by var name
 */
GLOBAL_LIST(enums_by_var)

// TODO: why don't we just tgui picker enums so we don't need to do insane lookups?
/proc/init_enum_meta()
	// TODO: GLOBAL_ALIST
	var/list/enums = list()
	var/list/enum_by_path = list()
	var/list/enum_by_var = list()

	for(var/datum/enum/path as anything in subtypesof(/datum/enum))
		if(path.abstract_type == path)
			continue
		var/datum/enum/instance = new path
		enums += instance
	for(var/datum/enum/enum as anything in enums)
		for(var/path in enum.paths)
			if(!enum_by_path[path])
				enum_by_path[path] = list(enum)
			else
				enum_by_path[path] += enum
			var/list/name_or_names = enum.paths[path]
			if(islist(name_or_names))
				for(var/name in name_or_names)
					if(!enum_by_var[name])
						enum_by_var[name] = list(enum)
					else
						enum_by_var[name] += enum
			else if(name_or_names)
				if(!enum_by_var[name_or_names])
					enum_by_var[name_or_names] = list(enum)
				else
					enum_by_var[name_or_names] += enum
			else
				STACK_TRACE("Bitfield [enum.type] ([json_encode(enum.names)]) had no var name on path [path]")

	GLOB.enums = enums
	GLOB.enums_by_path = enum_by_path
	GLOB.enums_by_var = enum_by_var

#if DM_VERSION > 516
	#error remove the guards on path == /datum; byond will have fixed the crash bug by now
#endif

/proc/fetch_all_enums(datum/path)
	. = list()
	do
		var/list/maybe_enums = GLOB.enums_by_path[path]
		if(maybe_enums)
			. += maybe_enums
		if(path == /datum)
			break
		path = path.parent_type
	while(path)

/proc/fetch_enum(datum/path, var_name) as /datum/enum
	if(istype(path))
		path = path.type
	for(var/datum/enum/enum as anything in GLOB.enums_by_var[var_name])
		for(var/match in enum.paths)
			if(ispath(path, match))
				return enum

/**
 * Bitfield datums used to reflect enum values in the game's code.
 */
/datum/enum
	abstract_type = /datum/enum
	/// typepaths this is valid on associated to variable or list of variables
	var/list/paths = list()
	var/list/enums
	var/list/names

/datum/enum/New()
	var/list/constants = get_enum_constants()
	enums = list()
	names = list()
	for(var/name in constants)
		var/enum = constants[name]
		enums += enum
		names += name

/datum/enum/proc/get_enum_name(enum)
	. = enums.Find(enum)
	return . ? names[.] : null

/datum/enum/proc/get_enum(name)
	. = names.Find(name)
	return . ? enums[.] : null

/**
 * This is NOT necessarily the number of enums in the enum. This is only how many of them
 * were declared in ourselves. Please be careful when using this;
 */
/datum/enum/proc/get_declared_count()
	return length(enums)

/**
 * @return list(NAME = ENUM, ...)
 */
/datum/enum/proc/get_enum_constants()
	return list()
