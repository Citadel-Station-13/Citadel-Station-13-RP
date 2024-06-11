//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * Shuttle docking points.
 *
 * When a shuttle docks, the shuttle aligns its docking port with our shuttle dock with some Magic Bullshit Math.
 */
/obj/shuttle_dock
	name = "shuttle dock"
	desc = "A docking port for a shuttle."
	icon = 'icons/modules/shuttles/shuttle_anchor.dmi'
	icon_state = "dock"
	atom_flags = ATOM_NONWORLD
	plane = DEBUG_PLANE
	layer = DEBUG_LAYER_SHUTTLE_MARKERS

#ifndef CF_SHUTTLE_VISUALIZE_BOUNDING_BOXES
	invisibility = INVISIBILITY_ABSTRACT
#else
	invisibility = INVISIBILITY_NONE
#endif

	//* bounding box
	/// allow docking inside bounding box as long as a shuttle fits, even if the dock doesn't align
	var/centered_landing_allowed = TRUE
	/// only allow landing inside bounding box, centered, if not manually landing; used for landing pads
	var/centered_landing_only = FALSE
	/// counted as a 'beacon' for default positionings of shuttle dockers
	var/manual_docking_beacon = TRUE
	/// protect our bounding box from manual landing
	var/protect_bounding_box = FALSE
	#warn hook
	/// shuttles are clear to land in our bounding box without the normal obstruction checks
	/// this should usually be TRUE so people can't block off areas
	var/trample_bounding_box = TRUE
	/// set the bounding box's area to a given area
	var/create_bounding_box_area = TRUE
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

	//* docking (backend)
	/// base area to leave behind when something takes off; null for zlevel default
	///
	/// this should be an unique area, like /area/space
	/// otherwise, stuff like grids will be mad at you and explode
	///
	/// alternatively, this should be an instance
	/// if this is set to a path, it'll be created or grabbed (if unique)
	///
	/// if zlevel default isn't found, defaults to world.area
	var/area/base_area

	//* docking (alignment)
	/// how wide this dock's non-airtight region is.
	///
	/// the dock is left-aligned to this region,
	/// so if it's width 3,
	/// we have this:
	/// ^XX
	///
	/// the shuttle will align itself, in both direction and location, by
	/// placing itself so that the /obj/shuttle_port aligns to this /obj/shuttle_dock
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
	var/dock_margin = 1

	//* docking (control)
	/// docking code, if any
	var/docking_code
	/// requires docking code to dock
	var/docking_code_required = FALSE

	//* docking (registration)
	/// dock id - must be unique per map instance
	/// the maploader will handle ID scrambling to ensure it is unique globally, across rounds.
	/// * if this doesn't exist, stuff that need to hook it won't work.
	/// * you can have id-less docks, they'll just not be able to be the target of a ferry and certain other things
	/// * you won't be able to bind an airlock to it either
	var/dock_id
	#warn vv hook
	/// are we registered?
	var/registered = FALSE
	/// do we register by type?
	///
	/// if we want to reference this dock by type, we must set this to TRUe.
	var/register_by_type = FALSE
	/// registered shuttle hooks
	var/list/datum/shuttle_hook/hooks
	/// shuttle web node to initialize on, if applicable; this must be a typepath.
	/// todo: data-defined web nodes, aka allow strings and de/serialization.
	var/web_node_type
	/// the shuttle web node we belong to, if any
	var/datum/shuttle_web_node/web_node

	//* docking (protection)
	/// only allow a hardcoded shuttle of this id (or these ids) to dock
	///
	/// this, if set, does not automatically include our starting template
	/// unless docking_hard_restrict_to_starting is also set!
	/// we can have the starting template locked out due to that.
	///
	/// set to typepath / list of typepaths of shuttle templates if you want to automatically resolve these.
	var/docking_hard_restrict
	#warn hook
	/// automatically lock to the type of our starting shuttle template
	var/docking_hard_restrict_to_starting = FALSE
	#warn hook

	//* identity
	/// display name - visible to everyone at all times; if null, we use name.
	var/display_name
	/// display desc - visible to everyone at all times; if null, we use desc.
	var/display_desc

	//* shuttle
	/// the docked shuttle
	var/datum/shuttle/docked
	/// the shuttle that's currently inbound while in transit
	/// if set, **we are a protected dock, and no other shuttle should arrive during this time!**
	///
	/// * this is a hard protection that should not be overridden by anything
	/// * if you don't want shuttles to do that to this dock, the shuttle side should specify DO_NOT_MUTEX as a transit flag.
	var/datum/shuttle/inbound
	/// starting shuttle template typepath or id
	/// only loaded on mapload, not if it's persistence loaded or anything for now
	var/starting_shuttle_template
	/// load starting shuttle centered instead of aligned to its primary port
	///
	/// if a shuttle cannot fit in our bounding box if aligned,
	/// and cannot trample things,
	/// it will do this anyways.
	///
	/// if a shuttle still cannot fit when centered,
	/// uhh,
	/// idk lol i'll just call it 'undefined behavior' when shit explodes
	///p
	/// note: centered docking counts as 'nonaligned docking',
	///       meanining shuttle hooks like airlocks won't count it as docked.
	var/starting_shuttle_always_center = FALSE
	/// ignore bounding box and trample things when loading starting shuttle
	var/starting_shuttle_allow_trample = TRUE
	/// in-progress dock/undock operation
	var/datum/event_args/shuttle/dock/currently_docking
	/// in-progress move operation
	var/datum/event_args/shuttle/movement/currently_moving

	#warn hook

/obj/shuttle_dock/preloading_instance(with_id)
	. = ..()
	dock_id = SSmapping.mangled_persistent_id(dock_id, with_id)

/**
 * @params
 * * mapload - passed in by SSatoms
 * * with_id - the id to set this to / override this to
 * * sx_sy_ox_oy - size x, size y, offset x, offset y; used to force our bounds to something.
 */
/obj/shuttle_dock/Initialize(mapload, with_id, list/sx_sy_ox_oy)
	. = ..()
	if(!isnull(with_id))
		src.dock_id = with_id
	if(!isnull(sx_sy_ox_oy))
		size_x = sx_sy_ox_oy[1]
		size_y = sx_sy_ox_oy[2]
		offset_x = sx_sy_ox_oy[3]
		offset_y = sx_sy_ox_oy[4]
	if(. == INITIALIZE_HINT_QDEL)
		return
	return INITIALIZE_HINT_LATELOAD

/obj/shuttle_dock/LateInitialize()
	. = ..()
	if(!detect_bounds())
		stack_trace("shuttle dock at [COORD(src)] failed bounds detect; something is seriously wrong!")
		to_chat(
			target = world,
			html = FORMAT_SERVER_FATAL("Shuttle dock at [COORD(src)] failed to find its bounds. Please contact coders if you see this message."),
			type = MESSAGE_TYPE_SERVER_FATAL,
		)
		qdel(src)
		return
	if(!check_bounds())
		stack_trace("shuttle dock at [COORD(src)] failed bounds checking; something is seriously wrong!")
		to_chat(
			target = world,
			html = FORMAT_SERVER_FATAL("Shuttle dock at [COORD(src)] failed its bounds check. Please contact coders if you see this message."),
			type = MESSAGE_TYPE_SERVER_FATAL,
		)
		qdel(src)
		return
	if(!init_bounds())
		stack_trace("shuttle dock at [COORD(src)] failed bounds init; something is seriously wrong!")
		to_chat(
			target = world,
			html = FORMAT_SERVER_FATAL("Shuttle dock at [COORD(src)] failed its bounds init. Please contact coders if you see this message."),
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
	var/datum/shuttle/loaded
	if(starting_shuttle_template)
		if(!(loaded = load_shuttle()))
			stack_trace("shuttle dock at [COORD(src)] failed to load its roundstart shuttle; something is seriously wrong!")
			to_chat(
				target = world,
				html = FORMAT_SERVER_FATAL("Shuttle dock at [COORD(src)] failed to load its starting template. Please contact coders if you see this message."),
				type = MESSAGE_TYPE_SERVER_FATAL,
			)
		else
			init_shuttle(loaded)
			ready_shuttle(loaded)

/obj/shuttle_dock/Destroy()
	inbound?.controller?.abort_transit()
	inbound = null
	unregister_dock()
	// cleanup our area
	if(create_bounding_box_area && base_area?.unique)
		var/list/turfs = bounding_north_ordered_turfs()
		for(var/turf/T in turfs)
			if(T.loc == base_area)
				continue
			turfs -= T
		var/area/world_base_area = dynamic_area_of_type(SSmapping.level_base_area(z))
		world_base_area.take_turfs(turfs)
		qdel(base_area)
	return ..()

/obj/shuttle_dock/proc/register_dock()
	return SSshuttle.register_dock(src)

/obj/shuttle_dock/proc/unregister_dock()
	return SSshuttle.unregister_dock(src)

/obj/shuttle_dock/Move(...)
	return FALSE

/obj/shuttle_dock/doMove(atom/destination)
	if(create_bounding_box_area)
		CRASH("we cannot move a shuttle dock if it creates its own area.")
	unregister_dock()
	. = ..()
	if(!check_bounds())
		stack_trace("shuttle dock got moved somewhere where its bounds fail checks.")
		return
	register_dock()

/**
 * called after all hooks finish
 */
/obj/shuttle_dock/proc/on_shuttle_landed(datum/shuttle/shuttle, datum/event_args/shuttle/dock/arrived/e_args)
	return

/**
 * called after all hooks finish
 */
/obj/shuttle_dock/proc/on_shuttle_docked(datum/shuttle/shuttle, datum/event_args/shuttle/dock/docked/e_args)
	return

/**
 * called after all hooks finish
 */
/obj/shuttle_dock/proc/on_shuttle_departed(datum/shuttle/shuttle, datum/event_args/shuttle/dock/departed/e_args)
	return

/**
 * called after all hooks finish
 */
/obj/shuttle_dock/proc/on_shuttle_undocked(datum/shuttle/shuttle, datum/event_args/shuttle/dock/undocked/e_args)
	return

/obj/shuttle_dock/proc/shuttle_docking_authorization(datum/shuttle/shuttle)
	if(docking_hard_restrict)
		#warn redo
		if(islist(docking_hard_restrict) && !(shuttle.type in docking_hard_restrict))
			return SHUTTLE_DOCKING_AUTHORIZATION_BLOCKED
		else if(shuttle.type != docking_hard_restrict)
			return SHUTTLE_DOCKING_AUTHORIZATION_BLOCKED
	var/valid = shuttle.has_codes_for(src)
	if(valid)
		return SHUTTLE_DOCKING_AUTHORIZATION_VALID
	return docking_code_required? SHUTTLE_DOCKING_AUTHORIZATION_BLOCKED : SHUTTLE_DOCKING_AUTHORIZATION_INVALID

//* docking - backend *//

/**
 * get the area instance that should be left behind
 */
/obj/shuttle_dock/proc/base_area_instance()
	if(!istype(base_area))
		base_area = dynamic_area_of_type(base_area || SSmapping.level_base_area(z))
	return base_area

//* docking - bounding box *//

/**
 * should we protect our bounding box *right now*?
 */
/obj/shuttle_dock/proc/should_protect_bounding_box()
	// if a shuttle is inbound, to prevent more expensive orchestration,
	// we just fully protect our bounding box.
	// todo: someday we should have a visual for seeing that a shuttle is inbound in docker mode?
	return protect_bounding_box || inbound

//* init *//

/**
 * loads our roundstart shuttle
 *
 * @return /datum/shuttle
 */
/obj/shuttle_dock/proc/load_shuttle(datum/shuttle_template/force_template)
	RETURN_TYPE(/datum/shuttle)
	#warn impl

/**
 * initializes our roundstart shuttle (usually by giving it a controller)
 */
/obj/shuttle_dock/proc/init_shuttle(datum/shuttle/shuttle)
	return

/**
 * called after our initial shuttle is loaded and initialized
 */
/obj/shuttle_dock/proc/ready_shuttle(datum/shuttle/loaded)
	return

//* bounding box *//

/obj/shuttle_dock/proc/check_bounds()
	#warn ensure not out of bounds/nullspace.

/obj/shuttle_dock/proc/init_bounds()
	if(create_bounding_box_area)
		var/list/turfs = bounding_north_ordered_turfs()
		var/area/area_instance = base_area_instance()
		area_instance.take_turfs(turfs)
	return TRUE

/obj/shuttle_dock/proc/detect_bounds()
	var/any_null = isnull(size_x) || isnull(size_y) || isnull(offset_x) || isnull(offset_y)
	var/all_null = isnull(size_x) && isnull(size_y) && isnull(offset_x) && isnull(offset_y)
	if(any_null != all_null)
		. = FALSE
		CRASH("mismatch: some, but not all bounds were null. why?")
	if(!any_null)
		return TRUE
	var/target_x = x
	var/target_y = y
	// we are aligned so don't move forwards 1
	// switch(dir)
	// 	if(NORTH)
	// 		target_y++
	// 	if(SOUTH)
	// 		target_y--
	// 	if(EAST)
	// 		target_x++
	// 	if(WEST)
	// 		target_x--
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

/**
 * always returns assuming NORTH orientation
 */
/obj/shuttle_dock/proc/bounding_north_ordered_turfs()
	ASSERT(isturf(loc))
	switch(dir)
		if(NORTH)
			return SSgrids.get_ordered_turfs(
				x - offset_x,
				x + size_x - 1 - offset_x,
				y - size_y + 1,
				y - offset_y,
				z,
				NORTH,
			)
		if(SOUTH)
			return SSgrids.get_ordered_turfs(
				x - size_x + 1 + offset_x,
				x + offset_x,
				y - offset_y,
				y + size_y - offset_y - 1,
				z,
				NORTH,
			)
		if(EAST)
			return SSgrids.get_ordered_turfs(
				x - size_y + 1 + offset_y,
				x + offset_y,
				y - size_x + 1 + offset_x,
				y + offset_x,
				z,
				NORTH,
			)
		if(WEST)
			return SSgrids.get_ordered_turfs(
				x - offset_y,
				x + size_y - 1 - offset_y,
				y - offset_x,
				y + size_x - 1 - offset_x,
				z,
				NORTH,
			)

/**
 * get real (non-directional) bounding box lowerleft/upperright x/y's
 *
 * @return list(llx, lly, urx, ury)
 */
/obj/shuttle_dock/proc/absolute_llx_lly_urx_ury_coords()
	var/turf/location = get_turf(src)

	var/anchor_x
	var/anchor_y
	var/anchor_z

	anchor_x = location.x
	anchor_y = location.y
	anchor_z = location.z

	// take a guess as to what these mean (lowerleft/upperright x/y)
	var/real_llx
	var/real_lly
	var/real_urx
	var/real_ury

	switch(dir)
		if(NORTH)
			real_llx = anchor_x - offset_x
			real_lly = anchor_y + offset_y - (size_y - 1)
			real_urx = anchor_x - offset_x + (size_x - 1)
			real_ury = anchor_y + offset_y
		if(SOUTH)
			real_llx = anchor_x + offset_x - (size_x - 1)
			real_lly = anchor_y - offset_y
			real_urx = anchor_x + offset_x
			real_ury = anchor_y - offset_y + (size_y - 1)
		if(EAST)
			real_llx = anchor_x + offset_y - (size_y - 1)
			real_lly = anchor_y + offset_x - (size_x - 1)
			real_urx = anchor_x + offset_y
			real_ury = anchor_y + offset_x
		if(WEST)
			real_llx = anchor_x - offset_y
			real_lly = anchor_y - offset_x
			real_urx = anchor_x - offset_y + (size_y - 1)
			real_ury = anchor_y - offset_x + (size_x - 1)

	return list(
		real_llx,
		real_lly,
		real_urx,
		real_ury,
	)

/**
 * if center is split on a turf, we go with the lower number.
 *
 * @return list(llx, lly, urx, ury, cx, cy) where c is 'center'
 */
/obj/shuttle_dock/proc/absolute_bounding_box_coords()
	var/list/augmenting = absolute_llx_lly_urx_ury_coords()
	augmenting += round(augmenting[1] + (augmenting[3] - augmenting[1]) / 2) // 5
	augmenting += round(augmenting[2] + (augmenting[4] - augmenting[2]) / 2) // 6
	return augmenting


//* grid moves handling - we don't move as nested shuttle support isn't a thing yet *//

/obj/shuttle_dock/grid_move(grid_flags, turf/new_turf)
	return

/obj/shuttle_dock/grid_after(grid_flags, rotation_angle, list/late_call_hooks)
	return

/obj/shuttle_dock/grid_collect(grid_flags, turf/new_turf, loc_opinion)
	return

/obj/shuttle_dock/grid_finished(grid_flags, rotation_angle)
	return
