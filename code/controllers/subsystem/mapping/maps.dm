//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * # Map System
 *
 * Allows dynamic loading of clusters of zlevels (maps) and the initialization of the server with a single station map.
 */
/datum/controller/subsystem/mapping
	/// station is loaded
	var/world_is_loaded = FALSE
	/// loaded station map
	var/static/datum/map/station/loaded_station
	/// next station map
	var/datum/map/station/next_station
	/// loaded maps
	var/static/list/datum/map/loaded_maps = list()
	/// available maps - k-v lookup by id
	var/list/datum/map/keyed_maps

/datum/controller/subsystem/mapping/Shutdown()
	. = ..()
	write_next_map()

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

/datum/controller/subsystem/mapping/proc/write_next_map(datum/map/station/next)
	if(isnull(next))
		next = next_station
	if(isnull(next))
		next = loaded_station
	var/json_path = "data/next_map.json"
	if(fexists(json_path))
		fdel(json_path)
	var/list/json = list()
	json["type"] = next.type
	json["id"] = next.id
	json["modified"] = next.modified
	if(next.modified)
		json["data"] = next.serialize()
	var/writing = file(json_path)
	var/raw = safe_json_encode(json)
	subsystem_log("writing next map [raw]")
	WRITE_FILE(writing, raw)

/datum/controller/subsystem/mapping/proc/read_next_map()
	var/datum/map/station/next_map
	var/datum/map/station/default = get_default_map()
	if(isnull(default))
		stack_trace("no default map; world init is likely going to explode.")
#ifdef FORCE_MAP
	#warn FORCE_MAP is enabled! Don't forget to disable this before pushing.
	if(keyed_maps[FORCE_MAP])
		next_map = keyed_maps[FORCE_MAP]
		subsystem_log("loaded forced map [FORCE_MAP]")
	else
		stack_trace("fail-1: failed to locate FORCE(d)_MAP [FORCE_MAP]. falling back to default.")
		subsystem_log("failed to load forced map [FORCE_MAP]")
		next_map = default
#else
	var/json_path = "data/next_map.json"
	if(!fexists(json_path))
		return
	var/reading = file(json_path)
	var/raw = file2text(reading)
	subsystem_log("read raw next map [raw]")
	var/list/json = safe_json_decode(raw)
	var/path = text2path(json["type"])
	var/id = json["id"]
	var/modified = json["modified"]
	var/list/data = json["data"]
	if(!modified)
		next_map = keyed_maps[id]
		if(isnull(next_map))
			stack_trace("fail-1: non-modified next_map id was [id], which doesn't exist. falling back to path.")
			if(!ispath(path, /datum/map/station))
				stack_trace("fail-2: non-modified map path [path] when expecting a /datum/map/station. falling back to default.")
				next_map = default
			else
				next_map = new path
	else if(!ispath(path, /datum/map/station))
		stack_trace("fail-fatal: modified map path [path] when expecting a /datum/map/station. falling back to default.")
		next_map = default
	else
		next_map = new path
		if(!isnull(data))
			next_map.deserialize(data)
#endif
	if(isnull(next_map))
		to_chat(world, SPAN_DANGER("FATAL - failed to get next map."))
		CRASH("FATAL - Failed to get next map")
	next_station = next_map
	subsystem_log("loaded map [next_station] ([next_station.id])")
	log_world("loaded map [next_station] ([next_station.id])")
	return next_map

/datum/controller/subsystem/mapping/proc/load_map(datum/map/instance)
	UNTIL(!load_mutex)
	load_mutex = TRUE
	. = _load_map(arglist(args))
	load_mutex = FALSE

/datum/controller/subsystem/mapping/proc/_load_map(datum/map/instance)
	PRIVATE_PROC(TRUE)
	var/list/datum/map_level/loaded_levels = list()
	var/list/datum/map/actually_loaded = list()
	var/list/datum/callback/generation_callbacks = list()
	var/list/datum/dmm_orientation/loaded_contexts = list()
	_load_map_impl(instance, loaded_levels, generation_callbacks, actually_loaded, loaded_contexts)
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

/datum/controller/subsystem/mapping/proc/_load_map_impl(datum/map/instance, list/datum/map_level/loaded_levels, list/datum/callback/generation_callbacks, list/datum/map/this_batch, list/context_collect)
	PRIVATE_PROC(TRUE)
	// ensure any lazy data is loaded and ready to be read
	instance.prime()

	subsystem_log("Loading map [instance] ([instance.id]) with [length(instance.levels)] levels...")
	log_world("Loading map [instance] ([instance.id]) with [length(instance.levels)] levels...")

	var/list/area_cache = instance.bundle_area_cache? list() : null

	for(var/datum/map_level/level as anything in instance.levels)
		var/datum/dmm_context/loaded_context = _load_level(level, FALSE, instance.center, instance.crop, generation_callbacks, orientation = instance.orientation, area_cache = area_cache, defer_context = TRUE)
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
		_load_map_impl(map, loaded_levels, generation_callbacks, this_batch, context_collect)

/datum/controller/subsystem/mapping/proc/load_station(datum/map/station/instance)
	if(isnull(instance))
		if(isnull(next_station))
			read_next_map()
		instance = next_station
	if(isnull(instance))
		var/list/datum/map/station/valid = list()
		for(var/id in keyed_maps)
			var/datum/map/station/map = keyed_maps[id]
			if(!istype(map, /datum/map/station))
				continue
			if(!map.allow_random_draw)
				continue
			valid += map
		instance = pick(valid)
	ASSERT(istype(instance))
	ASSERT(isnull(loaded_station))
	ASSERT(!initialized)
	ASSERT(!world_is_loaded)
	// bootstrap
	load_server_initial_reservation_area(max(instance.world_width, instance.width), max(instance.world_height, instance.height))
	// mark
	world_is_loaded = TRUE
	loaded_station = instance
	// pick gateway level - this must happen after the station is picked as it's added to the lateload list
	createRandomGatewayLevel()
	// load
	load_map(instance)
	return TRUE

/datum/controller/subsystem/mapping/proc/get_default_map()
	var/list/datum/map/station/potential = list()
	for(var/id in keyed_maps)
		var/datum/map/station/checking = keyed_maps[id]
		if(!istype(checking))
			// not a station map
			continue
		if(!checking.allow_random_draw)
			continue
		potential += checking
	return SAFEPICK(potential)

// todo: admin subsystems panel
// admin tooling for map swapping below

/client/proc/change_next_map()
	set name = "Change Map"
	set desc = "Change the next map."
	set category = "Server"

	var/list/built = list()

	for(var/id in SSmapping.keyed_maps)
		var/datum/map/station/M = SSmapping.keyed_maps[id]
		if(!istype(M))
			continue
		built[M.name] = M.id

	var/picked = input(src, "Choose the map for the next round", "Map Rotation", SSmapping.loaded_station.name) as null|anything in built

	if(isnull(picked))
		return

	var/datum/map/station/changing_to = SSmapping.keyed_maps[built[picked]]
	var/datum/map/station/was = SSmapping.next_station || SSmapping.loaded_station

	log_and_message_admins("[key_name(src)] is changing the next map from [was.name] ([was.id]) to [changing_to.name] ([changing_to.id])")

	SSmapping.next_station = changing_to
	SSmapping.write_next_map(changing_to)
