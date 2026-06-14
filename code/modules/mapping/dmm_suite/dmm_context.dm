//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

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
	var/datum/map_context/map_context
	/// set to map_context's value for speed
	var/map_mangling_id
	/// set to map_context's value for speed
	var/datum/turf_auto_marker_config/auto_marker_config

	//* set by load cycle *//

	/// loaded bounds list
	var/list/loaded_bounds
	/// loaded orientation
	///
	/// * natural orientation is SOUTH
	var/loaded_orientation

	//* used by loader *//

	/**
	 * Injections to fire
	 * * Injections are stateless and generally are not automatically
	 *   transferred down if a template / shuttle is considered 'not part of the map'.
	 */
	VAR_PRIVATE/list/datum/map_injection/injections
	VAR_PRIVATE/injections_pre_init_fired = FALSE
	VAR_PRIVATE/injections_post_init_fired = FALSE

	/**
	 * Callbacks to call post-load but pre-init. Called with (src).
	 * * These callbacks are fired with SSatoms under 'map_loader_begin'.
	 * * These have priority over injections.
	 */
	VAR_PRIVATE/list/datum/callback/pre_init_callbacks = list()
	VAR_PRIVATE/pre_init_callbacks_fired = FALSE

	/**
	 * Callbacks to call post-load, post-atom-init. Called with (src).
	 * * These callbacks are fired with SSatoms in normal mode.
	 * * These have priority over injections.
	 */
	VAR_PRIVATE/list/datum/callback/post_init_callbacks = list()
	VAR_PRIVATE/post_init_callbacks_fired = FALSE

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

/datum/map_context/proc/register_injection(datum/map_injection/injection)
	if(injection in injections)
		CRASH("injection already registered")
	injections |= injection

/datum/map_context/proc/register_pre_init_callback(datum/callback/cb)
	if(pre_init_callbacks_fired)
		CRASH("pre-init callbacks already were fired")
	pre_init_callbacks |= cb

/datum/map_context/proc/register_post_init_callback(datum/callback/cb)
	if(post_init_callbacks_fired)
		CRASH("post-init callbacks already were fired")
	post_init_callbacks |= cb

/datum/map_context/proc/execute_pre_init()
	fire_pre_init_callbacks()
	fire_pre_init_injections()

/datum/map_context/proc/execute_post_init()
	fire_post_init_callbacks()
	fire_post_init_injections()

/datum/map_context/proc/fire_pre_init_callbacks()
	if(pre_init_callbacks_fired)
		CRASH("pre-init callbacks already were fired")
	pre_init_callbacks_fired = TRUE

	SSatoms.map_loader_begin("map-context-callbacks")
	Master.StartLoadingMap()

	for(var/datum/callback/callback as anything in pre_init_callbacks)
		callback.invoke_no_sleep(map_context, src)

	Master.StopLoadingMap()
	SSatoms.map_loader_stop("map-context-callbacks")

/datum/map_context/proc/fire_post_init_callbacks()
	if(post_init_callbacks_fired)
		CRASH("post-init callbacks already were fired")
	post_init_callbacks_fired = TRUE

	for(var/datum/callback/callback as anything in post_init_callbacks)
		callback.invoke_no_sleep(map_context, src)

/datum/map_context/proc/fire_pre_init_injections()
	if(injections_pre_init_fired)
		CRASH("pre-init injections already were fired")
	injections_pre_init_fired = TRUE

	SSatoms.map_loader_begin("map-context-injections")
	Master.StartLoadingMap()

	for(var/datum/map_injection/injection in injections)
		injection.on_map_pre_init(map_context, src)

	Master.StopLoadingMap()
	SSatoms.map_loader_stop("map-context-injections")

/datum/map_context/proc/fire_post_init_injections()
	if(injections_post_init_fired)
		CRASH("post-init injections already were fired")
	injections_post_init_fired = TRUE

	for(var/datum/map_injection/injection in injections)
		injection.on_map_post_init(map_context, src)
