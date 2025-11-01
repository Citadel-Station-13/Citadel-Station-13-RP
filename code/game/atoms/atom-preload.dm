//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Called by the maploader with the `dmm_context` of the load.
 * * Always called, unlike `preloading_from_mapload_rotation`
 * * ID linkage mangling for certain objects can be done here.
 */
/atom/proc/preloading_from_mapload(datum/dmm_context/context)
	return

/**
 * Called by the maploader with the `dmm_context` of the load if the map is being
 * reoriented during the load.
 * * You can **not** return FALSE without handling this yourself. That will cause your entity to
 *   be rotated incorrectly.
 *
 * @return FALSE to override maploader automatic rotation. This often needs to be done if
 *         your type does anything very special for multi-tiles.
 */
/atom/proc/preloading_from_mapload_rotation(datum/dmm_context/context)
	return TRUE

/**
 * Called by stack recipe initialization.
 * * Used to do certain var-sets before Initialize() like emptying out storage.
 */
/atom/proc/preloading_from_stack_recipe(datum/stack_recipe/recipe)
	return
