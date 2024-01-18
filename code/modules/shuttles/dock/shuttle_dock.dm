//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * Shuttle docking points.
 */
/obj/shuttle_dock
	name = "shuttle dock"
	desc = "A docking port for a shuttle."
	icon = 'icons/modules/shuttles/shuttle_anchor.dmi'
	icon_state = "dock"

	//* bounding box
	/// allow docking inside bounding box as long as a shuttle fits, even if the dock doesn't align
	var/centered_landing_allowed = TRUE
	/// only allow landing inside bounding box, centered, if not manually landing; used for landing pads
	var/centered_landing_only = TRUE
	/// counted as a 'beacon' for default positionings of shuttle dockers
	var/manual_docking_beacon = TRUE
	/// protect our bounding box from manual landing
	var/protect_bounding_box = FALSE
	#warn hook
	/// shuttles are clear to land in our bounding box without the normal obstruction checks
	/// this should usually be TRUE so people can't block off areas
	var/trample_bounding_box = TRUE
	/// see /obj/shuttle_anchor for how this works; it works the same as the shuttle variant
	/// set to null for autodetect via /obj/shuttle_dock_corner
	var/size_x
	/// see /obj/shuttle_anchor for how this works; it works the same as the shuttle variant
	/// set to null for autodetect via /obj/shuttle_dock_corner
	var/size_y
	/// see /obj/shuttle_anchor for how this works; it works the same as the shuttle variant
	/// set to null for autodetect via /obj/shuttle_dock_corner
	var/offset_x
	/// see /obj/shuttle_anchor for how this works; it works the same as the shuttle variant
	/// set to null for autodetect via /obj/shuttle_dock_corner
	var/offset_y
	#warn impl

	//* docking (backend)
	/// base area to leave behind when something takes off; null for zlevel default
	var/base_area

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

	//* docking (control)
	/// docking code, if any
	var/docking_code
	/// requires docking code to dock
	var/docking_code_required = FALSE

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
	/// registered shuttle hooks
	var/list/datum/shuttle_hook/hooks
	/// shuttle web node to initialize on, if applicable; this must be a typepath.
	var/web_node_type
	/// the shuttle web node we belong to, if any
	var/datum/shuttle_web_node/web_node

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
	. = ..()
	if(. == INITIALIZE_HINT_QDEL)
		return
	return INITIALIZE_HINT_LATELOAD

/obj/shuttle_dock/LateInitialize()
	. = ..()
	if(!init_bounds())
		stack_trace("shuttle dock at [COORD(src)] failed bounds init; something is seriously wrong!")
		to_chat(
			target = world,
			html = FORMAT_SERVER_FATAL("Shuttle dock at [COORD(src)] failed to find its bounds. Please contact coders if you see this message."),
			type = MESSAGE_TYPE_SERVER_FATAL,
		)
		qdel(src)
		return
	if(!register_dock())
		stack_trace("shuttle dock at [COORD(src)] failed registration; something is seriously wrong!")
		to_chat(
			target = world,
			html = FORMAT_SERVER_FATAL("Shuttle dock at [COORD(src)] failed to register. Please contact coders if you see this message."),
			type = MESSAGE_TYPE_SERVER_FATAL,
		)
		qdel(src)
		return
	#warn CF_SHUTTLE_VISUALIZE_BOUNDING_BOXES
	#warn load shuttle

/obj/shuttle_dock/Destroy()
	unregister_dock()
	return ..()

/obj/shuttle_dock/proc/register_dock()
	#warn impl

/obj/shuttle_dock/proc/unregister_dock()
	#warn impl

/obj/shuttle_dock/proc/init_bounds()
	var/any_null = isnull(size_x) || isnull(size_y) || isnull(offset_x) || isnull(offset_y)
	var/all_null = isnull(size_x) && isnull(size_y) && isnull(offset_x) && isnull(offset_y)
	if(any_null != all_null)
		. = FALSE
		CRASH("mismatch: some, but not all bounds were null. why?")
	if(!any_null)
		return TRUE
	var/target_x = x
	var/target_y = y
	switch(dir)
		if(NORTH)
			target_y++
		if(SOUTH)
			target_y--
		if(EAST)
			target_x++
		if(WEST)
			target_x--
	for(var/datum/bounds2/bounds in GLOB.uninitialized_shuttle_dock_bounds)
		if(bounds.contains_xy(target_x, target_y))
			switch(dir)
				if(NORTH)
					size_x = bounds.x_high - bounds.x_low + 1
					size_y = bounds.y_high - bounds.y_low + 1
					offset_x = x - bounds.x_low
					offset_y = y - bounds.y_high
				if(SOUTH)
					size_x = bounds.x_high - bounds.x_low + 1
					size_y = bounds.y_high - bounds.y_low + 1
					offset_x = bounds.x_high - x
					offset_y = bounds.y_low - y
				if(EAST)
					size_y = bounds.x_high - bounds.x_low + 1
					size_x = bounds.y_high - bounds.y_low + 1
					offset_x = bounds.y_high - y
					offset_y = x - bounds.x_low
				if(WEST)
					size_y = bounds.x_high - bounds.x_low + 1
					size_x = bounds.y_high - bounds.y_low + 1
					offset_x = y - bounds.y_low
					offset_y = bounds.x_low - x
			return TRUE
	return FALSE

/obj/shuttle_dock/proc/bounding_ordered_turfs()
	ASSERT(isturf(loc))
	#warn impl

/obj/shuttle_dock/Move(...)
	return FALSE

/obj/shuttle_dock/doMove(atom/destination)
	unregister_dock()
	. = ..()
	register_dock()

/**
 * called after all hooks finish
 */
/obj/shuttle_dock/proc/on_shuttle_landed(datum/shuttle/shuttle)
	return

/**
 * called after all hooks finish
 */
/obj/shuttle_dock/proc/on_shuttle_docked(datum/shuttle/shuttle)
	return

/**
 * called after all hooks finish
 */
/obj/shuttle_dock/proc/on_shuttle_departed(datum/shuttle/shuttle)
	return

/**
 * called after all hooks finish
 */
/obj/shuttle_dock/proc/on_shuttle_undocked(datum/shuttle/shuttle)
	return

/obj/shuttle_dock/proc/shuttle_docking_authorization(datum/shuttle/shuttle)
	var/valid = shuttle.has_codes_for(src)
	if(valid)
		return SHUTTLE_DOCKING_AUTHORIZATION_VALID
	return docking_code_required? SHUTTLE_DOCKING_AUTHORIZATION_BLOCKED : SHUTTLE_DOCKING_AUTHORIZATION_INVALID

/**
 * literally just a landing pad
 */
/obj/shuttle_dock/landing_pad
	icon_state = "dock_center"
	centered_landing_only = TRUE

/**
 * ephemeral docks
 *
 * deletes when a shuttle leaves
 */
/obj/shuttle_dock/ephemeral

/obj/shuttle_dock/ephemeral/on_shuttle_departed(datum/shuttle/shuttle)
	qdel(src)

/**
 * manual dock
 */
/obj/shuttle_dock/ephemeral/manual

/**
 * transit dock
 */
/obj/shuttle_dock/ephemeral/transit
