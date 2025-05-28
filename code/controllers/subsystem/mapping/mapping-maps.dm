//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * initializes the key-value store of map datums.
 */
/datum/controller/subsystem/mapping/proc/init_maps()
	keyed_maps = list()
	var/list/skipping = list()
	// if this runtimes, go vv repair it; this is fucked.
	for(var/datum/map/map as anything in loaded_maps)
		keyed_maps[map.id] = map
		skipping[map.id] = TRUE
	for(var/datum/map/path as anything in subtypesof(/datum/map))
		if(initial(path.abstract_type) == path)
			continue
		var/id = initial(path.id)
		if(isnull(id))
			continue
		if(skipping[id])
			continue
		var/datum/map/created = new path
		if(keyed_maps[created.id])
			STACK_TRACE("collision between [path] and [keyed_maps[created.id].type]")
			continue
		keyed_maps[created.id] = created

/**
 * resolves a map by ID, type, or no-op if it's an instance
 */
/datum/controller/subsystem/mapping/proc/resolve_map(datum/map/id_type_instance)
	#warn impl

/datum/controller/subsystem/mapping/proc/load_map(datum/map/instance)
	UNTIL(!map_system_mutex)
	map_system_mutex = TRUE
	. = load_map_impl(arglist(args))
	map_system_mutex = FALSE

/datum/controller/subsystem/mapping/proc/load_map_impl(datum/map/instance, from_world_load)
	emit_info_log("load: beginning load sequence of map id '[instance.id]")
	// unroll & ready maps
	var/list/datum/map/maps_to_load = list()
	var/list/datum/map/maps_to_iterate = list(instance)
	var/maps_to_iterate_idx = 1
	while(maps_to_iterate_idx <= length(maps_to_iterate))
		var/datum/map/iterating = maps_to_iterate[maps_to_iterate_idx]
		// TODO: if this returns FALSE, yell about it
		iterating.ready()

		var/list/chainload_ids = list()
		chainload_ids += iterating.dependencies
		if(!from_world_load || !global.world_init_options.load_only_station)
			chainload_ids += iterating.lateload
		emit_info_log("load - '[instance.id] - resolved chainload ids '[json_encode(chainload_ids)]'")
		for(var/id in chainload_ids)
			var/datum/map/resolved = resolve_map(id)
			if(resolved)
				maps_to_iterate |= resolved
			else
				if(from_world_load)
					emit_init_fatal("load - could not resolve map id '[id]' while resolving chainload dependencies for '[instance.id]")
				else
					emit_fatal_log("load - could not resolve map id '[id]' while resolving chainload dependencies for '[instance.id]")
				stack_trace("missing map id '[id]' during map chainload")

	// load maps as needed
	var/list/datum/map/loaded_maps = list()
	var/list/datum/map_level/loaded_lockstep_levels = list()
	var/list/datum/dmm_context/loaded_lockstep_contexts = list()

	#warn impl

	for(var/datum/map/loading_map as anything in maps_to_load)
		emit_info_log("load - loading '[instance.id]' with [length(loading_map.levels)] levels...")
		#warn impl

		var/list/use_area_cache = loading_map.load_shared_area_cache ? list() : null

		for(var/datum/map_level/level as anything in loading_map.get_sorted_levels())
			var/datum/dmm_context/loaded_context = load_level_impl()
			#warn what if it fails?

			loaded_lockstep_levels += level
			loaded_lockstep_contexts += loaded_context

		#warn impl

		loading_map.on_loaded_immediate()
		loaded_maps += loading_map

		//! LEGACY
		for(var/path in loading_map.legacy_assert_shuttle_datums)
			SSshuttle.legacy_shuttle_assert(path)
		//! END


	#warn impl


#warn below

/datum/controller/subsystem/mapping/proc/load_map_impl(datum/map/instance)
	PRIVATE_PROC(TRUE)
	var/list/datum/map_level/loaded_levels = list()
	var/list/datum/map/actually_loaded = list()
	var/list/datum/callback/generation_callbacks = list()
	var/list/datum/dmm_orientation/loaded_contexts = list()
	load_map_impl_loop(instance, loaded_levels, generation_callbacks, actually_loaded, loaded_contexts)
	// invoke hooks
	for(var/datum/dmm_context/context in loaded_contexts)
		context.fire_map_initializations()
	// invoke generation
	for(var/datum/callback/cb as anything in generation_callbacks)
		cb.Invoke()
	// invoke init
	if(initialized)
		for(var/datum/dmm_context/context in loaded_contexts)
			SSatoms.init_map_bounds(context.loaded_bounds)
	// invoke finalize
	for(var/datum/map_level/level as anything in loaded_levels)
		level.on_loaded_finalize(level.z_index)
	// invoke global finalize
	for(var/datum/map/map as anything in actually_loaded)
		map.on_loaded_finalize()
	// rebuild multiz
	// this is just for visuals
	var/list/indices_to_rebuild = list()
	for(var/datum/map_level/level as anything in loaded_levels)
		indices_to_rebuild += level.z_index
	rebuild_level_multiz(indices_to_rebuild, TRUE, TRUE)

/datum/controller/subsystem/mapping/proc/load_map_impl_loop(datum/map/instance, list/datum/map_level/loaded_levels, list/datum/callback/generation_callbacks, list/datum/map/this_batch, list/context_collect)
	for(var/datum/map_level/level as anything in instance.get_sorted_levels())
		var/datum/dmm_context/loaded_context = load_level_impl(
			level,
			FALSE,
			instance.load_auto_center,
			instance.load_auto_crop,
			generation_callbacks,
			orientation = instance.load_orientation,
			area_cache = area_cache,
			defer_context = TRUE,
		)
		if(isnull(loaded_context))
			STACK_TRACE("unable to load level [level] ([level.id])")
			message_admins(world, SPAN_DANGER("PANIC: Unable to load level [level] ([level.id])"))
			continue

	// this is for the lookups, which must be done immediately, as generation/hooks might require it.
	rebuild_verticality()
	rebuild_transitions()
