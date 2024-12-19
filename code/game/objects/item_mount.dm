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
 * checks if the item mount has a reagent
 *
 * @params
 * * id - reagent id
 * * amount - (optional) volume required
 *
 * @return amount the item mount has
 */
/datum/item_mount/proc/has_reagent(id, amount)
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
 * @params
 * * id - reagent id
 * * amount - volume
 * * raw_data_in - raw reagent data will be put into this list, if provided.
 *                 This is a read-only list, do not modify; it's a direct reference to the
 *                 reagent's data list on the providing holder.
 *
 * @return amount the item mount could accept
 */
/datum/item_mount/proc/push_reagent(id, amount, list/data_in)
	return 0

//* Materials *//

/**
 * checks if the item mount has a material
 *
 * @params
 * * id - material id
 * * amount - (optional) volume in cm3 required
 *
 * @return amount the item mount has
 */
/datum/item_mount/proc/has_material(id, amount)
	return 0

/**
 * attempts to consume a material from the item mount
 *
 * @params
 * * id - material id
 * * amount - volume
 *
 * @return amount the item mount could give
 */
/datum/item_mount/proc/pull_material(id, amount)
	return 0

/**
 * attempts to give a material to the item mount
 *
 * @params
 * * id - material id
 * * amount - volume
 *
 * @return amount the item mount could accept
 */
/datum/item_mount/proc/push_material(id, amount)
	return 0

//* Stacks *//

/**
 * checks if the item mount has a stack
 *
 * @params
 * * path - stack path
 * * amount - (optional) volume in cm3 required
 *
 * @return amount the item mount has
 */
/datum/item_mount/proc/has_stack(path, amount)
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
 * attempts to give a stack to the item mount
 *
 * @params
 * * path - stack path
 * * amount - volume
 *
 * @return amount the item mount could accept
 */
/datum/item_mount/proc/push_stack(path, amount)
	return 0
