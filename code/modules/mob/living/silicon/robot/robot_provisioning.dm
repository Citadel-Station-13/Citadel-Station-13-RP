//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Tracks what items / whatnot are given from what, so
 * partial state changes are doable without rebuilding the entire robot's
 * state.
 *
 * # Caveats
 * * Internal state (items in us, as an example) should not be mutated without calling helpers,
 *   or adding / removing.
 * * Can only exist for one borg at a time.
 */
/datum/robot_provisioning
	/// Applied
	var/mob/living/silicon/robot/applied_to_robot
	/// provisioned items / modules
	/// * lazy list
	var/list/obj/item/items
	/// provisioned emag-only items/modules
	/// * lazy list
	/// TODO: legacy, stop using this, emags unlocking functionality
	///       should be handled literally any other way including just another provisioning datum
	var/list/obj/item/emag_items
	/// suppressed items, item = true ?
	/// * suppressed items aren't accessible by the robot (but still exist in them)
	var/list/obj/item/suppressed_items
	/// relay mount
	var/datum/item_mount/robot_provisioning/relay_mount
	/// emaged status?
	var/emag_enabled = FALSE

/datum/robot_provisioning/New()
	relay_mount = new(src)

/datum/robot_provisioning/Destroy()
	if(applied_to_robot)
		remove()
	QDEL_LIST(items)
	QDEL_LIST(emag_items)
	QDEL_NULL(relay_mount)
	return ..()

/datum/robot_provisioning/proc/apply(mob/living/silicon/robot/robot)
	if(applied_to_robot)
		remove()
	applied_to_robot = robot
	emag_enabled = robot.emag_items
	for(var/obj/item/item as anything in items)
		if(suppressed_items[item])
			continue
		robot.robot_inventory?.inv_register(item)
		if(item.loc != robot)
			item.forceMove(robot)
	if(emag_enabled)
		for(var/obj/item/item as anything in emag_items)
			if(suppressed_items[item])
				continue
			robot.robot_inventory?.inv_register(item)
			if(item.loc != robot)
				item.forceMove(robot)

/datum/robot_provisioning/proc/remove()
	if(!applied_to_robot)
		return
	var/atom/where_to_dump = get_detached_storage_location()
	for(var/obj/item/item as anything in items)
		applied_to_robot.robot_inventory?.inv_register(item)
		if(item.loc != where_to_dump)
			if(where_to_dump)
				item.forceMove(where_to_dump)
			else
				item.moveToNullspace()
	if(emag_enabled)
		for(var/obj/item/item as anything in emag_items)
			applied_to_robot.robot_inventory?.inv_unregister(item)
			if(item.loc != where_to_dump)
				if(where_to_dump)
					item.forceMove(where_to_dump)
				else
					item.moveToNullspace()
	applied_to_robot = null

/datum/robot_provisioning/proc/add_item(obj/item/item)
	if(item in items)
		return TRUE
	LAZYADD(items, item)
	on_item_add(item, FALSE)
	return TRUE

/datum/robot_provisioning/proc/remove_item(obj/item/item)
	if(!(item in items))
		return TRUE
	items -= item
	suppressed_items?.Remove(item)
	on_item_remove(item, FALSE)
	return TRUE

/datum/robot_provisioning/proc/add_emag_item(obj/item/item)
	if(item in emag_items)
		return TRUE
	LAZYADD(emag_items, item)
	on_item_add(item, TRUE)
	return TRUE

/datum/robot_provisioning/proc/remove_emag_item(obj/item/item)
	if(!(item in emag_items))
		return TRUE
	emag_items -= item
	suppressed_items?.Remove(item)
	on_item_remove(item, TRUE)
	return TRUE

/datum/robot_provisioning/proc/set_emag_enabled(new_state)
	if(emag_enabled == new_state)
		return
	emag_enabled = new_state
	if(!applied_to_robot)
		return
	if(new_state)
		for(var/obj/item/item as anything in emag_items)
			if(suppressed_items?[item])
				continue
			applied_to_robot.robot_inventory?.inv_register(item)
	else
		var/atom/dump_to = get_detached_storage_location()
		for(var/obj/item/item as anything in emag_items)
			applied_to_robot.robot_inventory?.inv_unregister(item)
			if(dump_to)
				item.forceMove(dump_to)
			else
				item.moveToNullspace()

/**
 * @return list of items suppressed
 */
/datum/robot_provisioning/proc/suppress_all_types_of(path) as /list
	for(var/obj/item/item as anything in items)
		if(istype(item, path))
			suppress_item(item)
	for(var/obj/item/item as anything in emag_items)
		if(istype(item, path))
			suppress_item(item)

/**
 * @return list of items unsuppressed
 */
/datum/robot_provisioning/proc/unsuppress_all_types_of(path) as /list
	for(var/obj/item/item as anything in items)
		if(istype(item, path))
			unsuppress_item(item)
	for(var/obj/item/item as anything in emag_items)
		if(istype(item, path))
			unsuppress_item(item)

/datum/robot_provisioning/proc/suppress_item(obj/item/item) as /list
	if(!(item in items) && !(item in emag_items))
		return
	if(suppressed_items?[item])
		return
	LAZYSET(suppressed_items, item, TRUE)
	applied_to_robot?.robot_inventory?.inv_unregister(item)

/datum/robot_provisioning/proc/unsuppress_item(obj/item/item) as /list
	if(!suppressed_items?[item])
		return
	suppressed_items -= item
	if(!length(suppressed_items))
		suppressed_items = null
	if(item in items)
		applied_to_robot?.robot_inventory?.inv_register(item)
	else if(item in emag_items)
		if(emag_enabled)
			applied_to_robot?.robot_inventory?.inv_register(item)

/datum/robot_provisioning/proc/on_item_add(obj/item/item, is_emag_item)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)
	if(!applied_to_robot)
		return
	applied_to_robot.robot_inventory?.inv_register(item)

/datum/robot_provisioning/proc/on_item_remove(obj/item/item, is_emag_item)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)
	if(applied_to_robot)
		applied_to_robot.robot_inventory?.inv_unregister(item)
	if(!QDESTROYING(item))
		var/atom/dump_to = get_detached_storage_location()
		if(dump_to)
			item.forceMove(dump_to)
		else
			item.moveToNullspace()

/datum/robot_provisioning/proc/cleanup_item(obj/item/item)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)

	if(items)
		items -= item
	if(emag_items)
		emag_items -= item
	if(suppressed_items)
		suppressed_items -= item
	on_item_remove(item)
	if(!QDESTROYING(item))
		qdel(item)

/**
 * Gets where items get moved to while not in a robot.
 * * Null is acceptable.
 */
/datum/robot_provisioning/proc/get_detached_storage_location() as /atom
	return null

/datum/item_mount/robot_provisioning
	var/datum/robot_provisioning/provisioning

/datum/item_mount/robot_provisioning/New(datum/robot_provisioning/provisioning)
	src.provisioning = provisioning

/datum/item_mount/robot_provisioning/Destroy()
	provisioning = null
	return ..()

/datum/item_mount/robot_provisioning/on_item_unmount(obj/item/item)
	..()
	provisioning?.cleanup_item(item)
