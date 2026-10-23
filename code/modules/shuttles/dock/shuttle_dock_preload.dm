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

	/// access remaps; "our key" = "map key to use"
	/// * e.g. shuttle has /obj/map_helper/access_helper/auto/generic/staff with key "staff",
	///        and you're on nebula tradeport which instead sets key "trader".
	///        you specify list("staff"= "trader")
	var/list/default_access_mappings
	#warn impl

	// TODO: ID-based instead?

/obj/shuttle_dock_preload/New()
	GLOB.uninitialized_shuttle_dock_preloads += src
	..()

/obj/shuttle_dock_preload/Initialize(mapload)
	SHOULD_CALL_PARENT(FALSE)
	preload_dock_if_possible()

	// if we initialize before dock, dock should init us
	// if we initialize after dock, we should init dock
	if(!(datum_flags & DF_VAR_EDITED) && !loaded_into_dock)
		STACK_TRACE("Shuttle dock preload not loaded into dock after initialization at [AREACOORD(src)].")

#ifndef CF_SHUTTLE_VISUALIZE_BOUNDING_BOXES
	return INITIALIZE_HINT_QDEL
#else
	return ..()
#endif

/obj/shuttle_dock_preload/Destroy()
	if(!loaded_into_dock)
		GLOB.uninitialized_shuttle_dock_preloads -= src
	return ..()

/obj/shuttle_dock_preload/proc/preload_dock_if_possible()
	var/turf/our_turf = get_turf(src)
	if(!our_turf)
		return
	var/our_z = our_turf.z
	for(var/obj/shuttle_dock/dock as anything in SSshuttle.docks_by_level[our_z])
		if(dock.is_in_bounds(our_turf))
			preload_dock(dock)
			return TRUE
	return FALSE

/obj/shuttle_dock_preload/proc/preload_dock(obj/shuttle_dock/dock)
	loaded_into_dock = TRUE
	GLOB.uninitialized_shuttle_dock_preloads -= src
	#warn impl
