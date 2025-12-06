//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Robot module API.
 *
 * This is an API separate from hands allowing for the equipping/unequipping of 'modules'.
 *
 * Implementation guideline:
 *
 * * Modules count as in-hand for checks.
 * * Modules can never be dropped or taken out of the mob.
 * * Modules automatically return to the mob when being unequipped.
 * * Modules must always be in the mob, location-wise. If it's ever removed, it will be
 *   **dropped** by the inventory datum.
 *
 * The decision to put robot modules on base /datum/inventory is to add support for potential
 * other systems in the future which rely on something like this - despite the fact that this is
 * only used on cyborgs at time of writing.
 *
 * Robot modules are specially handled. Normally, the mob is expected to not hold references
 * to stuff passed into its inventory - the inventory handles everything.
 *
 * This is not necessarily true at time of writing.
 * Robot module API is expected to **track objects** and to know when to drop their reference
 * if they're removed from the mob.
 *
 * This means that legacy code has a slightly easier time interoperating.
 *
 * There are no currently workable ideas for how to change this, though we do want to
 * eventually change this to the 'classical' paradigm of the inventory datum owning everything.
 *
 * It's only done this way because modules should semantically own their items, not the inventory.
 * In a way, robot module system is an indirection based provider.
 */

//* On / Off *//

/datum/inventory/proc/robot_module_supported()
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	return isnull(robot_modules)

//* Get *//

/**
 * Gets all robot modules registered.
 */
/datum/inventory/proc/robot_module_get_all() as /list
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	return robot_modules?.Copy() || list()

/**
 * Gets all robot modules active.
 */
/datum/inventory/proc/robot_module_get_active() as /list
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	. = list()
	for(var/obj/item/held in held_items)
		if(robot_module_is_registered(held))
			. += held

//* Check *//

/**
 * Checks if an item is registered to us as a robot module.
 *
 * @return TRUE if module, FALSE otherwise
 */
/datum/inventory/proc/robot_module_is_registered(obj/item/item)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	return item in robot_modules

//* Registration *//

/**
 * Registers an item as a robot module.
 *
 * * Item must not be in an inventory, even ourselves.
 * * The item will be moved into our owner.
 *
 * @return TRUE success, FALSE fail
 */
/datum/inventory/proc/robot_module_register(obj/item/item)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	if(robot_module_is_registered(item))
		return TRUE
	if(item.inv_inside)
		return FALSE

	item.forceMove(owner)
	LAZYADD(robot_modules, item)
	on_item_entered(item, resolve_inventory_slot(/datum/inventory_slot/abstract/inactive_robot_module_storage))
	on_robot_module_register(item)
	return TRUE

/datum/inventory/proc/on_robot_module_register(obj/item/item)
	PROTECTED_PROC(TRUE)
	SHOULD_CALL_PARENT(TRUE)

/**
 * Unregisters an item from being a robot module.
 * * You have to move it out of the inventory / mob after!
 */
/datum/inventory/proc/robot_module_unregister(obj/item/item)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	if(!robot_module_is_registered(item))
		return
	LAZYREMOVE(robot_modules, item)
	on_item_exited(item, isnum(item.inv_slot_or_index) ? item.inv_slot_or_index : resolve_inventory_slot(item.inv_slot_or_index))
	on_robot_module_unregister(item)

/datum/inventory/proc/on_robot_module_unregister(obj/item/item)
	PROTECTED_PROC(TRUE)
	SHOULD_CALL_PARENT(TRUE)
