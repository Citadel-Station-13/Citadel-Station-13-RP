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
	struct = location

/datum/overmap_location/struct/unbind()
	if(!struct)
		return
	struct = null

/datum/overmap_location/struct/get_z_indices()
	return struct.z_indices.Copy()

/datum/overmap_location/struct/get_owned_z_indices()
	return struct.z_indices.Copy()

#warn impl all
