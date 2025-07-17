
/**
 * Called by the maploader if a dmm_context is set
 *
 * todo: rename to preload_from_mapload()
 */
/atom/proc/preloading_instance(datum/dmm_context/context)
	return

/**
 * hook for abstract direction sets from the maploader
 *
 * todo: this might need to be part of preloading_instance; investigate
 *
 * return FALSE to override maploader automatic rotation
 */
/atom/proc/preloading_dir(datum/dmm_context/context)
	return TRUE

/**
 * Preloads before Initialize(), invoked by init from a stack recipe.
 */
/atom/proc/preload_from_stack_recipe(datum/stack_recipe/recipe)
	return
