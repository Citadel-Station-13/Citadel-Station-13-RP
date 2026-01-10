//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Belt storage
 *
 * Uses a list of class-size-limits.
 */
/datum/object_system/storage/belt
	// belts use slot mode for now, pending a new belt UI
	ui_force_slot_mode = TRUE
	// belts can be massive so only expand when needed
	ui_expand_when_needed = 7

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
	return min(max_items, max_combined_belt_small + max_combined_belt_medium + max_combined_belt_large)

/datum/object_system/storage/belt/uses_volumetric_ui()
	return FALSE

/datum/object_system/storage/belt/handle_storage_examine(list/examine_list)
	var/list/used_slots = list(cached_combined_belt_small_size, cached_combined_belt_medium_size, cached_combined_belt_large_size)
	var/list/max_slots = list(max_combined_belt_small, max_combined_belt_medium, max_combined_belt_large)
	var/list/rendered_loop_types = list()
	var/has_overrun
	for(var/i in 1 to 3)
		if(used_slots[i] > max_slots[i])
			has_overrun = TRUE
		rendered_loop_types += "<b>[used_slots[i] > max_slots[i] ? SPAN_DANGER("[used_slots[i]]") : used_slots[i]]/[max_slots[i]]</b> \
		[lowertext(global.belt_class_names[i + 1])]"
	examine_list += SPAN_NOTICE("This is a storage item with <b>belt loops</b>. There are \
	[english_list(rendered_loop_types)] loops on it.[has_overrun ? SPAN_WARNING(" Some of the larger loops are \
	currently being filled up by excess items of smaller size.") : ""]")

/**
 * @return list(small, medium, large, )
 */
/datum/object_system/storage/belt/proc/compute_free_slots() as /list
	var/small = 0
	var/medium = 0
	var/large = 0

	// belts are weird
	// small items can overflow onto medium, medium can overflow onto large

	// the problem arises in that if small is overrunning, you don't know if it's
	// overrunning into medium or large; this is because storage ui does not yet store, bespoke,
	// which slot an item is in, so the player has no control over it

	// thus this standard proc is here to enforce a single order of operations
	// right now, we assume that any items always have dibs on their own slot first,
	// and overrun 'hops over' if there's not enough.

	small = max_combined_belt_small - cached_combined_belt_small_size
	medium = max_combined_belt_medium - cached_combined_belt_medium_size
	large = max_combined_belt_large - cached_combined_belt_large_size

	if(small < 0)
		if(medium > 0)
			// overrun as much as we can to medium
			. = min(medium, -small)
			small += .
			medium -= .
		// overrun rest to large
		large += small
		small = 0
	if(medium < 0)
		// overrun all medium to large
		large += medium
		medium = 0

	return list(small, medium, large)

/datum/object_system/storage/belt/get_ui_drawer_tint()
	var/list/remaining = compute_free_slots()
	var/full_classes = 0
	for(var/i in 1 to 3)
		if(remaining[i] <= 0)
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

/datum/object_system/storage/belt/can_be_inserted(obj/item/inserting, datum/event_args/actor/actor, silent)
	if(inserting.belt_storage_class == BELT_CLASS_INVALID)
		if(!silent)
			actor?.chat_feedback(
				SPAN_WARNING("[inserting] can't go in belts."),
				target = inserting,
			)
		return FALSE
	return ..()

/datum/object_system/storage/belt/proc/room_left_for_belt_class(belt_class, forbid_overrun)
	if(forbid_overrun)
		switch(belt_class)
			if(BELT_CLASS_SMALL)
				. = 1
			if(BELT_CLASS_MEDIUM)
				. = 2
			if(BELT_CLASS_LARGE)
				. = 3
		return . ? compute_free_slots()[.] : 0
	else
		var/list/free_slots = compute_free_slots()
		switch(belt_class)
			if(BELT_CLASS_SMALL)
				return free_slots[1] + free_slots[2] + free_slots[3]
			if(BELT_CLASS_MEDIUM)
				return free_slots[2] + free_slots[3]
			if(BELT_CLASS_LARGE)
				return free_slots[3]
		return 0

/datum/object_system/storage/belt/why_failed_insertion_limits(obj/item/candidate)
	if(!room_left_for_belt_class(candidate.belt_storage_class) >= candidate.belt_storage_size)
		// incase list index out of bounds
		. = "runtime errored"
		return "insufficient belt loops of size [lowertext(global.belt_class_names[candidate.belt_storage_class])] or bigger"
	return ..()

/datum/object_system/storage/belt/check_insertion_limits(obj/item/candidate)
	return room_left_for_belt_class(candidate.belt_storage_class) >= candidate.belt_storage_size && ..()

/datum/object_system/storage/belt/physically_insert_item(obj/item/inserting, no_move, from_hook)
	var/obj/item/actually_inserted = . = ..()
	if(!istype(actually_inserted))
		return
	switch(actually_inserted.belt_storage_class)
		if(BELT_CLASS_SMALL)
			cached_combined_belt_small_size += actually_inserted.belt_storage_size
		if(BELT_CLASS_MEDIUM)
			cached_combined_belt_medium_size += actually_inserted.belt_storage_size
		if(BELT_CLASS_LARGE)
			cached_combined_belt_large_size += actually_inserted.belt_storage_size

/datum/object_system/storage/belt/physically_remove_item(obj/item/removing, atom/to_where, no_move, from_hook)
	var/obj/item/actually_removed = . = ..()
	if(!istype(actually_removed))
		return
	switch(actually_removed.belt_storage_class)
		if(BELT_CLASS_SMALL)
			cached_combined_belt_small_size -= actually_removed.belt_storage_size
		if(BELT_CLASS_MEDIUM)
			cached_combined_belt_medium_size -= actually_removed.belt_storage_size
		if(BELT_CLASS_LARGE)
			cached_combined_belt_large_size -= actually_removed.belt_storage_size
