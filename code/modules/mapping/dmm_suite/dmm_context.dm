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

	/// are we already used in a load op?
	var/used = FALSE
	/// was the loading successful?
	var/success = FALSE
	/// were map_initialization() hooks on /obj/map_helpers already fired?
	var/map_initializations_fired = FALSE

	//* set these before loading *//

	/// mangling id - if non-null, atoms under this context should
	/// use this to mangle their obfuscation IDs appropriately
	/// if they're meant to link to other devices on the same map
	var/mangling_id

	//* set by load cycle *//

	/// loaded bounds list
	var/list/loaded_bounds
	/// loaded orientation
	///
	/// * natural orientation is SOUTH
	var/loaded_orientation
	/// the dmm_parsed we loaded from
	var/datum/dmm_parsed/loaded_dmm

	//* set one way or another by things during the load cycle *//

	/// collected map_helpers asking to have map_initialization's called
	var/list/obj/map_helper/map_initialization_hooked = list()

/datum/dmm_context/proc/mark_used()
	if(used)
		CRASH("a dmm_context was reused; this is not allowed and will result in bugs.")
	used = TRUE

/datum/dmm_context/proc/fire_map_initializations()
	if(map_initializations_fired)
		CRASH("initializations already were fired")
	map_initializations_fired = TRUE
	#warn impl

/datum/dmm_context/proc/loaded()
	return success

/**
 * unload the loaded_dmm reference; use this if you're keeping this around for longer than usual so memory is reclaimed.
 */
/datum/dmm_context/proc/dispose_dmm_reference()
	loaded_dmm = null
