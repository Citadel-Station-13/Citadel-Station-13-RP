//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/obj/map_helper/access_helper
	icon = 'icons/mapping/helpers/access_helpers.dmi'

/obj/map_helper/access_helper/Initialize(mapload)
	run_access_mod()
	return ..()

/obj/map_helper/access_helper/proc/run_access_mod()
	return

/obj/map_helper/access_helper/auto
	icon_state = "auto"
	/// string key to use when looking up access during a dmm_context load.
	var/lookup_key
	/// fallback to default access if lookup_key isn't found.
	/// * if this is FALSE, we instead do nothing.
	var/allow_fallback = TRUE

/obj/map_helper/access_helper/auto/proc/detect_access()
#warn impl

/**
 * Automatically binds everything in our turf to our map's access.
 * * This is a very blunt tool, as it sets everything on its tile.
 *
 * Currently supported:
 * * Airlocks
 * * APCs
 * * Closets & Crates
 */
/obj/map_helper/access_helper/auto/trample_everything

/obj/map_helper/access_helper/auto/trample_everything/run_access_mod()
	// more complex things will be harder but most entities are trivial
	var/list/obj/trivial_detections = list()

	for(var/obj/checking in loc)
		if(istype(checking, /obj/machinery/door/airlock))
			trivial_detections += checking
		else if(istype(checking, /obj/machinery/apc))
			trivial_detections += checking
		else if(istype(checking, /obj/structure/closet))
			trivial_detections += checking

	if(!length(trivial_detections))
		return

	// this may be a list or a single value
	var/detected_access = detect_access()

	#warn impl

/obj/map_helper/access_helper/auto/generic

/obj/map_helper/access_helper/auto/generic/staff
	lookup_key = "staff"

/obj/map_helper/access_helper/auto/generic/maintenance
	lookup_key = "maintenance"

/obj/map_helper/access_helper/auto/generic/public
	lookup_key = "public"

/obj/map_helper/access_helper/auto/generic/command
	lookup_key = "command"
