//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/overmap_location/shuttle
	//* Freeflight *//
	/// our freeflight level, if it has been created
	var/datum/map_level/freeflight

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
	. = list()
	for(var/area/A in shuttle.shuttle_area)
		// we don't support multiz shuttles so this is fine for now
		. |= A.z

/datum/overmap_location/shuttle/get_owned_z_indices()
	. = list()
	if(freeflight?.loaded)
		. += freeflight.z_index

/datum/overmap_location/shuttle/is_physically_level(z)
	return FALSE

/datum/overmap_location/shuttle/proc/create_freeflight_level()
	if(freeflight)
		return freeflight
	freeflight = SSmapping.allocate_level(/datum/map_level/freeflight)
	ASSERT(freeflight)
	refresh_level_locks()
	return freeflight
