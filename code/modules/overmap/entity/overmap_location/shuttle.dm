//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/overmap_location/shuttle
	//* Freeflight *//

	//* Shuttle *//

	/// the shuttle we're bound to
	var/datum/shuttle/shuttle

/datum/overmap_location/shuttle/bind(datum/shuttle/location)
	if(!istype(location))
		CRASH("unexpected type")
	shuttle = location

/datum/overmap_location/shuttle/unbind()
	if(!shuttle)
		return
	shuttle = null

/datum/overmap_location/shuttle/get_z_indices()

/datum/overmap_location/shuttle/get_owned_z_indices()

/datum/overmap_location/level/is_physically_level(z)
	return FALSE

#warn impl all
