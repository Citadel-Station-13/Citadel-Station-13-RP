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
	/// relay to other item mount by default
	var/datum/item_mount/relay_to_other
	/// item mounts relaying to us
	var/list/datum/item_mount/relay_to_self

/datum/item_mount/Destroy()
	for(var/obj/item/mounted as anything in mounted_items)
		unmount(mounted)
	stack_provider = null
	relay_unlink_all()
	return ..()

/datum/item_mount/proc/relay_to(datum/item_mount/other)
	#warn impl

/datum/item_mount/proc/relay_unlink_all()
	#warn impl

/datum/item_mount/proc/mount(obj/item/item)
	if(item.item_mount)
		if(item.item_mount == src)
			return TRUE
		item.item_mount.unmount(item)

	LAZYADD(mounted_items, item)
	item.item_mount = src
	on_item_mount(item)
	return TRUE

/datum/item_mount/proc/unmount(obj/item/item)
	if(item.item_mount != src)
		return TRUE
	LAZYREMOVE(mounted_items, item)
	item.item_mount = null
	on_item_unmount(item)
	return TRUE

/datum/item_mount/proc/is_mounted(obj/item/item)
	return item in mounted_items

/**
 * Called when a mounted item is deleted.
 */
/datum/item_mount/proc/on_item_del(obj/item/being_deleted)
	unmount(being_deleted)

/datum/item_mount/proc/on_item_mount(obj/item/item)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)

/datum/item_mount/proc/on_item_unmount(obj/item/item)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)

//* Gas *//

/**
 * Get estimated gas pressure.
 *
 * @return null, or number
 */
/datum/item_mount/proc/gas_get_pressure(obj/item/item, key)
	return relay_to_other?.gas_get_pressure(item, key)

/**
 * Unsafe: Directly references a gas_mixture for a channel.
 *
 * @return null, or ref
 */
/datum/item_mount/proc/gas_mixture_ref(obj/item/item, key)
	return relay_to_other?.gas_mixture_ref(item, key)

/**
 * Returns a gas mixture by pulling a given liter amount.
 *
 * @return null, or ref
 */
/datum/item_mount/proc/gas_pull_volume(obj/item/item, key, liters)
	return relay_to_other?.gas_pull_volume(item, key)

/**
 * Fast: erases a given liter amount of gas. Usually used with [gas_mixture_ref]
 * being used to check first.
 *
 * @return null, or moles deleted
 */
/datum/item_mount/proc/gas_erase_volume(obj/item/item, key, liters)
	return relay_to_other?.gas_pull_volume(item, key)

//* Materials *//

/**
 * Get the name of the provider.
 * * Material is any resolvable material, so ID, path, or instance.
 *
 * @return null, or name
 */
/datum/item_mount/proc/material_get_provider_name(obj/item/item, key, datum/prototype/material/material)
	return relay_to_other?.material_get_provider_name(item, key, material)

/**
 * * Material is any resolvable material, so ID, path, or instance.
 * * Amount is in cm3
 *
 * @return null, or amount in cm3
 */
/datum/item_mount/proc/material_get_amount(obj/item/item, key, datum/prototype/material/material)
	return relay_to_other?.material_get_amount(item, key, material)

/**
 * * Material is any resolvable material, so ID, path, or instance.
 * * Amount is in cm3
 *
 * @return null, or TRUE / FALSE.
 */
/datum/item_mount/proc/material_has_amount(obj/item/item, key, datum/prototype/material/material, amount)
	return relay_to_other?.material_has_amount(item, key, material, amount)

/**
 * * Material is any resolvable material, so ID, path, or instance.
 * * Amount is in cm3.
 *
 * @return null, or amount used in cm3.
 */
/datum/item_mount/proc/material_use_amount(obj/item/item, key, datum/prototype/material/material, amount)
	return relay_to_other?.material_use_amount(item, key, material, amount)

/**
 * * Material is any resolvable material, so ID, path, or instance.
 * * Amount is in cm3.
 *
 * @return null, or amount used.
 */
/datum/item_mount/proc/material_use_checked_amount(obj/item/item, key, datum/prototype/material/material, amount)
	return material_has_amount(item, key, material, amount) && material_use_amount(item, key, material, amount)

/**
 * * Material is any resolvable material, so ID, path, or instance.
 * * Amount is in cm3.
 *
 * @return null, or amount given.
 */
/datum/item_mount/proc/material_give_amount(obj/item/item, key, datum/prototype/material/material, amount, force)
	return relay_to_other?.material_give_amount(item, key, material, amount, force)

/**
 * * Material is any resolvable material, so ID, path, or instance.
 * * Amount is in cm3.
 *
 * @return null, or max amount.
 */
/datum/item_mount/proc/material_get_capacity(obj/item/item, key, datum/prototype/material/material)
	return relay_to_other?.material_get_capacity(item, key, material)

//* Power *//

/**
 * Lazy use-power-oneoff style thing
 *
 * @return null, or TRUE / FALSE for has that amount of energy
 */
/datum/item_mount/proc/lazy_energy_check(obj/item/item, key, joules)
	return relay_to_other?.lazy_power_check(item, key, joules)

/**
 * Lazy use-power-oneoff style thing
 *
 * @return null, or joules supplied
 */
/datum/item_mount/proc/lazy_energy_use(obj/item/item, key, joules, minimum_reserve)
	return relay_to_other?.lazy_energy_use(item, key, joules, minimum_reserve)

/**
 * Lazy use-power-oneoff style thing
 *
 * @return null, or joules supplied
 */
/datum/item_mount/proc/lazy_energy_checked_use(obj/item/item, key, joules, minimum_reserve)
	return lazy_energy_check(joules + minimum_reserve) && lazy_energy_use(joules, minimum_reserve)

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
	. = reagent_get_amount(id) || 0
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
	return reagent_has_amount(id, amount) ? reagent_erase_amount(id, amount) : 0

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
	return extinguisher_get_volume(extinguisher) >= requested

/**
 * @return volume pulled
 */
/datum/item_mount/proc/extinguisher_transfer_volume(obj/item/extinguisher/extinguisher, key, requested, datum/reagent_holder/into)
	return 0
