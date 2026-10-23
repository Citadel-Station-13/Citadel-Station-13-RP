//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * Starting point for instanced role shuttles.
 * * Specifically used for dynamic role spawns that spawn in their own shuttles / maps / whatnot.
 * * Having more than one on a shuttle **hints** to the game that it should
 *   allow that many people to instance in on the shuttle. The game is free to ignore this.
 */
/obj/landmark/spawnpoint/auto_shuttle_start
	var/datum/shuttle/bound

/obj/landmark/spawnpoint/auto_shuttle_start/Initialize(mapload)
	. = ..()


#warn bind as needed

/obj/landmark/spawnpoint/auto_shuttle_start/proc/is_still_valid()
	return is_valid_turf(get_turf(src))

/obj/landmark/spawnpoint/auto_shuttle_start/proc/is_valid_turf(turf/T)
	var/area/found = T?.loc

	if(!istype(found, /area/shuttle))
		return FALSE

	var/area/shuttle/casted = found
	return casted == src.bound
