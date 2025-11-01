
//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * All bitfield datums
 */
GLOBAL_LIST(bitfields)
/**
 * All bitfield datums by path
 */
GLOBAL_LIST(bitfields_by_path)
/**
 * All bitfield datums by var name
 */
GLOBAL_LIST(bitfields_by_var)

// TODO: why don't we just tgui picker bitfields so we don't need to do insane lookups?
/proc/init_bitfield_meta()
	// TODO: GLOBAL_ALIST
	var/list/bitfields = list()
	var/list/bitfield_by_path = list()
	var/list/bitfield_by_var = list()

	for(var/datum/bitfield/path as anything in subtypesof(/datum/bitfield))
		if(path.abstract_type == path)
			continue
		var/datum/bitfield/instance = new path
		bitfields += instance
	// add legacy shit
	var/list/legacy_bitfields = generate_bitfields()
	for(var/var_name in legacy_bitfields)
		var/list/reverse_lookup = legacy_bitfields[var_name]
		var/datum/bitfield/legacy_instance = new
		for(var/name in reverse_lookup)
			var/bit = reverse_lookup[name]
			legacy_instance.flags[bit] = name
		legacy_instance.paths += /datum
		bitfields += legacy_instance
	for(var/datum/bitfield/bitfield as anything in bitfields)
		for(var/path in bitfield.paths)
			if(!bitfield_by_path[path])
				bitfield_by_path[path] = list(bitfield)
			else
				bitfield_by_path[path] += bitfield
			for(var/name in bitfield.paths[path])
				if(!bitfield_by_var[name])
					bitfield_by_var[name] = list(bitfield)
				else
					bitfield_by_var[name] += bitfield
	GLOB.bitfields = bitfields
	GLOB.bitfields_by_path = bitfield_by_path
	GLOB.bitfields_by_var = bitfield_by_var

/**
 * @return alist(var_name = alist(bit = string), ...); do not modify
 */
/proc/fetch_all_bitfield_mappings(datum/path)
	if(!ispath(path))
		return list()
	. = list()
	do
		var/list/maybe_bitfields = GLOB.bitfields_by_path[path]
		if(maybe_bitfields)
			for(var/datum/bitfield/bitfield as anything in maybe_bitfields)
				for(var/var_name in bitfield.paths[path])
					.[var_name] = bitfield.flags
		path = path.parent_type
	while(path)

/proc/fetch_all_bitfields(datum/path)
	if(!ispath(path))
		return list()
	. = list()
	do
		var/list/maybe_bitfields = GLOB.bitfields_by_path[path]
		if(maybe_bitfields)
			. += maybe_bitfields
		path = path.parent_type
	while(path)

/**
 * @return alist(bit = string); null if none; do not modify
 */
/proc/fetch_bitfield_mappings(datum/path, var_name) as /alist
	return fetch_bitfield(path, var_name).flags

/proc/fetch_bitfield(datum/path, var_name) as /datum/bitfield
	for(var/datum/bitfield/bitfield as anything in GLOB.bitfields_by_var[var_name])
		if(path in bitfield.paths)
			return bitfield

/**
 * A bitfield define. Keep these close to the #define's which specify them.
 */
/datum/bitfield
	abstract_type = /datum/bitfield
	/// bit = name
	var/alist/flags = alist()
	/// typepaths this is valid on associated to variable or list of variables
	var/alist/paths = alist()
