//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * we must always have atleast one level on the server
 * this is not quite compatible with our new maploader format,
 * so we snowflaked it by compiling a single empty space level
 * this is called during initial world loading to expand that space level to the size of the world,
 * and init it as our first reserved level.
 *
 * width and height exist to init the world's dimensions based on the map being loaded
 * this must be done before anything like spatial hashes are made, as those depend on world dimensions!
 *
 * this proc is hilariously, hilariously unstable and changes as backend changes
 * why?
 *
 * because the backend is generally extremely tightly coupled
 * as an example, the backend API assumes all level allocs are done through SSmapping,
 * so it doesn't even allow for the existnece of an unmanaged level already being there;
 * such a thing is impossible outside of severe bugs
 *
 * so in this proc, we're basically hard-setting variables - with potential issues, because
 * this can get desynced with the rest of the subsystem's code - to 'fake' such a proper init cycle.
 *
 * at some point, SSmapping will be better coded, but for now, it's pretty messy.
 */
/datum/controller/subsystem/mapping/proc/bootstrap_world(width, height)
	ASSERT(world.maxz == 1)
	world.maxx = width
	world.maxy = height
	ASSERT(length(reservation_levels) == 0)
	// basically makes allocate_level() grab the first one
	ordered_reusable_levels += 1
	ordered_levels += null
	world.max_z_changed(0, 1)
	synchronize_datastructures()
	allocate_reserved_level()

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
	bootstrap_world(max(instance.world_width, instance.width), max(instance.world_height, instance.height))
	// mark
	world_is_loaded = TRUE
	loaded_station = instance
	// pick gateway level - this must happen after the station is picked as it's added to the lateload list
	createRandomGatewayLevel()
	// load
	load_map(instance, TRUE)
	return TRUE

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
	var/datum/map/station/default = get_default_station()
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

/datum/controller/subsystem/mapping/proc/get_default_station()
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
