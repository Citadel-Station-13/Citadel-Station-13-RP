//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Overmap location that binds to a map level
 */
/datum/overmap_location/level
	/// the map level we're bound to
	var/datum/map_level/level

/datum/overmap_location/level/bind(datum/map_level/location)
	if(!istype(location))
		CRASH("unexpected type")
	level = location

/datum/overmap_location/level/unbind()
	if(!level)
		return
	level = null

/datum/overmap_location/level/get_z_indices()
	return list(level.z_index)

/datum/overmap_location/level/get_owned_z_indices()
	return list(level.z_index)

/datum/overmap_location/level/is_physically_level(z)
	return z == level.z_index

#warn impl all
