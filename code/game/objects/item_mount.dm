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
