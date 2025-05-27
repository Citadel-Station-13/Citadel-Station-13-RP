//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Contains loading / unloading logic.
 */

//* Loading *//

/**
 * * called right after we physically load in, before init
 * * called before atom init
 * * multiz is set based on map struct here
 *
 * @params
 * * z_index - zlevel we loaded on
 * * generation_callbacks - callbacks to add to perform post_loaded generation. this will be done in a batch before on_loaded_finalize and before atom init.
 */
/datum/map_level/proc/on_loaded_immediate(z_index, list/datum/callback/additional_generation)
	SHOULD_CALL_PARENT(TRUE)
	#warn set multiz according to map
	#warn tell SSmapping to rebuild cache

/**
 * * called in a group after all maps and dependencies load **and** generation callbacks fire.
 * * called after atom init
 * * multiz is built here
 *
 * @params
 * * z_index - zlevel we loaded on
 */
/datum/map_level/proc/on_loaded_finalize(z_index)
	SHOULD_CALL_PARENT(TRUE)
	rebuild_multiz(TRUE, TRUE)

//* Unloading *//

/**
 * TOOD: not hooked in yet
 *
 * Fired before zclear fires on the zlevels that consist of us
 * * Called before /datum/map's hook
 * * Multiz is torn down here
 */
/datum/map_level/proc/on_unload_pre_zclear()
	SHOULD_CALL_PARENT(TRUE)
	teardown_multiz(TRUE, TRUE)

/**
 * TOOD: not hooked in yet
 *
 * Fired after zclear fires on the zlevels that consist of us
 * * Called before /datum/map's hook
 * * We (along our map) are un-referenced and/or garbage collected (if necessary) after.
 * * Multiz is unset here
 */
/datum/map_level/proc/on_unload_finalize()
	SHOULD_CALL_PARENT(TRUE)
	for(var/dir in list(NORTH, SOUTH, EAST, WEST, UP, DOWN))
		set_level_in_dir(dir, null)
	#warn tell SSmapping to rebuild cache
