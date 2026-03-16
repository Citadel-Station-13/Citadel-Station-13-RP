//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

// todo: return a STORAGE_INSERTION_CHECK_RESULT_* or something to that accord, instead of having two procs

/datum/object_system/storage/proc/check_insertion_limits(obj/item/candidate)
	var/atom/movable/indirection = real_contents_loc()
	if(!isnull(max_items) && length(indirection.contents) > max_items)
		return FALSE
	if(!isnull(max_combined_volume) && (cached_combined_volume + candidate.get_weight_volume() > max_combined_volume))
		return FALSE
	var/their_weight_class = candidate.get_weight_class()
	if(!isnull(max_single_weight_class) && (their_weight_class > max_single_weight_class))
		return FALSE
	if(!isnull(max_combined_weight_class) && (cached_combined_weight_class + their_weight_class > max_combined_weight_class))
		return FALSE
	if(candidate.obj_storage && (candidate.w_class >= parent.w_class) && disallow_equal_weight_class_storage_nesting)
		return FALSE
	return TRUE

/datum/object_system/storage/proc/why_failed_insertion_limits(obj/item/candidate)
	var/atom/movable/indirection = real_contents_loc()
	if(!isnull(max_items) && length(indirection.contents) > max_items)
		return "too many items"
	if(!isnull(max_combined_volume) && (cached_combined_volume + candidate.get_weight_volume() > max_combined_volume))
		return "insufficient volume"
	var/their_weight_class = candidate.get_weight_class()
	if(!isnull(max_single_weight_class) && (their_weight_class > max_single_weight_class))
		return "too large"
	if(!isnull(max_combined_weight_class) && (cached_combined_weight_class + their_weight_class > max_combined_weight_class))
		return "insufficient space"
	if(candidate.obj_storage && (candidate.w_class >= parent.w_class) && disallow_equal_weight_class_storage_nesting)
		return "can't nest storage"
	return null

/**
 * generally a bad idea to call, tbh.
 *
 * uses max single weight class
 * uses combined volume
 *
 * can use type whitelist
 * if type_whitelist is FALSE, this just wipes all type whitelists.
 */
/datum/object_system/storage/proc/fit_to_contents(type_whitelist = FALSE, no_shrink = FALSE)
	var/scanned_max_single_weight_class = WEIGHT_CLASS_TINY
	var/scanned_max_combined_volume = 0

	if(!no_shrink)
		max_single_weight_class = scanned_max_single_weight_class
		max_combined_volume = scanned_max_combined_volume

	var/list/types = list()
	for(var/obj/item/item in real_contents_loc())
		if(type_whitelist)
			types |= item.type
		scanned_max_single_weight_class = max(max_single_weight_class, item.w_class)
		scanned_max_combined_volume += item.get_weight_volume()

	max_single_weight_class = max(max_single_weight_class, scanned_max_single_weight_class)
	max_combined_volume = max(max_combined_volume, scanned_max_combined_volume)

	set_insertion_whitelist(type_whitelist? types : null)
	set_insertion_blacklist(null)
	set_insertion_allow(null)
