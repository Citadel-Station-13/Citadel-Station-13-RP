
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
			legacy_instance.names += name
			legacy_instance.bits += bit
		legacy_instance.paths = list((/datum) = var_name)
		bitfields += legacy_instance
	for(var/datum/bitfield/bitfield as anything in bitfields)
		for(var/path in bitfield.paths)
			if(!bitfield_by_path[path])
				bitfield_by_path[path] = list(bitfield)
			else
				bitfield_by_path[path] += bitfield
			var/list/name_or_names = bitfield.paths[path]
			if(islist(name_or_names))
				for(var/name in name_or_names)
					if(!bitfield_by_var[name])
						bitfield_by_var[name] = list(bitfield)
					else
						bitfield_by_var[name] += bitfield
			else if(name_or_names)
				if(!bitfield_by_var[name_or_names])
					bitfield_by_var[name_or_names] = list(bitfield)
				else
					bitfield_by_var[name_or_names] += bitfield
			else
				STACK_TRACE("Bitfield [bitfield.type] ([json_encode(bitfield.names)]) had no var name on path [path]")

	GLOB.bitfields = bitfields
	GLOB.bitfields_by_path = bitfield_by_path
	GLOB.bitfields_by_var = bitfield_by_var

#if DM_VERSION > 516
	#error remove the guards on path == /datum; byond will have fixed the crash bug by now
#endif

/proc/fetch_all_bitfields(datum/path)
	. = list()
	do
		var/list/maybe_bitfields = GLOB.bitfields_by_path[path]
		if(maybe_bitfields)
			. += maybe_bitfields
		if(path == /datum)
			break
		path = path.parent_type
	while(path)

/proc/fetch_bitfield(datum/path, var_name) as /datum/bitfield
	if(istype(path))
		path = path.type
	for(var/datum/bitfield/bitfield as anything in GLOB.bitfields_by_var[var_name])
		for(var/match in bitfield.paths)
			if(ispath(path, match))
				return bitfield

/**
 * Bitfield datums used to reflect bitfield values in the game's code.
 */
/datum/bitfield
	abstract_type = /datum/bitfield
	/// typepaths this is valid on associated to variable or list of variables
	var/list/paths = list()
	var/list/bits
	var/list/names

/datum/bitfield/New()
	var/list/constants = get_bit_constants()
	bits = list()
	names = list()
	for(var/name in constants)
		var/bit = constants[name]
		bits += bit
		names += name

/datum/bitfield/proc/get_bit_name(bit)
	. = bits.Find(bit)
	return . ? names[.] : null

/datum/bitfield/proc/get_bit(name)
	. = names.Find(name)
	return . ? bits[.] : null

/**
 * This is NOT necessarily the number of bits in the bitfield. This is only how many of them
 * were declared in ourselves. Please be careful when using this;
 */
/datum/bitfield/proc/get_declared_count()
	return length(bits)

/**
 * @return list(NAME = BIT, ...)
 */
/datum/bitfield/proc/get_bit_constants()
	return list()
