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
	if(istext(id_type_instance))
		return keyed_maps[id_type_instance]
	else if(ispath(id_type_instance))
		return keyed_maps[initial(id_type_instance.id)]
	return id_type_instance

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
		maps_to_iterate_idx++
		// TODO: if this returns FALSE, yell about it
		iterating.ready()
		maps_to_load += iterating

		var/list/chainload_ids = list()
		if(length(iterating.dependencies))
			chainload_ids += iterating.dependencies
		if(!from_world_load || !global.world_init_options.load_only_station)
			if(length(iterating.lateload))
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
	var/list/datum/map_level/loaded_levels = list()

	var/list/datum/map_context/loaded_contexts = list()

	for(var/datum/map/loading_map as anything in maps_to_load)
		emit_info_log("load - loading '[loading_map.id]' with [length(loading_map.levels)] levels...")

		var/list/validation_errors = list()
		if(!loading_map.validate(TRUE, validation_errors))
			var/validation_fail_msg = "Map [loading_map.id] ([loading_map.type]) failed validation with errors [json_encode(validation_errors)]. \
				The map will be loaded anyways due to this being a subsystem-level mapload call, \
				but this round will probably break in some spectacular manner."
			STACK_TRACE(validation_fail_msg)
			to_chat(world, SPAN_BOLDANNOUNCE("SSmapping: [validation_fail_msg]"))

		if(!loading_map.construct())
			emit_init_fatal("load - could not construct map id '[loading_map.id]'; skipping")
			stack_trace("map id '[loading_map.id]' failed construct()ion")
			continue

		var/datum/map_context/context = new
		loaded_contexts += context

		context.mangling_id = loading_map.mangling_id || loading_map.id
		context.auto_marker_config = loading_map.load_auto_marker_config || new

		for(var/datum/map_injection/injection as anything in loading_map.injections)
			context.register_injection(injection)

		var/list/map_use_area_cache = loading_map.load_shared_area_cache ? list() : null

		for(var/datum/map_level/level as anything in loading_map.get_sorted_levels())
			var/datum/dmm_context/level_context = load_level_impl(
				level,
				context,
				map_use_area_cache,
			)
			if(isnull(level_context))
				emit_fatal_log("load - failed to load level '[level.id]' in map '[instance.id]")
				stack_trace("unable to load level [level] ([level.id])")
				to_chat(world, SPAN_DANGER("PANIC: Unable to load level [level] ([level.id])"))
				continue
			loaded_levels += level

		emit_info_log("load - finished loading '[instance.id]' with [length(loading_map.levels)] levels")

		loading_map.on_loaded_immediate()
		loaded_maps += loading_map

		//! LEGACY
		for(var/path in loading_map.legacy_assert_shuttle_datums)
			SSshuttle.legacy_shuttle_assert(path)
		//! END

	emit_info_log("load - initializing [length(loaded_levels)] levels...")

	// init bounds and fire post-init.
	for(var/datum/map_context/ctx as anything in loaded_contexts)
		for(var/datum/dmm_context/dmm_ctx as anything in ctx.loaded_dmm_contexts)
			if(SSatoms.initialized)
				SSatoms.init_map_bounds(dmm_ctx.loaded_bounds)
			dmm_ctx.execute_post_init()
		ctx.execute_post_init()

	// finally rebuild multiz proper
	for(var/datum/map_level/loaded_level as anything in loaded_levels)
		rebuild_multiz(loaded_level.z_index)

	emit_info_log("load - initialized [length(loaded_levels)] levels")

	return TRUE

/**
 * destroys a loaded map and frees it for later usage
 *
 * @return TRUE / FALSE based on success / fail
 */
/datum/controller/subsystem/mapping/proc/unload_map(datum/map/instance)
	CRASH("unimplemented")

/**
 * immediately de-allocates a loaded map and frees its z-index.
 *
 * **Do not use this directly unless you absolutely know what you are doing.**
 * This does not perform any cleanup, and calling this on a loaded zmap can have
 * severe consequences.
 *
 * @return TRUE / FALSE based on success / fail
 */
/datum/controller/subsystem/mapping/proc/unallocate_map(datum/map/instance)
	CRASH("unimplemented")
