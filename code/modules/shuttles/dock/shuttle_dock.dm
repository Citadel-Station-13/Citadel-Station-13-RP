//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * Shuttle docking points.
 */
/obj/shuttle_dock
	name = "shuttle dock"
	desc = "A docking port for a shuttle."
	#warn icon/etc

	//* bounding box
	#warn impl

	//* identity
	/// display name - visible to everyone at all times; if null, we use name.
	var/display_name
	/// display desc - visible to everyone at all times; if null, we use desc.
	var/display_desc

	//* registration
	/// unique ID; must be unique globally, across rounds, as long as it exists
	/// if unset, this dock is assumed to be an unique datum, and any attempt to instantiate multiple copies of it will result in a runtime error.
	var/id
	/// are we registered?
	var/registered = FALSE
	#warn vv hook

	//* shuttle
	/// the docked shuttle
	var/datum/shuttle/docked
	/// starting shuttle template typepath or id
	/// only loaded on mapload, not if it's persistence loaded or anything for now
	var/starting_shuttle_template
	#warn hook

/obj/shuttle_dock/Initialize(mapload)
	if(!register_dock())
		return INITIALIZE_HINT_QDEL
	return ..()

/obj/shuttle_dock/Destroy()
	unregister_dock()
	return ..()

/obj/shuttle_dock/proc/register_dock()
	#warn impl

/obj/shuttle_dock/proc/unregister_dock()
	#warn impl



