//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Encapsulates power cell behavior.
 */
/datum/power_cell

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
