//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Provider defines for stacks to draw from.
 */
/datum/stack_provider

/**
 * Material stacks are invalid here.
 *
 * * Amount is in stack amount.
 *
 * @return amount remaining.
 */
/datum/stack_provider/proc/get_stack(path)
	return 0

/**
 * Material stacks are invalid here.
 *
 * * Amount is in stack amount.
 *
 * @return TRUE / FALSE.
 */
/datum/stack_provider/proc/has_stack(path, amount)
	return FALSE

/**
 * Material stacks are invalid here.
 *
 * * Amount is in stack amount.
 *
 * @return amount used.
 */
/datum/stack_provider/proc/use_stack(path, amount)
	return 0

/**
 * Material stacks are invalid here.
 *
 * * Amount is in stack amount.
 *
 * @return amount used.
 */
/datum/stack_provider/proc/checked_use_stack(path, amount)
	return has_stack(path, amount) ? use_stack(path, amount) : 0

/**
 * Material stacks are invalid here.
 *
 * * Amount is in stack amount.
 *
 * @return amount given.
 */
/datum/stack_provider/proc/give_stack(path, amount, force)
	return 0

/**
 * * Amount is in stack amount.
 *
 * @return amount remaining.
 */
/datum/stack_provider/proc/get_material(path)
	return 0

/**
 * * Amount is in stack amount.
 *
 * @return TRUE / FALSE.
 */
/datum/stack_provider/proc/has_material(path, amount)
	return FALSE

/**
 * * Amount is in stack amount.
 *
 * @return amount used.
 */
/datum/stack_provider/proc/use_material(path_or_id, amount)
	return 0

/**
 * * Amount is in stack amount.
 *
 * @return amount used.
 */
/datum/stack_provider/proc/checked_use_material(path_or_id, amount)
	return has_material(path_or_id, amount) ? use_material(path_or_id, amount) : 0

/**
 * * Amount is in stack amount.
 *
 * @return amount given.
 */
/datum/stack_provider/proc/give_material(path_or_id, amount, force)
	return 0
