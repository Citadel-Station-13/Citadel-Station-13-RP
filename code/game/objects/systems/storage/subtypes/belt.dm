//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Belt storage
 *
 * Uses a list of class-size-limits.
 */
/datum/object_system/storage/belt
	ui_numerical_mode = TRUE


	/// max size of small-class belt items
	var/max_combined_belt_small = 5
	/// max size of medium-class belt items
	var/max_combined_belt_medium = 3
	/// max size of large-class belt items
	var/max_combined_belt_large = 1

#warn this shit
#warn don't forget yellow / red coloring and crap

/datum/object_system/storage/belt/uses_volumetric_ui()
	return FALSE

/datum/object_system/storage/belt/rebuild_caches()
	. = ..()
	cached_combined_stack_amount = 0
	for(var/obj/item/belt/belt in real_contents_loc())
		cached_combined_stack_amount += stack.amount

/datum/object_system/storage/belt/why_failed_insertion_limits(obj/item/candidate)
	if(!istype(candidate, /obj/item/belt))
		return "not a stack"
	if(cached_combined_stack_amount >= max_items)
		return "too many sheets"
	return null

/datum/object_system/storage/belt/check_insertion_limits(obj/item/candidate)
	return cached_combined_stack_amount < max_items
