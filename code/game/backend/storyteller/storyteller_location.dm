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
	//* if these are missing, we will use narrow phase to calculate the binding
	/// bind to an overmap object
	var/obj/overmap/entity/broad_overmap_entity
	/// bind to a list(x, y, overmap datum)
	var/list/broad_overmap_tuple
	/// bind to a string id to be considered the same id; useful for when overmaps are off
	var/broad_identifier_string

	//* narrow phase zlevel bindings
	/// virtual x/y/z tuple, obtained from SSmapping get virtual coords
	var/list/narrow_coord_tuple
	/// direct turf binding
	var/turf/narrow_turf_ref
	/// bind to an /atom/movable
	var/atom/movable/narrow_movable_ref
