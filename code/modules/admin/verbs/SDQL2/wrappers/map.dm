//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

// * Mapping Functions * //

/// These are not super optimized, but work fine enough; using them outside of SDQL is allowed,
/// These are usually typechecked, and will silently remove invalid inputs. Keep that in mind.

//* Deduping *//

/proc/sdql_list_dedupe(list/L)
	. = list()
	for(var/thing in L)
		. |= thing

//* Type filtering *//

/**
 * datums only
 */
/proc/sdql_typecache_filter(list/datum/things, list/typecache)
	. = list()
	for(var/datum/thing as anything in things)
		if(!isdatum(thing) || !typecache[thing.type])
			continue
		. += thing

/**
 * datums only
 */
/proc/sdql_typecache_filter_exclude(list/datum/things, list/typecache)
	. = list()
	for(var/datum/thing as anything in things)
		if(!isdatum(thing) || typecache[thing.type])
			continue
		. += thing

/**
 * datums only
 */
/proc/sdql_type_filter(list/datum/things, type)
	. = list()
	for(var/datum/thing as anything in things)
		if(!istype(thing, type))
			continue
		. += thing

/**
 * datums only
 */
/proc/sdql_type_filter_exclude(list/datum/things, type)
	. = list()
	for(var/datum/thing as anything in things)
		if(!isdatum(thing) || istype(thing, type))
			continue
		. += thing

//* Turfs to contents *//

/**
 * this will **not** dupe filter
 */
/proc/sdql_turfs_to_contents(list/turf/turfs, forbid_atom_flags, any_atom_flags, all_atom_flags)
	. = list()
	// i wish byond would compiler optimize this
	// but silicons, for once, will not write a hand-optimized 500 line monstrosity
	for(var/turf/T in turfs)
		for(var/atom/movable/AM as anything in T.contents)
			if(forbid_atom_flags && (AM.atom_flags & forbid_atom_flags))
				continue
			if(any_atom_flags && !(AM.atom_flags & any_atom_flags))
				continue
			if(all_atom_flags && ((AM.atom_flags & all_atom_flags) != all_atom_flags))
				continue
			. += AM

/**
 * ignores NONWORLD and ABSTRACT mobs
 */
/proc/sdql_turfs_to_game_mobs(list/turf/turfs)
	. = list()
	for(var/turf/T in turfs)
		for(var/mob/M in T)
			if(M.atom_flags & (ATOM_NONWORLD | ATOM_ABSTRACT))
				continue
			. += M

/**
 * ignores NONWORLD and ABSTRACT objs
 *
 * * warning: /atom/movables may or may not be objs. blame byond.
 */
/proc/sdql_turfs_to_game_objs(list/turf/turfs)
	. = list()
	for(var/turf/T in turfs)
		for(var/obj/O in T)
			if(O.atom_flags & (ATOM_NONWORLD | ATOM_ABSTRACT))
				continue
			. += O

//* Movables to loc *//

/proc/sdql_movable_to_loc(list/atom/movable/movables, allow_dupe = FALSE, allow_null = FALSE)
	. = list()
	if(allow_dupe)
		if(allow_null)
			for(var/atom/movable/AM in movables)
				. += AM.loc
		else
			for(var/atom/movable/AM in movables)
				if(!AM.loc)
					continue
				. += AM.loc
	else
		if(allow_null)
			for(var/atom/movable/AM in movables)
				. |= AM.loc
		else
			for(var/atom/movable/AM in movables)
				if(!AM.loc)
					continue
				. |= AM.loc

/proc/sdql_movable_to_on_turf(list/atom/movable/movables, allow_dupe = FALSE)
	. = list()
	if(allow_dupe)
		for(var/atom/movable/AM in movables)
			if(!isturf(AM.loc))
				continue
			. += AM.loc
	else
		for(var/atom/movable/AM in movables)
			if(!isturf(AM.loc))
				continue
			. |= AM.loc

/proc/sdql_movable_to_get_turf(list/atom/movable/movables, allow_dupe = FALSE, allow_null = FALSE)
	. = list()
	for(var/atom/movable/AM in movables)
		var/turf/location = get_turf(AM)
		if(!allow_null && !location)
			continue
		if(allow_dupe)
			. += location
		else
			. |= location

//* spatial query / ranging *//

/proc/sdql_atoms_to_turfs_in_range(list/atom/movables, radius = 0, allow_dupe = FALSE)
	. = list()
	var/safety = 100000 // a bit more than 1MB
	var/list/results
	if(allow_dupe)
		for(var/atom/A in movables)
			results = range(radius, A)
			if(!length(results))
				continue
			. += results
			if(length(.) > safety)
				stack_trace("hit safety limit")
				break
	else
		var/list/hashed = list()
		for(var/atom/A in movables)
			results = range(radius, A)
			if(!length(results))
				continue
			for(var/turf/T as anything in results)
				hashed[T] = TRUE
			if(length(hashed) > safety) // a bit more than 3MB due to assoclist...
				stack_trace("hit safety limit")
				break
		// we want a flat list
		for(var/key in hashed)
			. += key

// todo: in view
// todo: in dview
