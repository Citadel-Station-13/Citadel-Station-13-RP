//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * this is only on the turfs inside the overmap,
 * not the turfs outside of it
 */
/area/overmap
	name = "Overmap Zone"
	icon = 'icons/modules/overmap/area.dmi'
	icon_state = "map"
	icon_state = "start"
	// todo: sensor update
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED
	unique = FALSE

	/// our overmap
	var/datum/overmap/overmap

/area/overmap/Destroy()
	overmap = null
	return ..()

/area/overmap/Entered(atom/movable/AM, atom/oldLoc)
	. = ..()
	if(!istype(AM, /obj/overmap/entity))
		return
	var/obj/overmap/entity/entity = AM
	entity.on_overmap_join(overmap)

/area/overmap/Exited(atom/movable/AM, atom/oldLoc)
	. = ..()
	if(!istype(AM, /obj/overmap/entity))
		return
	var/obj/overmap/entity/entity = AM
	entity.on_overmap_leave(overmap)
