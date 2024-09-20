//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/overmap_location/shuttle
	/// the shuttle we're bound to
	var/datum/shuttle/shuttle

/datum/overmap_location/level/bind(datum/shuttle/location)
	if(!istype(location))
		CRASH("unexpected type")
	#warn impl

/datum/overmap_location/level/unbind()
	if(!shuttle)
		return
	#warn impl

/datum/overmap_location/struct/get_z_indices()

/datum/overmap_location/struct/get_z_index_random()

#warn impl all
