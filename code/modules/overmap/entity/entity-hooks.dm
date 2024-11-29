//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Overmap *//

/**
 * called when we join an overmap
 */
/obj/overmap/entity/proc/on_overmap_join(datum/overmap/map)
	SHOULD_CALL_PARENT(TRUE)
	src.overmap = map

/**
 * called when we leave an overmap
 */
/obj/overmap/entity/proc/on_overmap_leave(datum/overmap/map)
	SHOULD_CALL_PARENT(TRUE)
	src.overmap = null
