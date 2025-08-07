//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Stack storage
 *
 * Can handle both material and normal stacks.
 *
 * Uses max_items and only max_items for 'total combined'.
 */
/datum/object_system/storage/stack
	ui_numerical_mode = TRUE

	var/cached_combined_stack_amount = 0

/datum/object_system/storage/stack/uses_volumetric_ui()
	return FALSE

/datum/object_system/storage/stack/uses_numerical_ui()
	return TRUE

/datum/object_system/storage/stack/rebuild_caches()
	. = ..()
	cached_combined_stack_amount = 0
	for(var/obj/item/stack/stack in real_contents_loc())
		cached_combined_stack_amount += stack.amount

/datum/object_system/storage/stack/why_failed_insertion_limits(obj/item/candidate)
	if(!istype(candidate, /obj/item/stack))
		return "not a stack"
	if(cached_combined_stack_amount >= max_items)
		return "too many sheets"
	return null

/datum/object_system/storage/stack/check_insertion_limits(obj/item/candidate)
	return cached_combined_stack_amount < max_items

// insertion hooked to support partial inserts

/datum/object_system/storage/stack/try_insert(obj/item/inserting, datum/event_args/actor/actor, silent, suppressed, no_update)
	if(!istype(inserting, /obj/item/stack))
		return FALSE
	var/obj/item/stack/stack = inserting
	// insert a copy
	var/allowed_amount = min(stack.amount, max_items - cached_combined_stack_amount)
	if(allowed_amount <= 0)
		return
	if(allowed_amount == stack.amount)
		return ..()
	var/obj/item/stack/actually_inserting = stack.split(allowed_amount, null, TRUE)
	inserting = actually_inserting
	return ..()

/datum/object_system/storage/stack/insert(obj/item/inserting, datum/event_args/actor/actor, suppressed, no_update, no_move)
	if(!istype(inserting, /obj/item/stack))
		return FALSE
	return ..()

/datum/object_system/storage/stack/physically_insert_item(obj/item/inserting, no_move, from_hook)
	// todo: support non-stacks
	if(!istype(inserting, /obj/item/stack))
		// how the fuck
		CRASH("attempted to physically insert a non stack")
	var/obj/item/stack/stack = inserting
	cached_combined_stack_amount += stack.amount
	if(no_move)
		return ..()
	var/atom/indirection = real_contents_loc()
	for(var/obj/item/stack/other in indirection)
		if(!stack.can_merge(other))
			continue
		other.add(stack.amount, TRUE)
		// this should delete the stack (?!)
		stack.use(stack.amount)
		return TRUE
	inserting = stack
	return ..()

// removal is directly hooked to never allow producing stacks with amounts higher than max amounts
// in the future, we might want to change this to allow it if someone really needs/wants to.

/datum/object_system/storage/stack/remove(obj/item/removing, atom/to_where, datum/event_args/actor/actor, suppressed, no_update, no_move)
	if(!istype(removing, /obj/item/stack))
		return FALSE
	return ..()

/datum/object_system/storage/stack/physically_remove_item(obj/item/removing, atom/to_where, no_move, from_hook)
	// todo: support non-stacks
	if(!istype(removing, /obj/item/stack))
		// how the fuck
		CRASH("attempted to physically insert a non stack")
	var/obj/item/stack/stack = removing
	cached_combined_stack_amount -= stack.amount
	if(no_move && (!from_hook))
		return ..()
	if(stack.amount <= stack.max_amount)
		return ..()
	var/obj/item/stack/going_outside = stack.split(stack.max_amount, null, TRUE)
	removing = going_outside
	return ..()

/datum/object_system/storage/stack/render_numerical_display(list/obj/item/for_items)
	var/list/not_stack = list()
	. = list()
	var/list/types = list()
	for(var/obj/item/item in real_contents_loc())
		if(!istype(item, /obj/item/stack))
			not_stack += item
			continue
		var/obj/item/stack/stack = item
		var/datum/storage_numerical_display/display
		if(isnull(types[stack.type]))
			display = new /datum/storage_numerical_display(stack)
			types[stack.type] = display
			. += display
		else
			display = types[stack.type]
		display.amount += stack.amount
	return . + ..(not_stack)
