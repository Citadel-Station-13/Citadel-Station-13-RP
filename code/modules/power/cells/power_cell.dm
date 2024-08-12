//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Encapsulates power cell behavior.
 */
/datum/power_cell
	/// worth multiplier
	///
	/// * this is because i am just frankly not going to manually set worth on every subtype, lol
	/// * set to null to say "we have no worth" (useful for infinite cells)
	/// * null behaves like 0 right now but might not later
	/// * fuck inheritance, lol!
	var/worth_multiplier = 1

/**
 * Intercepts 'use' behavior
 *
 * @return amount that could used
 */
/datum/power_cell/proc/use(obj/item/cell/cell, amount)

/**
 * Intercepts 'check' behavior
 *
 * @return if we have that amount
 */
/datum/power_cell/proc/check(obj/item/cell/cell, amount)

/**
 * Intercepts 'give' behavior
 *
 * @return amount consumed
 */
/datum/power_cell/proc/give(obj/item/cell/cell, amount)

#warn impl all
