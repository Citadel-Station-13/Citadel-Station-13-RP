//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * this is only on the turfs inside the overmap,
 * not the turfs outside of it
 */
/area/overmap
	name = "Overmap Zone"
	#warn redo sprite?
	icon_state = "start"
	// todo: sensor update
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED

	/// our overmap
	var/datum/overmap/overmap

/area/overmap/Destroy()
	overmap = null
	return ..()
