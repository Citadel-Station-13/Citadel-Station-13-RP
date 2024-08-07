//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

GLOBAL_LIST_EMPTY(uninitialized_shuttle_dock_bounds)

/**
 * put them on the corners of a bounding box to form a bounding box
 *
 * the /obj/shuttle_dock must be inside one of these
 */
/obj/shuttle_dock_corner
	name = "dock corner"
	desc = "Why do you see this? Report it."
	icon = 'icons/modules/shuttles/bounding_3x3.dmi'
	icon_state = "corner"
	plane = DEBUG_PLANE
	layer = DEBUG_LAYER_SHUTTLE_MARKERS

#ifndef CF_SHUTTLE_VISUALIZE_BOUNDING_BOXES
	invisibility = INVISIBILITY_ABSTRACT
#else
	invisibility = INVISIBILITY_NONE
#endif

	/// constructed
	var/constructed = FALSE

/obj/shuttle_dock_corner/Initialize(mapload)
	SHOULD_CALL_PARENT(FALSE)
	construct()

#ifndef CF_SHUTTLE_VISUALIZE_BOUNDING_BOXES
	return INITIALIZE_HINT_QDEL
#endif

/obj/shuttle_dock_corner/proc/construct()
	if(constructed)
		return
	var/obj/shuttle_dock_corner/bottom_left/bottom_left
	var/obj/shuttle_dock_corner/bottom_right/bottom_right
	var/obj/shuttle_dock_corner/top_left/top_left
	var/obj/shuttle_dock_corner/top_right/top_right
	var/list/processing = list(
		(type) = src,
	)
	while(length(processing))
		var/type = processing[processing.len]
		--processing.len
		var/obj/shuttle_dock_corner/corner = processing[type]
		corner.constructed = TRUE
		switch(type)
			if(/obj/shuttle_dock_corner/bottom_left)
				bottom_left = corner
				if(isnull(bottom_right))
					cardinal_scan(processing, /obj/shuttle_dock_corner/bottom_right, EAST)
				if(isnull(top_left))
					cardinal_scan(processing, /obj/shuttle_dock_corner/top_left, NORTH)
			if(/obj/shuttle_dock_corner/bottom_right)
				bottom_right = corner
				if(isnull(top_right))
					cardinal_scan(processing, /obj/shuttle_dock_corner/top_right, NORTH)
				if(isnull(bottom_left))
					cardinal_scan(processing, /obj/shuttle_dock_corner/bottom_left, WEST)
			if(/obj/shuttle_dock_corner/top_left)
				top_left = corner
				if(isnull(top_right))
					cardinal_scan(processing, /obj/shuttle_dock_corner/top_right, EAST)
				if(isnull(bottom_left))
					cardinal_scan(processing, /obj/shuttle_dock_corner/bottom_left, SOUTH)
			if(/obj/shuttle_dock_corner/top_right)
				top_right = corner
				if(isnull(top_left))
					cardinal_scan(processing, /obj/shuttle_dock_corner/top_left, WEST)
				if(isnull(bottom_right))
					cardinal_scan(processing, /obj/shuttle_dock_corner/bottom_right, SOUTH)

	if(isnull(bottom_left) || isnull(bottom_right) || isnull(top_left) || isnull(top_right))
		CRASH("missing something: bl: [COORD(bottom_left)] br: [COORD(bottom_right)] tl: [COORD(top_left)] tr: [COORD(top_right)]")
	var/datum/bounds2/bounds = new(bottom_left.x, bottom_left.y, top_right.x, top_right.y)
	if(!bounds.valid())
		CRASH("invalid bounds: bl: [COORD(bottom_left)] br: [COORD(bottom_right)] tl: [COORD(top_left)] tr: [COORD(top_right)]")
	for(var/datum/bounds2/enemy in GLOB.uninitialized_shuttle_dock_bounds)
		if(enemy.overlaps(bounds))
			CRASH("overlapping bounds [enemy.to_text()] with self [bounds.to_text()]")
	GLOB.uninitialized_shuttle_dock_bounds += bounds

/obj/shuttle_dock_corner/proc/cardinal_scan(list/injecting, wanted_type, dir)
	var/turf/T = get_turf(src)
	while(T)
		T = get_step(T, dir)
		var/obj/shuttle_dock_corner/found
		if(found = (locate(wanted_type) in T))
			injecting[found.type] = found
			return

/obj/shuttle_dock_corner/bottom_left
	dir = SOUTH

/obj/shuttle_dock_corner/bottom_right
	dir = EAST
	pixel_x = -64

/obj/shuttle_dock_corner/top_left
	dir = WEST
	pixel_y = -64

/obj/shuttle_dock_corner/top_right
	dir = NORTH
	pixel_x = -64
	pixel_y = -64
