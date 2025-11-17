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
	/// Stack provider, if any.
	/// * Unreferenced on qdel; it is up to you to unreference it on your side if you're
	///   referencing the mount from the provider.
	/// * Material usage should be routed here; in the future, we may implement defaulted
	///   stack / material usage procs on `/datum/item_mount`, by pushing `stack_provider`
	///   down to this level if necessary.
	var/datum/item_mount/stack_provider

/datum/item_mount/Destroy()
	for(var/obj/item/mounted as anything in mounted_items)
		unmount(mounted)
	stack_provider = null
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

//* Materials *//

/**
 * * Material is any resolvable material, so ID, path, or instance.
 * Get the name of the provider.
 */
/datum/item_mount/proc/material_get_provider_name(obj/item/item, key, datum/prototype/material/material)
	return "stack storage"

/**
 * * Material is any resolvable material, so ID, path, or instance.
 * * Amount is in cm3
 * @return amount remaining
 */
/datum/item_mount/proc/material_get_amount(obj/item/item, key, datum/prototype/material/material)
	return 0

/**
 * * Material is any resolvable material, so ID, path, or instance.
 * * Amount is in cm3
 * @return TRUE / FALSE.
 */
/datum/item_mount/proc/material_has_amount(obj/item/item, key, datum/prototype/material/material, amount)
	return FALSE

/**
 * * Material is any resolvable material, so ID, path, or instance.
 * * Amount is in cm3.
 * @return amount used.
 */
/datum/item_mount/proc/material_use_amount(obj/item/item, key, datum/prototype/material/material, amount)
	return 0

/**
 * * Material is any resolvable material, so ID, path, or instance.
 * * Amount is in cm3.
 * @return amount used.
 */
/datum/item_mount/proc/material_use_checked_amount(obj/item/item, key, datum/prototype/material/material, amount)
	return has_material(item, key, material, amount) ? use_material(item, key, material, amount) : 0

/**
 * * Material is any resolvable material, so ID, path, or instance.
 * * Amount is in cm3.
 * @return amount given.
 */
/datum/item_mount/proc/material_give_amount(obj/item/item, key, datum/prototype/material/material, amount, force)
	return 0

/**
 * * Material is any resolvable material, so ID, path, or instance.
 * * Amount is in cm3.
 * @return max amount.
 */
/datum/item_mount/proc/material_get_capacity(obj/item/item, key, datum/prototype/material/material)
	return 0

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

//* Reagents - Direct *//

// TODO: notice how 'erase' and 'spawn' exists, but not 'push', and 'pull'?
//       this is because reagents have data; they are not just described by the ID alone.
//       thus an optimized uniform API for push/pull doesn't actually necessarily make sense,
//       and as such implementation of such is left for when we need it (ergo mechs / rigsuits reagent routing).

/**
 * Gets if an item mount has a reagent, and if it does, its amount.
 * * Semantically, null means 'we can't store this'.
 * @return amount the item mount has, null if it doesn't have it
 */
/datum/item_mount/proc/reagent_get_amount(obj/item/item, key, id)
	return null

/**
 * Checks if the item mount has a given amount of a reagent
 * @return amount the item mount has
 */
/datum/item_mount/proc/reagent_has_amount(obj/item/item, key, id, amount)
	. = get_reagent(id) || 0
	if(. < amount)
		return 0

/**
 * @return amount the item mount could  to erase
 */
/datum/item_mount/proc/reagent_erase_amount(obj/item/item, key, id, amount)
	return 0

/**
 * @return amount the item mount could give to erase
 */
/datum/item_mount/proc/reagent_erase_checked_amount(obj/item/item, key, id, amount)
	return has_reagent(id, amount) ? pull_reagent(id, amount) : 0

/**
 * @return amount the item mount could accept
 */
/datum/item_mount/proc/reagent_spawn_amount(obj/item/item, key, id, amount, force)
	return 0

//* Stacks *//

/**
 * Get the name of the provider.
 */
/datum/item_mount/proc/stack_get_provider_name(obj/item/item, key, path)
	return "stack storage"

/**
 * Material stacks are invalid here.
 *
 * * Amount is in stack amount.
 *
 * @return amount used.
 */
/datum/item_mount/proc/stack_use_checked_amount(obj/item/item, key, path, amount)
	return stack_has_amount(item, key, path, amount) ? stack_use_amount(item, key, path, amount) : 0

/**
 * Material stacks are invalid here.
 * * Amount is in stack amount.
 * @return amount given.
 */
/datum/item_mount/proc/stack_give_amount(obj/item/item, key, path, amount, force)
	return 0

/**
 * Material stacks are invalid here.
 * @return max amount.
 */
/datum/item_mount/proc/stack_get_capacity(obj/item/item, key, path)
	return 0

/**
 * Material stacks are invalid here.
 * * Amount is in stack amount.
 * @return amount remaining.
 */
/datum/item_mount/proc/stack_get_amount(obj/item/item, key, path)
	return 0

/**
 * Material stacks are invalid here.
 * * Amount is in stack amount.
 * @return TRUE / FALSE.
 */
/datum/item_mount/proc/stack_has_amount(obj/item/item, key, path, amount)
	return FALSE

/**
 * Material stacks are invalid here.
 * * Amount is in stack amount.
 * @return amount used.
 */
/datum/item_mount/proc/stack_use_amount(obj/item/item, key, path, amount)
	return 0

//* ------ MISC BELOW HERE ------ *//

//* Misc - Extinguisher *//

/**
 * @return volume remaining
 */
/datum/item_mount/proc/extinguisher_get_volume(obj/item/extinguisher/extinguisher, key)
	return 0

/**
 * @return TRUE / FALSE on if there's that much left
 */
/datum/item_mount/proc/extinguisher_has_volume(obj/item/extinguisher/extinguisher, key, requested)
	return get_extinguisher_spray_volume(extinguisher) >= requested

/**
 * @return volume pulled
 */
/datum/item_mount/proc/extinguisher_transfer_volume(obj/item/extinguisher/extinguisher, key, requested, datum/reagent_holder/into)
	return 0
