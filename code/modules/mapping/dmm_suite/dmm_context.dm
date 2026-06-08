//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/proc/create_dmm_context(
	mangling_id,
)
	RETURN_TYPE(/datum/dmm_context)
	var/datum/dmm_context/context = new
	context.mangling_id = mangling_id
	return context

/**
 * something accessible to all atoms during preloading_from_mapload
 *
 * * Also used to get data out of a /dmm_parsed's load() cycle
 * * **Do not reuse this between multiple maploads.**
 */
/datum/dmm_context
	//* state *//

	/// are we already used in a load op?
	var/used = FALSE
	/// was the loading successful?
	var/success = FALSE

	//* set these before loading *//

	#warn hook
	/**
	 * Our map context.
	 */
	var/datum/map_context/map
	/// set to map_context's value for speed
	var/map_mangling_id

	//* set by load cycle *//

	/// loaded bounds list
	var/list/loaded_bounds
	/// loaded orientation
	///
	/// * natural orientation is SOUTH
	var/loaded_orientation

	//* reexports of dmm_orientation variables *//
	var/loaded_orientation_invert_x
	var/loaded_orientation_invert_y
	var/loaded_orientation_swap_xy
	var/loaded_orientation_xi
	var/loaded_orientation_yi
	var/loaded_orientation_turn_angle

	/// the dmm_parsed we loaded from
	/// * This can be null.
	var/datum/dmm_parsed/loaded_dmm

/datum/dmm_context/proc/mark_used()
	if(used)
		stack_trace("a dmm_context was reused; this is not allowed and will result in bugs.")
	used = TRUE

/datum/dmm_context/proc/set_empty_load()
	loaded_bounds = new /list(MAP_BOUNDS)
	loaded_bounds[MAP_MINX] = 0
	loaded_bounds[MAP_MINY] = 0
	loaded_bounds[MAP_MINZ] = 0
	loaded_bounds[MAP_MAXX] = 0
	loaded_bounds[MAP_MAXY] = 0
	loaded_bounds[MAP_MAXZ] = 0
	var/datum/dmm_orientation/orientation_data = GLOB.dmm_orientations["[SOUTH]"]
	orientation_data.populate_context(src)

/datum/dmm_context/proc/loaded()
	return success

/**
 * unload the loaded_dmm reference; use this if you're keeping this around for longer than usual so memory is reclaimed.
 */
/datum/dmm_context/proc/dispose_dmm_reference()
	loaded_dmm = null
