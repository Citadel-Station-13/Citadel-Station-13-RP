//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Arbitrary provider for resources, management, etc.
 *
 * Used to allow things like cyborgs to provide water to things
 * that would usually require internal tanks; this is just an example.
 */
/datum/item_mount
	/// mounted items; lazy list
	var/list/obj/item/mounted_items

/datum/item_mount/Destroy()
	for(var/obj/item/mounted as anything in mounted_items)
		unmount(mounted)
	return ..()

/datum/item_mount/proc/mount(obj/item/item)
	if(item.item_mount)
		if(item.item_mount == src)
			return TRUE
		item.item_mount.unmount(item)

	LAZYADD(mounted_items, item)
	item.item_mount = src
	return TRUE

/datum/item_mount/proc/unmount(obj/item/item)
	if(item.item_mount != src)
		return TRUE
	LAZYREMOVE(mounted_items, item)
	item.item_mount = null
	return TRUE

/datum/item_mount/proc/is_mounted(obj/item/item)
	return item in mounted_items

/**
 * Called when a mounted item is deleted.
 */
/datum/item_mount/proc/on_item_del(obj/item/being_deleted)
	unmount(being_deleted)

//* Reagents *//

/**
 * Gets if an item mount has a reagent, and if it does, its amount.
 *
 * * Semantically, null means 'we can't store this'.
 *
 * @params
 * * id - reagent id
 *
 * @return amount the item mount has, null if it doesn't have it
 */
/datum/item_mount/proc/get_reagent(id)
	return null

/**
 * checks if the item mount has a given amount of a reagent
 *
 * @params
 * * id - reagent id
 * * amount - volume required
 *
 * @return amount the item mount has
 */
/datum/item_mount/proc/has_reagent(id, amount)
	. = get_reagent(id) || 0
	if(. < amount)
		return 0

/**
 * todo: how to handle data pull?
 *
 * @params
 * * id - reagent id
 * * amount - volume
 *
 * @return amount the item mount could give
 */
/datum/item_mount/proc/pull_reagent(id, amount)
	return 0

/**
 * todo: how to handle data pull?
 *
 * @params
 * * id - reagent id
 * * amount - volume
 *
 * @return amount the item mount could give
 */
/datum/item_mount/proc/pull_checked_reagent(id, amount)
	return has_reagent(id, amount) ? pull_reagent(id, amount) : 0

/**
 * @params
 * * id - reagent id
 * * amount - volume
 * * force - allow overfill
 *
 * @return amount the item mount could accept
 */
/datum/item_mount/proc/push_reagent(id, amount, force)
	return 0

//* Materials *//

/**
 * checks if the item mount has a material, and how much it has
 *
 * * Semantically, null means 'we can't store this'.
 *
 * @params
 * * id - material id
 *
 * @return amount the item mount has, or null
 */
/datum/item_mount/proc/get_material(id)
	return null

/**
 * checks if the item mount has a given amount of a material
 *
 * @params
 * * id - material id
 * * amount - volume in cm3 required
 *
 * @return amount the item mount has
 */
/datum/item_mount/proc/has_material(id, amount)
	. = get_material(id) || 0
	if(. < amount)
		return 0

/**
 * attempts to consume a material from the item mount
 *
 * @params
 * * id - material id
 * * amount - volume in cm3
 *
 * @return amount the item mount could give
 */
/datum/item_mount/proc/pull_material(id, amount)
	return 0

/**
 * attempts to consume a material from the item mount
 *
 * @params
 * * id - material id
 * * amount - volume in cm3
 *
 * @return amount the item mount could give
 */
/datum/item_mount/proc/pull_checked_material(id, amount)
	return has_material(id, amount) ? pull_material(id, amount) : 0

/**
 * attempts to give a material to the item mount
 *
 * @params
 * * id - material id
 * * amount - volume in cm3
 * * force - allow overfill
 *
 * @return amount the item mount could accept
 */
/datum/item_mount/proc/push_material(id, amount, force)
	return 0

//* Stacks *//

/**
 * checks if the item mount has a stack, and if it does, how much of it.
 *
 * * Semantically, null means 'we can't store this stack'.
 *
 * @params
 * * path - stack path
 *
 * @return amount in sheets the item mount has, or null
 */
/datum/item_mount/proc/get_stack(path)
	return null

/**
 * checks if the item mount has a stack
 *
 * @params
 * * path - stack path
 * * amount - sheets required
 *
 * @return amount the item mount has
 */
/datum/item_mount/proc/has_stack(path, amount)
	. = get_stack(path) || 0
	if(. < amount)
		return 0

/**
 * attempts to consume a stack from the item mount
 *
 * @params
 * * path - stack path
 * * amount - volume
 *
 * @return amount the item mount could give
 */
/datum/item_mount/proc/pull_stack(path, amount)
	return 0

/**
 * attempts to consume a stack from the item mount
 *
 * @params
 * * path - stack path
 * * amount - volume
 *
 * @return amount the item mount could give
 */
/datum/item_mount/proc/pull_checked_stack(path, amount)
	return has_stack(path, amount) ? pull_stack(path, amount) : 0

/**
 * attempts to give a stack to the item mount
 *
 * @params
 * * path - stack path
 * * amount - volume
 * * force - allow overfill
 *
 * @return amount the item mount could accept
 */
/datum/item_mount/proc/push_stack(path, amount, force)
	return 0

//* Misc *//

/**
 * Extinguisher get volume remaining
 *
 * @return volume remaining
 */
/datum/item_mount/proc/get_extinguisher_spray_volume(obj/item/extinguisher/extinguisher)
	return 0

/**
 * Extinguisher has volume remaining
 *
 * @return TRUE / FALSE on if there's that much left
 */
/datum/item_mount/proc/has_extinguisher_spray_volume(obj/item/extinguisher/extinguisher, requested)
	return get_extinguisher_spray_volume(extinguisher) >= requested

/**
 * Extinguisher pull volume into target reagents
 *
 * @return volume pulled
 */
/datum/item_mount/proc/pull_extinguisher_spray_volume(obj/item/extinguisher/extinguisher, requested, datum/reagent_holder/target_reagent_holder)
	return 0

#warn above

//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Arbitrary provider for resources, management, etc.
 *
 * * Used to allow things like cyborgs to provide water to things
 *   that would usually require internal tanks; this is just an example.
 * * Usage procs have 'item' and 'key'. This is so you can route things like air
 *   around.
 * * Items don't actually need to be mounted to use things. That's why
 *   there's minimally stateful procs. Some stateful procs just gracefully
 *   reject the usage / check if an item isn't mounted.
 */
/datum/item_mount
	/// mounted items; lazy list
	var/list/obj/item/mounted_items

/datum/item_mount/Destroy()
	for(var/obj/item/mounted as anything in mounted_items)
		unmount(mounted)
	return ..()

/datum/item_mount/proc/mount(obj/item/item)
	if(item.item_mount)
		if(item.item_mount == src)
			return TRUE
		item.item_mount.unmount(item)

	LAZYADD(mounted_items, item)
	item.item_mount = src
	return TRUE

/datum/item_mount/proc/unmount(obj/item/item)
	if(item.item_mount != src)
		return TRUE
	LAZYREMOVE(mounted_items, item)
	item.item_mount = null
	return TRUE

/datum/item_mount/proc/is_mounted(obj/item/item)
	return item in mounted_items

/**
 * Called when a mounted item is deleted.
 */
/datum/item_mount/proc/on_item_del(obj/item/being_deleted)
	unmount(being_deleted)

//* Gas *//

/**
 * Get estimated gas pressure.
 */
/datum/item_mount/proc/gas_get_pressure(obj/item/item, key)
	return 0

/**
 * Unsafe: Directly references a gas_mixture for a channel.
 */
/datum/item_mount/proc/gas_mixture_ref(obj/item/item, key)
	return 0

/**
 * Returns a gas mixture by pulling a given liter amount.
 */
/datum/item_mount/proc/gas_pull_volume(obj/item/item, key, liters)

/**
 * Fast: erases a given liter amount of gas. Usually used with [gas_mixture_ref]
 * being used to check first.
 */
/datum/item_mount/proc/gas_erase_volume(obj/item/item, key, liters)

//* Power *//

/**
 * Lazy use-power-oneoff style thing
 */
/datum/item_mount/proc/lazy_power_check(obj/item/item, key, joules)
	return FALSE

/**
 * Lazy use-power-oneoff style thing
 * @return joules supplied
 */
/datum/item_mount/proc/lazy_power_use(obj/item/item, key, joules, minimum_reserve)
	return 0

/**
 * Lazy use-power-oneoff style thing
 * @return joules supplied
 */
/datum/item_mount/proc/lazy_power_use_checked(obj/item/item, key, joules, minimum_reserve)
	if(!lazy_power_check(joules + minimum_reserve))
		return 0
	return lazy_power_use(joules, minimum_reserve)
