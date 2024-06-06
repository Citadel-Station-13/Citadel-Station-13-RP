//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * storyteller descriptor for a location
 *
 * this is done because game locations are optimized for objectives ticking and describing where something should be,
 * while this is optimized for describing where something should **start at**.
 */
/datum/storyteller_location
	//* overmap bindings - this is used in 'broadphase', or i suppose when it's the only phase
	//* if these are missing or not being used, we will use narrow phase to calculate the binding
	/// bind to an overmap object
	var/obj/overmap/entity/broad_overmap_entity
	/// bind to a list(x, y, overmap datum); x/y are in byond tiles, not overmap distance!
	var/list/broad_overmap_tuple

	//* narrow phase zlevel bindings
	/// virtual x/y/z tuple, obtained from SSmapping get virtual coords
	var/list/narrow_coord_tuple
	/// direct turf binding
	var/turf/narrow_turf_ref
	/// bind to an /atom/movable
	var/atom/movable/narrow_movable_ref

/**
 * uses euclidean because overmaps is pixel movement / physics-simulated
 */
/datum/storyteller_location/proc/overmap_distance(datum/storyteller_location/other)
	var/list/us = overmap_tuple()
	if(isnull(us))
		return null
	var/list/them = other.overmap_tuple()
	if(isnull(them))
		return null
	// check overmap id
	if(us[3] != them[3])
		return null
	return sqrt((us[1] - them[1])**2 + (us[2] - them[2])**2)


/datum/storyteller_location/proc/overmap_tuple()
	if(!isnull(broad_overmap_entity))
		return list(broad_overmap_entity.pos_x, broad_overmap_entity.pos_y, "main")
	if(!isnull(broad_overmap_tuple))
		// we assume centered
		return list(broad_overmap_tuple[1] * OVERMAP_DISTANCE_TILE - OVERMAP_DISTANCE_TILE * 0.5, broad_overmap_tuple[2] * OVERMAP_DISTANCE_TILE - OVERMAP_DISTANCE_TILE * 0.5, "main")
	return null

/**
 * uses chebyshev becuase byond uses that for get dist / walking works like that
 */
/datum/storyteller_location/proc/turf_distance(datum/storyteller_location/other)
	var/list/us = turf_tuple()
	if(isnull(us))
		return null
	var/list/them = other.turf_tuple()
	if(isnull(them))
		return null
	// check z
	// todo: world struct/sector support
	if(us[3] != them[3])
		return null
	return max(abs(us[1] - them[1]), abs(us[2] - them[2]))

/datum/storyteller_location/proc/turf_tuple()
	if(!isnull(narrow_coord_tuple))
		return narrow_coord_tuple
	if(!isnull(narrow_turf_ref))
		return list(narrow_turf_ref.x, narrow_turf_ref.y, narrow_turf_ref.z)
	if(!isnull(narrow_movable_ref))
		var/turf/T = get_turf(narrow_movable_ref)
		if(isnull(T))
			return null
		return list(T.x, T.y, T.z)
	return null
