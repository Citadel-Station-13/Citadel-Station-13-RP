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

//* Power *//

/**
 * Lazy use-power-oneoff style thing
 */
/datum/item_mount/proc/has_lazy_power(joules)
	return FALSE

/**
 * Lazy use-power-oneoff style thing
 * @return joules supplied
 */
/datum/item_mount/proc/use_lazy_power(joules, minimum_reserve)
	return 0

/**
 * Lazy use-power-oneoff style thing
 * @return joules supplied
 */
/datum/item_mount/proc/use_checked_lazy_power(joules, minimum_reserve)
	if(!has_lazy_power(joules + minimum_reserve))
		return 0
	return use_lazy_power(joules, minimum_reserve)
