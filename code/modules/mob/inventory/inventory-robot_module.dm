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

//* Slots - Abstraction (Implement These!) *//

/**
 * Return number of module slots
 */
/datum/inventory/proc/robot_module_get_slots()
	return 0

/**
 * Sets number of module slots
 *
 * @return new number
 */
/datum/inventory/proc/robot_module_set_slots(count)
	return 0

//* Get - Abstraction (Implement These!) *//

/**
 * Gets all robot modules registered.
 */
/datum/inventory/proc/robot_module_get_all() as /list
	return list()

//* Check - Abstraction (Implement These!) *//

/**
 * Checks if an item is active
 *
 * @return 0 if not active (or not registered), # for index if it's active as that index
 */
/datum/inventory/proc/robot_module_is_active(obj/item/item) as num
	return null

/**
 * Checks if an item is registered to us as a robot module.
 *
 * @return TRUE if module, FALSE otherwise
 */
/datum/inventory/proc/robot_module_is_registered(obj/item/item)
	return 0

//* Registration - Abstraction (Implement These!) *//

/datum/inventory/proc/robot_module_register_impl(obj/item/item)
	PROTECTED_PROC(TRUE)
	return FALSE

/datum/inventory/proc/robot_module_unregister_impl(obj/item/item)
	PROTECTED_PROC(TRUE)

//* Equip / Unequip - Abstraction (Implement These!) *//

/datum/inventory/proc/robot_module_equip_impl(obj/item/item, index)
	PROTECTED_PROC(TRUE)
	return FALSE

/datum/inventory/proc/robot_module_unequip_impl(obj/item/item, index)
	PROTECTED_PROC(TRUE)
	return FALSE

//* Equip / Unequip *//

/**
 * Activates a robot module.
 *
 * @return TRUE success, FALSE fail
 */
/datum/inventory/proc/robot_module_equip(obj/item/item, index)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	. = robot_module_equip_impl(item, index)
	if(.)
		on_robot_module_equip(item, index)

/datum/inventory/proc/on_robot_module_equip(obj/item/item, index)
	SHOULD_CALL_PARENT(TRUE)

/**
 * Deactivates a robot module by reference.
 */
/datum/inventory/proc/robot_module_unequip(obj/item/item)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	var/index = robot_module_is_active(item)
	if(!index)
		return

	robot_module_unequip_impl(item, index)
	on_robot_module_unequip(item, index)

/**
 * Deactivates a robot module by index.
 *
 * @return item unequipped or null
 */
/datum/inventory/proc/robot_module_unequip_index(obj/item/item) as /obj/item
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	var/index = robot_module_is_active(item)
	if(!index)
		return

	robot_module_unequip_impl(item, index)
	on_robot_module_unequip(item, index)

/datum/inventory/proc/on_robot_module_unequip(obj/item/item, index)
	SHOULD_CALL_PARENT(TRUE)

//* Registration *//

/**
 * Registers an item as a robot module.
 *
 * @return TRUE success, FALSE fail
 */
/datum/inventory/proc/robot_module_register(obj/item/item)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	. = robot_module_register_impl(item)
	if(.)
		on_robot_module_register(item)

/datum/inventory/proc/on_robot_module_register(obj/item/item)
	SHOULD_CALL_PARENT(TRUE)

/**
 * Unregisters an item from being a robot module.
 */
/datum/inventory/proc/robot_module_unregister(obj/item/item)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	if(!robot_module_check(item))
		return

	robot_module_unregister_impl(item)
	on_robot_module_unregister(item)

/datum/inventory/proc/on_robot_module_unregister(obj/item/item)
	SHOULD_CALL_PARENT(TRUE)
