//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Contains loading / unloading logic.
 */

//* Loading *//

/**
 * called right after we physically load in, before init
 * called before atom init
 *
 * this is *not* called if we are created from a zlevel, say, when dynamically generating a planet.
 * this is solely for hardcoded map levels to have load behaviors.
 * undefined behavior will result if this is overridden on a level used for dynamic generation.
 *
 * @params
 * * z_index - zlevel we loaded on
 * * generation_callbacks - callbacks to add to perform post_loaded generation. this will be done in a batch before on_loaded_finalize and before atom init.
 */
/datum/map_level/proc/on_loaded_immediate(z_index, list/datum/callback/additional_generation)
	return

/**
 * called in a group after all maps and dependencies load **and** generation callbacks fire.
 * called after atom init
 *
 * this is *not* called if we are created from a zlevel, say, when dynamically generating a planet.
 * this is solely for hardcoded map levels to have load behaviors.
 * undefined behavior will result if this is overridden on a level used for dynamic generation.
 *
 * @params
 * * z_index - zlevel we loaded on
 */
/datum/map_level/proc/on_loaded_finalize(z_index)
	return

//* Unloading *//

// No hooks yet.
