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
	var/default_power_bus_load_watts = 0


/datum/item_interface/Destroy()
	unmount_everything()
	return ..()

/datum/item_interface/proc/mount_item(obj/item/item)
	#warn hook
	return TRUE

/datum/item_interface/proc/unmount_item(obj/item/item)
	#warn hook
	return TRUE

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

/datum/item_interface/proc/use_power_immediate(obj/item/item, joules)
	return FALSE

#warn power bus stuff

/**
 * register a gradual power usage
 *
 * register as 0 watts to unregister
 */
/datum/item_interface/proc/set_power_load(obj/item/item, watts)
	#warn power bus stuff

/**
 * check how much power is available from registered gradual power
 */
/datum/item_interface/proc/available_power_load(obj/item/item)
	return 0

/**
 * check ratio of power load across any / all items that's met
 *
 * @return 0 to 1 inclusive
 */
/datum/item_interface/proc/available_power_load_ratio()
	return 0

//* Miscellaneous / One-Offs *//

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

#warn impl all

#warn hook

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
