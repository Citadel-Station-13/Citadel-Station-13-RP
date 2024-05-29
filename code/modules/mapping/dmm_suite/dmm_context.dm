//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/proc/create_dmm_context(
	mangling_id,
)
	RETURN_TYPE(/datum/dmm_context)
	var/datum/dmm_context/context = new
	context.mangling_id = mangling_id
	return context

/**
 * something accessible to all atoms during preloading_instance
 *
 * also used to get data out of a /dmm_parsed's load() cycle
 *
 * **do not reuse this between multiple maploads.**
 */
/datum/dmm_context
	//* state *//
	var/used = FALSE
	var/map_initializations_fired = FALSE

	//* set these before loading *//

	/// mangling id - if non-null, atoms under this context should
	/// use this to mangle their obfuscation IDs appropriately
	/// if they're meant to link to other devices on the same map
	var/mangling_id
	#warn hook

	//* set by load cycle *//

	/// loaded bounds list
	var/list/loaded_bounds
	#warn hook
	/// loaded orientation
	///
	/// * natural orientation is SOUTH
	var/loaded_orientation
	#warn hook

	//* set one way or another by things during the load cycle *//

	/// collected map_helpers asking to have map_initialization's called
	var/list/obj/map_helper/map_initialization_hooked = list()
	#warn hook

/datum/dmm_context/proc/mark_used()
	if(used)
		CRASH("a dmm_context was reused; this is not allowed and will result in bugs.")
	used = TRUE

/datum/dmm_context/proc/fire_map_initializations()
	if(map_initializations_fired)
		CRASH("initializations already were fired")
	map_initializations_fired = TRUE
