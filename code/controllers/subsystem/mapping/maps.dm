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

#warn impl all

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
		if(isnull(path.id))
			continue
		if(skipping[path.id])
			continue
		var/datum/map/created = new path
		if(keyed_maps[created.id])
			STACK_TRACE("collision between [path] and [keyed_maps[created.id].type]")
			continue
		keyed_maps[created.id] = created

/datum/controller/subsystem/mapping/proc/write_next_map(datum/map/station/next = next_station)
	var/path = "data/next_map.json"
	if(fexists(path))
		fdel(path)
	var/list/data = list()
	data["type"] = next.type
	if(next.modified)
		data["data"] = next.serialize()
	var/writing = file("data/next_map.json")
	WRITE_FILE(writing, json_encode(data))

/datum/controller/subsystem/mapping/proc/read_next_map()
	var/path = "data/next_map.json"
	if(!fexists(path))
		return
	var/reading = file("data/next_map.json")
	var/raw = file2text(reading)
	var/list/data = json_decode(raw)
	var/path = data["type"]
	var/list/data = data["data"]
	var/datum/map/station/wanted = new path
	if(!isnull(data))
		wanted.deserialize(data)
	next_station = wanted
	return wanted

/datum/controller/subsystem/mapping/proc/load_map(datum/map/instance)
	var/list/datum/map_level/loaded_levels = list()
	var/list/datum/callback/generation_callbacks = list()
	_load_map_impl(instance, loaded_levels, generation_callbacks)
	// invoke generation
	for(var/datum/callback/cb as anything in generation_callbacks)
		cb.Invoke()
	// invoke finalize
	for(var/datum/map_level/level as anything in loaded_levels)
		level.on_loaded_finalize(level.z_index)

	// todo: rebuild?

/datum/controller/subsystem/mapping/proc/_load_map_impl(datum/map/instance, list/datum/map_level/loaded_levels, list/datum/callback/generation_callbacks)
	// ensure any lazy data is loaded and ready to be read
	instance.prime()

	subsystem_log("Loading map [instance] ([instance.id]) with [length(instance.levels)] levels...")

	for(var/datum/map_level/level as anything in instance.levels)
		load_level(level, FALSE, instance.center, instance.crop, generation_callbacks)
		loaded_levels += level

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
		_load_map_impl(map, loaded_levels, generation_callbacks)

/datum/controller/subsystem/mapping/proc/load_station(datum/map/station/instance)
	if(isnull(instancce))
		if(isnull(next_station))
			read_next_map()
		instance = next_station
	if(isnull(instance))
		var/list/datum/map/station/valid = list()
		for(var/id in keyed_maps)
			var/datum/map/map = keyed_maps[id]
			if(!istype(map, /datum/map/station))
				continue
			valid += map
		instance = pick(valid)
	ASSERT(istype(instance))
	ASSERT(isnull(loaded_station))
	ASSERT(!initialized)
	ASSERT(!world_is_loaded)
	// bootstrap
	load_server_initial_reservation_area(instance.width, instance.height)
	// mark
	world_is_loaded = TRUE
	loaded_station = instance
	// load
	load_map(instance)
	return TRUE
