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

	var/tmp/cached_combined_belt_small_size = 0
	var/tmp/cached_combined_belt_medium_size = 0
	var/tmp/cached_combined_belt_large_size = 0

/datum/object_system/storage/belt/get_ui_predicted_max_items()
	return max(..(), max_combined_belt_small + max_combined_belt_medium + max_combined_belt_large)

/datum/object_system/storage/belt/uses_volumetric_ui()
	return FALSE

/datum/object_system/storage/belt/get_ui_drawer_tint()
	var/full_classes = 0
	if(cached_combined_belt_large_size >= max_combined_belt_large)
		full_classes += 1
	if(cached_combined_belt_medium_size >= max_combined_belt_medium)
		full_classes += 1
	if(cached_combined_belt_small_size >= max_combined_belt_small)
		full_classes += 1
	switch(full_classes)
		if(0)
			return null
		if(1, 2)
			return "#888800"
		if(3)
			return "#aa0000"

/datum/object_system/storage/belt/rebuild_caches_impl(list/atom/movable/entities)
	..()
	cached_combined_belt_small_size = cached_combined_belt_medium_size = cached_combined_belt_large_size = 0
	for(var/obj/item/item in entities)
		switch(item.belt_storage_class)
			if(BELT_CLASS_SMALL)
				cached_combined_belt_small_size += item.belt_storage_size
			if(BELT_CLASS_MEDIUM)
				cached_combined_belt_medium_size += item.belt_storage_size
			if(BELT_CLASS_LARGE)
				cached_combined_belt_large_size += item.belt_storage_size

/datum/object_system/storage/can_be_inserted(obj/item/inserting, datum/event_args/actor/actor, silent)
	if(inserting.belt_storage_class == BELT_CLASS_INVALID)
		if(!silent)
			actor?.chat_feedback(
				SPAN_WARNING("[inserting] can't go in belts."),
				target = inserting,
			)
		return FALSE
	return ..()

/datum/object_system/storage/belt/proc/room_left_for_belt_class(belt_class)
	switch(belt_class)
		if(BELT_CLASS_SMALL)
			return max(0, max_combined_belt_large - cached_combined_belt_large_size) + \
				 max(0, max_combined_belt_medium - cached_combined_belt_medium_size) + \
				 max_combined_belt_medium - cached_combined_belt_medium_size
		if(BELT_CLASS_MEDIUM)
			return max(0, max_combined_belt_large - cached_combined_belt_large_size) + \
				 max_combined_belt_medium - cached_combined_belt_medium_size
		if(BELT_CLASS_LARGE)
			return max_combined_belt_large - cached_combined_belt_large_size
		else
			return 0

/datum/object_system/storage/belt/why_failed_insertion_limits(obj/item/candidate)
	if(!room_left_for_belt_class(candidate.belt_storage_class) >= candidate.belt_storage_size)
		// incase list index out of bounds
		. = "runtime errored"
		return "insufficient belt loops of size [global.belt_class_names[candidate.belt_storage_class]] or bigger"
	return ..()

/datum/object_system/storage/belt/check_insertion_limits(obj/item/candidate)
	return room_left_for_belt_class(candidate.belt_storage_class) >= candidate.belt_storage_size && ..()


/datum/object_system/storage/belt/physically_insert_item(obj/item/inserting, no_move, from_hook)
	..()
	switch(inserting.belt_storage_class)
		if(BELT_CLASS_SMALL)
			cached_combined_belt_small_size += inserting.belt_storage_size
		if(BELT_CLASS_MEDIUM)
			cached_combined_belt_medium_size += inserting.belt_storage_size
		if(BELT_CLASS_LARGE)
			cached_combined_belt_large_size += inserting.belt_storage_size

/datum/object_system/storage/belt/physically_remove_item(obj/item/removing, atom/to_where, no_move, from_hook)
	..()
	switch(removing.belt_storage_class)
		if(BELT_CLASS_SMALL)
			cached_combined_belt_small_size -= removing.belt_storage_size
		if(BELT_CLASS_MEDIUM)
			cached_combined_belt_medium_size -= removing.belt_storage_size
		if(BELT_CLASS_LARGE)
			cached_combined_belt_large_size -= removing.belt_storage_size
