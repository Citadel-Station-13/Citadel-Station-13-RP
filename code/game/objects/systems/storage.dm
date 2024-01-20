//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * storage systems
 *
 * can be /physical, or /virtual
 *
 * stores /item's
 */
/datum/object_system/storage

	//* Filters

	/// protected var because we want to cache.
	/// set to a list of typepaths to initialize it at New().
	/// * things in this list are the only things that can fit in us
	/// * overruled by blacklist
	/// * Never, ever edit this list directly.
	VAR_PROTECTED/list/insertion_whitelist_typecache
	/// protected var because we want to cache.
	/// set to a list of typepaths to initialize it at New().
	/// * things in this list can never fit in us, even if in whitelist
	/// * Never, ever edit this list directly.
	VAR_PROTECTED/list/insertion_blacklist_typecache
	/// protected var because we want to cache.
	/// set to a list of typepaths to initialize it at New().
	/// * in whitelist mode, things in this list can also be put in
	/// * in blacklist mode, things in this list can always be put in regardless
	/// * overrules both whitelist and blacklist
	/// * Never, ever edit this list directly.
	/// this is so overriding things can be easier.
	VAR_PROTECTED/list/insertion_allow_typecache

	//* Limits

	/// if set, limit to a certain volume
	var/max_combined_volume
	/// if set, allow only a certain amount of items
	var/max_items
	/// if set, max weight class we can hold
	var/max_single_weight_class
	/// if set, max combined weight class of all containing items we can hold
	var/max_combined_weight_class

	//* State

	/// cached combined w class
	var/tmp/cached_combined_weight_class
	/// cached combined volume
	var/tmp/cached_combined_volume

/datum/object_system/storage/New()
	// we use typelists to detect if it's been init'd
	if(!is_typelist(insertion_whitelist_typecache))
		insertion_whitelist_typecache = cached_typecacheof(insertion_whitelist_typecache)
	if(!is_typelist(insertion_blacklist_typecache))
		insertion_blacklist_typecache = cached_typecacheof(insertion_blacklist_typecache)
	if(!is_typelist(insertion_allow_typecache))
		insertion_allow_typecache = cached_typecacheof(insertion_allow_typecache)

//* Filters *//

/datum/object_system/storage/proc/check_insertion_filters(obj/item/candidate)
	if(insertion_allow_typecache?[candidate.type])
		return TRUE
	if(!isnull(insertion_whitelist_typecache) && !insertion_whitelist_typecache?[candidate.type])
		return FALSE
	if(insertion_blacklist_typecache?[candidate.type])
		return FALSE
	return TRUE

//* Limits *//

#warn impl
