//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Overmap location that binds to a map struct
 */
/datum/overmap_location/struct
	/// the map struct we're bound to
	var/datum/map_struct/struct

/datum/overmap_location/struct/bind(datum/map_struct/location)
	if(!istype(location))
		CRASH("unexpected type")
	if(location.overmap_binding)
		CRASH("target struct is already bound")
	struct = location
	struct.overmap_binding = src

/datum/overmap_location/struct/unbind()
	if(!struct)
		return
	struct.overmap_binding = null
	struct = null

/datum/overmap_location/struct/get_z_indices()
	return struct.constructed ? struct.z_indices.Copy() : list()

/datum/overmap_location/struct/get_owned_z_indices()
	return struct.constructed ? struct.z_indices.Copy() : list()

/datum/overmap_location/struct/is_physically_level(z)
	return (SSmapping.ordered_levels[z]?.struct == struct)
