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

/datum/controller/subsystem/mapping/proc/load_map_impl(datum/map/instance)
	// unroll & ready maps
	var/list/datum/map/maps_to_load = list()
	var/list/datum/map/maps_to_iterate = list(instance)
	var/maps_to_iterate_idx = 1
	while(maps_to_iterate_idx <= length(maps_to_iterate))
		var/datum/map/iterating = maps_to_iterate[maps_to_iterate_idx]
		// TODO: if this returns FALSE, yell about it
		iterating.ready()
		for(var/id in iterating.dependencies)
			var/datum/map/resolved = resolve_map(id)
			if(resolved)
				maps_to_iterate |= resolved
			else
				#warn yell about it if it's not there
		if(!global.world_init_options.load_only_station)
			for(var/id in iterating.lateload)
				var/datum/map/resolved = resolve_map(id)
				if(resolved)
					maps_to_iterate |= resolved
				else
					#warn yell about it if it's not there

	// load maps as needed

	#warn impl

	for(var/datum/map/loading_map as anything in maps_to_load)

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
	PRIVATE_PROC(TRUE)
	// ensure any lazy data is loaded and ready to be read
	instance.prime()

	subsystem_log("Loading map [instance] ([instance.id]) with [length(instance.levels)] levels...")
	log_world("Loading map [instance] ([instance.id]) with [length(instance.levels)] levels...")

	var/list/area_cache = instance.bundle_area_cache? list() : null

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
		context_collect[++context_collect.len] = loaded_context
		loaded_levels += level

	loaded_maps += instance
	this_batch += instance

	instance.on_loaded_immediate()

	// rebuild multiz
	// this is for the lookups, which must be done immediately, as generation/hooks might require it.
	rebuild_verticality()
	rebuild_transitions()

	// todo: legacy
	for(var/path in instance.legacy_assert_shuttle_datums)
		SSshuttle.legacy_shuttle_assert(path)

	var/list/datum/map/recursing = list()

	for(var/datum/map/path_or_id as anything in instance.dependencies)
		if(ispath(path_or_id))
			path_or_id = initial(path_or_id.id)
		if(isnull(keyed_maps[path_or_id]))
			init_fatal("dependency map [path_or_id] unable to be located.")
			continue
		recursing |= keyed_maps[path_or_id]

#ifndef FASTBOOT_DISABLE_LATELOAD
	for(var/datum/map/path_or_id as anything in instance.lateload)
		if(ispath(path_or_id))
			path_or_id = initial(path_or_id.id)
		if(isnull(keyed_maps[path_or_id]))
			init_fatal("lateload map [path_or_id] unable to be located.")
			continue
		recursing |= keyed_maps[path_or_id]
#endif

	for(var/datum/map/map as anything in recursing)
		if(map.loaded)
			init_debug("skipping recursing map [map.id] - already loaded")
			continue
		load_map_impl_loop(map, loaded_levels, generation_callbacks, this_batch, context_collect)
