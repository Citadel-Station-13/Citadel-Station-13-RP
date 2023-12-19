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
	/// allow docking inside bounding box as long as a shuttle fits, even if the dock doesn't align
	var/undocked_landing_allowed = TRUE
	/// protect our bounding box from manual landing
	var/protect_bounding_box = FALSE
	#warn hook
	/// shuttles are clear to land in our bounding box without the normal obstruction checks
	/// this should usually be TRUE so people can't block off areas
	var/trample_bounding_box = TRUE
	/// see /obj/shuttle_anchor for how this works; it works the same as the shuttle variant
	var/size_x = 0
	/// see /obj/shuttle_anchor for how this works; it works the same as the shuttle variant
	var/size_y = 0
	/// see /obj/shuttle_anchor for how this works; it works the same as the shuttle variant
	var/offset_x = 0870
	/// see /obj/shuttle_anchor for how this works; it works the same as the shuttle variant
	var/offset_y = 0
	#warn impl

	//* docking (alignment)
	/// how wide this dock's non-airtight region is.
	///
	/// the dock is left-aligned to this region,
	/// so if it's width 3,
	/// we have this:
	/// ^XX
	///
	/// the shuttle will align itself, in both direction and location, by
	/// placing itself so that the /obj/shuttle_anchor/port aligns to this /obj/shuttle_dock
	var/dock_width = 1
	/// offset the dock right in the width
	///
	/// width 3, offset 2:
	/// XX^
	///
	/// this is needed becausde dock alignment must always be exact,
	/// so things like power lines and atmos lines can be connected
	var/dock_offset = 0
	/// how many tiles of 'safety' extends to both sides of the width
	/// this is tiles like walls that are still considered airtight / sealed
	var/dock_margin = 0

	//* docking (registration)
	/// dock id - must be unique per map instance
	/// the maploader will handle ID scrambling to ensure it is unique globally, across rounds.
	///
	/// if this doesn't exist, stuff that need to hook it won't work.
	var/dock_id
	#warn id scrambling
	#warn vv hook
	/// are we registered?
	var/registered = FALSE

	//* identity
	/// display name - visible to everyone at all times; if null, we use name.
	var/display_name
	/// display desc - visible to everyone at all times; if null, we use desc.
	var/display_desc

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



