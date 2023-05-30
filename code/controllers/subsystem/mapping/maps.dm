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
	for(var/datum/map/path as anything in subtypesof(/datum/map))
		if(initial(path.abstract_type) == path)
			continue
		if(isnull(path.id))
			continue
		var/datum/map/created = new path
		if(keyed_maps[created.id])
			STACK_TRACE("collision between [path] and [keyed_maps[created.id].type]")
			continue
		keyed_maps[created.id] = created

/datum/controller/subsystem/mapping/proc/write_next_map()
	#warn impl

/datum/controller/subsystem/mapping/proc/read_next_map()
	#warn impl

/datum/controller/subsystem/mapping/proc/load_map(datum/map/instance)
	#warn impl

/datum/controller/subsystem/mapping/proc/_load_map_impl(datum/map/instance, recursing = FALSE)
	#warn impl

/datum/controller/subsystem/mapping/proc/load_station(datum/map/station/instance = next_station)
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

#warn impl all
