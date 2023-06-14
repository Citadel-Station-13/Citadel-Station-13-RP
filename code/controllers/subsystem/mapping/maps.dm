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

/datum/controller/subsystem/mapping/proc/write_next_map(datum/map/station/next = next_station)
	var/json_path = "data/next_map.json"
	if(fexists(json_path))
		fdel(json_path)
	var/list/json = list()
	json["type"] = next.type
	if(next.modified)
		json["data"] = next.serialize()
	var/writing = file(json_path)
	WRITE_FILE(writing, json_encode(json))

/datum/controller/subsystem/mapping/proc/read_next_map()
	var/json_path = "data/next_map.json"
	if(!fexists(json_path))
		return
	var/reading = file(json_path)
	var/raw = file2text(reading)
	var/list/json = json_decode(raw)
	var/path = json["type"]
	var/list/data = json["data"]
	var/datum/map/station/wanted = new path
	if(!isnull(data))
		wanted.deserialize(data)
	next_station = wanted
	return wanted

/datum/controller/subsystem/mapping/proc/load_map(datum/map/instance)
	var/list/datum/map_level/loaded_levels = list()
	var/list/datum/map/actually_loaded = list()
	var/list/datum/callback/generation_callbacks = list()
	_load_map_impl(instance, loaded_levels, generation_callbacks, actually_loaded)
	// invoke generation
	for(var/datum/callback/cb as anything in generation_callbacks)
		cb.Invoke()
	// invoke finalize
	for(var/datum/map_level/level as anything in loaded_levels)
		level.on_loaded_finalize(level.z_index)
	// invoke global finalize
	for(var/datum/map/map as anything in actually_loaded)
		map.on_loaded_finalize()

	// todo: rebuild?

/datum/controller/subsystem/mapping/proc/_load_map_impl(datum/map/instance, list/datum/map_level/loaded_levels, list/datum/callback/generation_callbacks, list/datum/map/this_batch)
	// ensure any lazy data is loaded and ready to be read
	instance.prime()

	subsystem_log("Loading map [instance] ([instance.id]) with [length(instance.levels)] levels...")

	var/list/area_cache = instance.bundle_area_cache? list() : null

	for(var/datum/map_level/level as anything in instance.levels)
		load_level(level, FALSE, instance.center, instance.crop, generation_callbacks, instance.orientation, area_cache)
		loaded_levels += level

	loaded_maps += instance
	this_batch += instance

	instance.on_loaded_immediate()

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
		_load_map_impl(map, loaded_levels, generation_callbacks)

/datum/controller/subsystem/mapping/proc/load_station(datum/map/station/instance)
	if(isnull(instance))
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

	var/datum/map/station/changing_to = SSmapping.keyed_maps[picked]

	SSmapping.next_station = changing_to
