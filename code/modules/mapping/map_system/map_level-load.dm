//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Contains loading / unloading logic.
 */

//* Loading *//

/**
 * * called right after we physically load in, before init
 * * called before atom init
 * * multiz is set based on map struct at time of this being called, but usually not built yet
 *
 * @params
 * * map_context - context for the whole map
 * * dmm_context - context for this level's own base dmm
 * * z_index - zlevel we loaded on
 */
#warn audit calls
/datum/map_level/proc/on_loaded(datum/map_context/map_context, datum/dmm_context/dmm_context, z_level)
	SHOULD_CALL_PARENT(TRUE)

//* Unloading *//

/**
 * TOOD: not hooked in yet
 *
 * Fired before zclear fires on the zlevels that consist of us
 * * Called before /datum/map's hook
 * * Multiz is torn down here
 *
 * @params
 * * z_index - zlevel we loaded on
 */
/datum/map_level/proc/on_unload_pre_zclear(z_index)
	SHOULD_CALL_PARENT(TRUE)

/**
 * TOOD: not hooked in yet
 *
 * Fired after zclear fires on the zlevels that consist of us
 * * Called before /datum/map's hook
 * * We (along our map) are un-referenced and/or garbage collected (if necessary) after.
 * * Multiz is unset here
 *
 * @params
 * * z_index - zlevel we loaded on
 */
/datum/map_level/proc/on_unload_finalize(z_index)
	SHOULD_CALL_PARENT(TRUE)
