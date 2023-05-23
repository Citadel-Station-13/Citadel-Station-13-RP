/**
 * # Map System
 *
 * Allows dynamic loading of clusters of zlevels (maps) and the initialization of the server with a single station map.
 */
/datum/controller/subsystem/mapping
	/// loaded station map
	var/datum/map/station/current_station
	/// next station map - either an instance (will be serialized before reboot) or a path or an id.
	var/next_station
	/// requested station map - either an instance or an id. this is obviously not used much after load.
	var/load_station
	/// loaded maps
	var/list/datum/map/loaded_maps
	/// available maps - k-v lookup by id
	var/list/datum/map/keyed_maps

#warn impl all

/datum/controller/subsystem/mapping/Shutdown()
	. = ..()
	write_next_map()

/datum/controller/subsystem/mapping/proc/write_next_map()

/datum/controller/subsystem/mapping/proc/read_next_map()

/datum/controller/subsystem/mapping/proc/load_map(datum/map/instance)

/datum/controller/subsystem/mapping/proc/load_station(datum/map/station/instance)

#warn impl all
