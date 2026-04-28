//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

GLOBAL_LIST_EMPTY(uninitialized_shuttle_dock_preloads)

/**
 * Used to preload a shuttle dock with a shuttle.
 * * Use these over trying to VV.
 */
/obj/shuttle_dock_preload
	name = "dock preloader"
	desc = "Why do you see this? Report it."
	icon = 'icons/modules/shuttles/preload_marker.dmi'
	#warn sprite
	plane = DEBUG_PLANE
	layer = DEBUG_LAYER_SHUTTLE_MARKERS

#ifndef CF_SHUTTLE_VISUALIZE_BOUNDING_BOXES
	invisibility = INVISIBILITY_ABSTRACT
#else
	invisibility = INVISIBILITY_NONE
#endif

	maptext_height = 64
	maptext_width = 256 + 32
	maptext_x = -128

	/// already loaded data into dock?
	var/loaded_into_dock = FALSE

	/// template typepath to preload
	var/shuttle_template_path

	// TODO: ID-based instead?

/obj/shuttle_dock_preload/New()
	GLOB.uninitialized_shuttle_dock_preloads += src
	..()

/obj/shuttle_dock_preload/Initialize(mapload)
	SHOULD_CALL_PARENT(FALSE)
	preload_dock_if_possible()

/obj/shuttle_dock_preload/Destroy()
	GLOB.uninitialized_shuttle_dock_preloads -= src
	return ..()

#ifndef CF_SHUTTLE_VISUALIZE_BOUNDING_BOXES
	return INITIALIZE_HINT_QDEL
#endif

/obj/shuttle_dock_preload/proc/preload_dock_if_possible()

/obj/shuttle_dock_preload/proc/preload_dock(obj/shuttle_dock/dock)
	loaded_into_dock = TRUE
	GLOB.uninitialized_shuttle_dock_preloads -= src

#warn impl all
