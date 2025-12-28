//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Robot inventories; separate from /datum/inventory, which is a slot-and-hands system.
 * * Thus, robot modules don't count as actually in inventory unless they're equipped.
 *   This is kinda bad, but, the other option is worse (bolting this onto `/datum/inventory`)
 *
 * Implementation guidelines:
 *
 * * Modules can never be dropped or taken out of the mob.
 * * Modules automatically return to the mob when being unequipped.
 * * Modules must always be in the mob, location-wise. If it's ever removed, it will be
 *   **dropped** by the robot inventory datum.
 */
/datum/robot_inventory
	/// Owner
	/// * This is generic, and can technically work for non-silicon mobs
	var/mob/living/silicon/robot/owner
	/// registered items
	/// * Things in-hand are still registered.
	var/list/obj/item/provided_items
	/// actor HUDs using us
	/// * Lazy list
	var/list/datum/actor_hud/robot_inventory/huds_using

#warn impl all

//* Get *//

/**
 * Gets all robot modules registered.
 */
/datum/robot_inventory/proc/inv_get_all() as /list
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	return provided_items ? provided_items.Copy() : list()

/**
 * Gets all robot modules active.
 */
/datum/robot_inventory/proc/inv_get_active() as /list
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	. = list()
	for(var/obj/item/item as anything in provided_items)
		if(isnum(item.inv_slot_or_index))
			. += item

//* Check *//

/**
 * Checks if an item is registered to us as a robot module.
 *
 * @return TRUE if module, FALSE otherwise
 */
/datum/robot_inventory/proc/inv_is_registered(obj/item/item)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	return item in provided_items

//* Registration *//

/**
 * Registers an item as a robot module.
 *
 * * Item must not be in an inventory, even ourselves.
 * * The item will be moved into our owner.
 *
 * @return TRUE success, FALSE fail
 */
/datum/robot_inventory/proc/inv_register(obj/item/item)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	if(item in provided_items)
		return TRUE
	if(item.inv_inside)
		// TODO: this is shitcode
		item.forceMove(owner)
		if(item.inv_inside)
			stack_trace("failed to kick item out of existing inv in robot_module_register")
			return FALSE

	item.forceMove(owner)
	LAZYADD(provided_items, item)
	on_inv_register(item)
	return TRUE

/datum/robot_inventory/proc/on_inv_register(obj/item/item)
	PROTECTED_PROC(TRUE)
	SHOULD_CALL_PARENT(TRUE)

/**
 * Unregisters an item from being a robot module.
 * * You have to move it out of the inventory / mob after!
 */
/datum/robot_inventory/proc/inv_unregister(obj/item/item)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	if(!(item in provided_items))
		return
	LAZYREMOVE(provided_items, item)
	on_inv_unregister(item)

/datum/robot_inventory/proc/on_inv_unregister(obj/item/item)
	PROTECTED_PROC(TRUE)
	SHOULD_CALL_PARENT(TRUE)
