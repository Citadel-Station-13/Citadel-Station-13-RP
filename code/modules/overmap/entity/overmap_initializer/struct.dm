//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/overmap_initializer/struct

/datum/overmap_initializer/struct/assemble_location(datum/map_struct/from_source)
	return new /datum/overmap_location/struct(from_source)

