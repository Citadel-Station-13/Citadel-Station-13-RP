//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Synthesizer define for stacks to draw from.
 *
 * * Despite being called synths, these can also just be
 *   abstracted storage. This is a very modular system.
 */
/datum/stack_synth

/**
 * Material stacks are invalid here.
 *
 * @return amount remaining.
 */
/datum/stack_synth/proc/has_stack(path, amount)

/**
 * Material stacks are invalid here.
 *
 * @return amount used.
 */
/datum/stack_synth/proc/use_stack(path, amount)

/**
 * Material stacks are invalid here.
 *
 * @return amount used.
 */
/datum/stack_synth/proc/checked_use_stack(path, amount)
	return has_stack(path, amount) ? use_stack(path, amount) : 0

/**
 * Material stacks are invalid here.
 *
 * @return amount given.
 */
/datum/stack_synth/proc/give_stack(path, amount)

/**
 * Material stacks are invalid here.
 *
 * @return amount remaining.
 */
/datum/stack_synth/proc/has_material(path, amount)

/**
 * Material stacks are invalid here.
 *
 * @return amount used.
 */
/datum/stack_synth/proc/use_material(path_or_id, amount)

/**
 * Material stacks are invalid here.
 *
 * @return amount used.
 */
/datum/stack_synth/proc/checked_use_material(path_or_id, amount)
	return has_material(path_or_id, amount) ? use_material(path_or_id, amount) : 0

/**
 * Material stacks are invalid here.
 *
 * @return amount given.
 */
/datum/stack_synth/proc/give_material(path_or_id, amount)



#warn impl
