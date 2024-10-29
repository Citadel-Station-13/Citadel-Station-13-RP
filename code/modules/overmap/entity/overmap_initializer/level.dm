//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * A single level initializer.
 *
 * Usually not used. There's little need to have overmaps
 * outside of shuttles (just shuttles) and structs (planets and loaded maps).
 */
/datum/overmap_initializer/level

/datum/overmap_initializer/level/assemble_location(datum/map_level/from_source)
	return new /datum/overmap_location/level(from_source)
