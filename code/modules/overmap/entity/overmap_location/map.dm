//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Overmap location that binds to a map map
 */
/datum/overmap_location/map
	/// the map we're bound to
	var/datum/map/map

/datum/overmap_location/map/bind(datum/map/location)
	if(!istype(location))
		CRASH("unexpected type")
	if(location.overmap_binding)
		CRASH("target map is already bound")
	map = location
	map.overmap_binding = src

/datum/overmap_location/map/unbind()
	if(!map)
		return
	map.overmap_binding = null
	map = null

/datum/overmap_location/map/get_z_indices()
	return map.loaded ? map.loaded_z_indices.Copy() : list()

/datum/overmap_location/map/get_owned_z_indices()
	return map.loaded ? map.loaded_z_indices.Copy() : list()

/datum/overmap_location/map/is_physically_level(z)
	var/datum/map_level/the_level = SSmapping.ordered_levels[z]
	return the_level.parent_map == map
