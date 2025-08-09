//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * base, abstract type of item interfaces
 *
 * used to connect an item to a host
 *
 * * a standard implementation of a power handling bus is provided due to its difficulty.
 */
/datum/item_interface
	abstract_type = /datum/item_interface

	//* Power Handling *//
	/// allow default power bus to be invoked
	var/default_power_bus_implementation = FALSE
	/// current draw in W
	var/default_power_bus_load_low = 0
	/// current draw in W
	var/default_power_bus_load_high = 0
	/// usable power in W
	var/default_power_bus_avail_low = 0
	/// usable power in W
	var/default_power_bus_avail_high = 0
	/// registered power draws
	var/list/default_power_bus_low
	/// registered power draws
	var/list/default_power_bus_high


/datum/item_interface/Destroy()
	unmount_everything()
	return ..()

/datum/item_interface/proc/mount_item(obj/item/item)
	SHOULD_CALL_PARENT(TRUE)
	item.interface_attached(src)
	return TRUE

/datum/item_interface/proc/unmount_item(obj/item/item)
	SHOULD_CALL_PARENT(TRUE)
	item.interface_detached(src)
	if(!isnull(default_power_bus_low?[item]))
		default_power_bus_load_low -= default_power_bus_low[item]
		default_power_bus_low -= item
	if(!isnull(default_power_bus_high?[item]))
		default_power_bus_load_high -= default_power_bus_high[item]
		default_power_bus_high -= item
	return TRUE

/datum/item_interface/proc/is_mounted(obj/item/item)
	return FALSE

/datum/item_interface/proc/unmount_everything()
	return TRUE

//* Reagent Bus *//

/datum/item_interface/proc/use_reagent_exact_gradual(obj/item/item, datum/reagent/reagentlike, amount, dt)
	return FALSE

/datum/item_interface/proc/use_reagent_exact_immediate(obj/item/item, datum/reagent/reagentlike, amount)
	return FALSE

//* Material Bus *//

/datum/item_interface/proc/use_material_exact_gradual(obj/item/item, datum/material/materiallike, amount, dt)
	return FALSE

/datum/item_interface/proc/use_material_exact_immediate(obj/item/item, datum/material/materiallike, amount)
	return FALSE

//* Power Bus *//

/datum/item_interface/proc/use_low_power(obj/item/item, joules)
	return FALSE

/datum/item_interface/proc/use_high_power(obj/item/item, joules)
	return FALSE

/**
 * register a gradual power usage
 *
 * register as 0 watts to unregister
 */
/datum/item_interface/proc/set_low_power(obj/item/item, watts)
	var/diff = watts - default_power_bus_low?[item]
	if(!watts)
		LAZYREMOVE(default_power_bus_low, item)
	else
		LAZYSET(default_power_bus_low, item, watts)
	default_power_bus_load_low += diff

/**
 * check how much power is available from registered gradual power
 */
/datum/item_interface/proc/get_low_power(obj/item/item)
	return default_power_bus_low?[item] * min(1, default_power_bus_avail_low / default_power_bus_load_low)

/**
 * check ratio of power load across any / all items that's met
 *
 * @return 0 to 1 inclusive
 */
/datum/item_interface/proc/check_low_power()
	return min(1, default_power_bus_avail_low / default_power_bus_load_low)

/**
 * register a gradual power usage
 *
 * register as 0 watts to unregister
 */
/datum/item_interface/proc/set_high_power(obj/item/item, watts)
	var/diff = watts - default_power_bus_high?[item]
	if(!watts)
		LAZYREMOVE(default_power_bus_high, item)
	else
		LAZYSET(default_power_bus_high, item, watts)
	default_power_bus_load_high += diff

/**
 * check how much power is available from registered gradual power
 */
/datum/item_interface/proc/get_high_power(obj/item/item)
	return default_power_bus_high?[item] * min(1, default_power_bus_avail_high / default_power_bus_load_high)

/**
 * check ratio of power load across any / all items that's met
 *
 * @return 0 to 1 inclusive
 */
/datum/item_interface/proc/check_high_power()
	return min(1, default_power_bus_avail_high / default_power_bus_load_high)

//* UI *//

/**
 * A hook used to determine if a user should be able to physically access an UI anchored / hosted on a specific item.
 *
 * Item-side must implement/use this.
 *
 * @return non-null to override if we can reach an item.
 */
/datum/item_interface/proc/ui_override_reachability(obj/item/item, mob/user)
	#warn tgui needs a way to hook
	return null

//* Miscellaneous / Specific Items *//

/**
 * @return amount used
 */
/datum/item_interface/proc/use_medichines(datum/medichine_cell/requested, amount)
	return 0

/**
 * @return /datum/medichine_cell instance
 */
/datum/item_interface/proc/query_medichines()
	return null

//? Implementations ?//

/**
 * one-interface, one-item
 *
 * used when we need item-specific context
 *
 * * Only use this if shared can't work for you.
 */
/datum/item_interface/single
	/// bound item
	var/obj/item/bound_item

/datum/item_interface/single/mount_item(obj/item/item)
	if(bound_item == item)
		return TRUE
	if(!isnull(bound_item))
		unmount_item(bound_item)
	bound_item = item
	return ..()

/datum/item_interface/single/unmount_item(obj/item/item)
	if(bound_item == item)
		bound_item = null
	else
		. = FALSE
		CRASH("what?")
	return ..()

/datum/item_interface/single/is_mounted(obj/item/item)
	return bound_item == item

/datum/item_interface/single/unmount_everything()
	unmount_item(bound_item)
	return ..()

/**
 * one-interface, many-item
 *
 * used when we don't need item-specific context
 *
 * * You should probalby use this in most cases.
 */
/datum/item_interface/shared
	/// bound items
	var/list/obj/item/bound_items

/datum/item_interface/shared/mount_item(obj/item/item)
	if(item in bound_items)
		return TRUE
	LAZYADD(bound_items, item)
	return ..()

/datum/item_interface/shared/unmount_item(obj/item/item)
	if(!(item in bound_items))
		. = FALSE
		CRASH("what?")
	LAZYREMOVE(bound_items, item)
	return ..()

/datum/item_interface/shared/is_mounted(obj/item/item)
	return item in bound_items

/datum/item_interface/shared/unmount_everything()
	for(var/obj/item/item as anything in bound_items)
		unmount_item(item)
	return ..()

/**
 * called when we're attached to an interface
 */
/obj/item/proc/interface_attached(datum/item_interface/interface)
	return

/**
 * called when we're detached from an interface
 */
/obj/item/proc/interface_detached(datum/item_interface/interface)
	return
