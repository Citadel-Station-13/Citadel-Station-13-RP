//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/overmap_initializer/map

/datum/overmap_initializer/map/assemble_location(datum/map/from_source)
	return new /datum/overmap_location/map(from_source)

