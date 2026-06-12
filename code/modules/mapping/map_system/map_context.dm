//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * context for mapload operations
 *
 * * unlike dmm_context, this is for the whole map.
 * * what the 'whole map' means depends on the load methodology
 * * as an example, a shuttle is its own map by default
 * * a map template when loaded by an admin manually is its own map
 * * a map helper that loads a template may or may not pass the context through
 */
/datum/map_context
	/**
	 * Mangling ID. Used to separate instances on different maps.
	 * * Used by most things that expect to only auto-link across a 'logical map'.
	 * * Generally, shuttles are not part of the same 'logical map', and templates
	 *   are optionally part of it.
	 */
	var/mangling_id

	/**
	 * Turf auto_marker configuration.
	 */
	var/datum/turf_auto_marker_config/auto_marker_config

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

	//* Added during load *//

	/// All dmm_context's loaded
	var/list/datum/dmm_context/loaded_dmm_contexts = list()

	//* Bespoke 'collected' values. *//

	/// collected gear markers
	var/list/obj/map_helper/gear_marker/collected_distributed_gear_markers
	/// collected gear markers
	var/list/obj/map_helper/gear_marker/collected_stamped_gear_markers_by_role
	/// collected role markers
	var/list/obj/map_helper/role_marker/collected_role_markers_by_tag

#warn hook all

/datum/map_context/Destroy()
	injections = null
	pre_init_callbacks = null
	post_init_callbacks = null
	loaded_dmm_contexts = null
	return ..()

/datum/map_context/proc/create_blank_dmm_context()
	RETURN_TYPE(/datum/dmm_context)
	var/datum/dmm_context/context = new
	context.map = src
	context.map_mangling_id = mangling_id
	context.auto_marker_config = auto_marker_config
	return context

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
		callback.invoke_no_sleep(src)

	Master.StopLoadingMap()
	SSatoms.map_loader_stop("map-context-callbacks")

/datum/map_context/proc/fire_post_init_callbacks()
	if(post_init_callbacks_fired)
		CRASH("post-init callbacks already were fired")
	post_init_callbacks_fired = TRUE

	for(var/datum/callback/callback as anything in post_init_callbacks)
		callback.invoke_no_sleep(src)

/datum/map_context/proc/fire_pre_init_injections()
	if(injections_pre_init_fired)
		CRASH("pre-init injections already were fired")
	injections_pre_init_fired = TRUE

	SSatoms.map_loader_begin("map-context-injections")
	Master.StartLoadingMap()

	for(var/datum/map_injection/injection in injections)
		injection.on_map_pre_init(src)

	Master.StopLoadingMap()
	SSatoms.map_loader_stop("map-context-injections")

/datum/map_context/proc/fire_post_init_injections()
	if(injections_post_init_fired)
		CRASH("post-init injections already were fired")
	injections_post_init_fired = TRUE

	for(var/datum/map_injection/injection in injections)
		injection.on_map_post_init(src)
