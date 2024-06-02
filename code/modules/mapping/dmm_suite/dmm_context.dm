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
	/// were /datum/map_injection's fired
	var/map_injections_fired = FALSE

	//* set these before loading *//

	/// mangling id - if non-null, atoms under this context should
	/// use this to mangle their obfuscation IDs appropriately
	/// if they're meant to link to other devices on the same map
	var/mangling_id

	/// injected middleware
	var/list/datum/map_injection/injections

	//* set by load cycle *//

	/// loaded bounds list
	var/list/loaded_bounds
	/// loaded orientation
	///
	/// * natural orientation is SOUTH
	var/loaded_orientation
	/// the dmm_parsed we loaded from
	var/datum/dmm_parsed/loaded_dmm

	//* injected by things in load cycle *//

	/// collected map_helpers asking to have map_initialization's called
	var/list/obj/map_helper/map_initialization_hooked = list()

	/// collected gear markers
	var/list/obj/map_helper/gear_marker/distributed_gear_markers
	/// collected gear markers
	var/list/obj/map_helper/gear_marker/stamped_gear_markers_by_role
	/// collected role markers
	var/list/obj/map_helper/role_marker/role_markers_by_tag

/datum/dmm_context/proc/mark_used()
	if(used)
		CRASH("a dmm_context was reused; this is not allowed and will result in bugs.")
	used = TRUE

/**
 * fire off initializations
 *
 * 1. injections
 * 2. initializations
 */
/datum/dmm_context/proc/execute_postload()
	fire_map_injections()
	fire_map_initializations()

/datum/dmm_context/proc/fire_map_initializations()
	if(map_initializations_fired)
		CRASH("initializations already were fired")
	map_initializations_fired = TRUE
	for(var/obj/map_helper/helper in map_initialization_hooked)
		// so SSatoms doesn't init the atoms we make
		// todo: better solution, this is high overhead
		Master.StartLoadingMap()
		helper.map_initializations(src)
		Master.StopLoadingMap()

/datum/dmm_context/proc/fire_map_injections()
	if(map_injections_fired)
		CRASH("injections already were fired")
	map_injections_fired = TRUE
	for(var/datum/map_injection/injection in injections)
		// so SSatoms doesn't init the atoms we make
		// todo: better solution, this is high overhead
		Master.StartLoadingMap()
		injection.injection(src)
		Master.StopLoadingMap()

/datum/dmm_context/proc/register_injection(datum/map_injection/injection)
	injections |= injection

/datum/dmm_context/proc/loaded()
	return success

/**
 * unload the loaded_dmm reference; use this if you're keeping this around for longer than usual so memory is reclaimed.
 */
/datum/dmm_context/proc/dispose_dmm_reference()
	loaded_dmm = null
