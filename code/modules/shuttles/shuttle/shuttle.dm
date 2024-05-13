//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * # Shuttles
 *
 * Core datum for shuttles.
 *
 * ## Controllers
 *
 * All shuttle behaviors are now in controllers whenever possible. The base datum just handles the actual shuttle itself.
 * Moving to transit and staying in transit? That's a controller thing. Temporary dynamic transit? That's a controller thing, too.
 *
 * todo: nestable-shuttle support ? e.g. transport ship on a shuttle ; this is not optimal for performance but sure is cool
 * todo: multi-z shuttles; is this even possible? very long term.
 * todo: areas is a shit system. this is probably not fixable, because how else would we do bounding boxes?
 * todo: it would sure be nice to be able to dynamically expand shuttles in-game though; probably a bad idea too.
 * todo: serialize/deserialize, but should it be on this side or the map tempalte side? we want save/loadable.
 */
/datum/shuttle
	//* Intrinsics
	/// real / code name
	var/name = "Unnamed Shuttle"
	/// are we mid-delete? controls whether we, and our components are immune to deletion.
	var/being_deleted = FALSE
	/// our globally persistent-unique identifier string
	var/id
	/// our unique template id; this is *not* our ID and is *not* unique!
	var/template_id
	/// our descriptor instance; this is what determines how we act
	/// to our controller, as well as things like overmaps.
	var/datum/shuttle_descriptor/descriptor

	//* Composition
	/// our shuttle controller
	var/datum/shuttle_controller/controller
	/// our physical shuttle object
	var/obj/shuttle_anchor/anchor
	/// our physical shuttle port objects
	var/list/obj/shuttle_port/ports
	/// port lookup by id
	var/list/obj/shuttle_port/port_lookup
	/// our primary port, if any.
	/// roundstart docking will use this port.
	var/obj/shuttle_port/port_primary
	/// the areas in our shuttle, associated to a truthy value
	var/list/area/shuttle/areas

	//* Docking
	/// where we are docked, if any
	var/obj/shuttle_dock/docked
	/// in-progress dock/undock operation
	var/datum/event_args/shuttle/dock/currently_docking
	/// in-progress move operation
	var/datum/event_args/shuttle/movement/currently_moving
	/// the port we're using
	var/obj/shuttle_port/docked_via_port

	//* Movement - Ephemeral / In-Move
	/// current direction of motion, used to calculate things like visuals and roadkill
	var/translating_physics_direction
	/// corrosponds, index-wise, to the left-to-right strip of clear turfs in front of the shuttle in the direction of motion
	var/list/translating_forwards_lookup
	/// corrosponds, index-wise, to the forwards-to-backwards strip of clear turfs left of the direction of motion
	var/list/translating_left_lookup
	/// corrosponds, index-wise, to the forwards-to-backwards strip of clear turfs right of the direction of motion
	var/list/translating_right_lookup
	/// used to calculate forward lookup index by adding to the:
	///
	/// * x-value of turf if north/south
	/// * y-value of turf if east/west
	///
	/// this value is to be applied to things in the **destination**
	/// bounding box!!
	var/translating_forward_offset
	/// used to calculate side lookup index by adding to the:
	///
	/// * y-value of turf if north/south
	/// * x-value if turf is east/west
	///
	/// this value is to be applied to things in the **destination**
	/// bounding box!!
	var/translating_side_offset
	/// current width of front
	var/translating_forward_width
	/// current length of side
	var/translating_side_length

	#warn ugh

	//* Hooks
	/// registered shuttle hooks
	var/list/datum/shuttle_hook/hooks

	//* Identity
	/// player-facing name
	var/display_name

	//* Preview
	/// lower-left aligned preview overlay; used for shuttle dockers and similar
	/// the generated preview will be **north** facing
	/// turn it via transform matrices only!
	var/mutable_appearance/preview_overlay
	/// generated preview height (Y axis) in tiles
	var/preview_height
	/// generated preview width (X axis) in tiles
	var/preview_width
	/// last time preview was regenerated
	var/preview_generated_at

	//* Structure
	/// if set, we generate a ceiling above the shuttle of this type, on the bottom of the turf stack.
	//  todo: vv hook this
	var/ceiling_type = /turf/simulated/shuttle_ceiling

	//* Transit
	/// Shuttle is in transit
	var/in_transit = FALSE
	/// Current transit reservation
	var/datum/turf_reservation/in_transit_reservation
	/// Current transit dock
	var/obj/shuttle_dock/ephemeral/transit/in_transit_dock

	//* legacy stuff
	// todo: this should be a default, and engine/takeoff type (?) can override
	var/legacy_sound_takeoff = 'sound/effects/shuttles/shuttle_takeoff.ogg'
	var/legacy_sound_landing = 'sound/effects/shuttles/shuttle_landing.ogg'
	var/legacy_takeoff_knockdown = 1.5 SECONDS
	var/list/obj/structure/fuel_port/legacy_fuel_ports = list()

#warn impl all

/datum/shuttle/Destroy()
	QDEL_NULL(descriptor)
	QDEL_NULL(controller)
	QDEL_LIST(ports)
	port_lookup = null
	port_primary = null
	QDEL_NULL(anchor)
	#warn areas
	#warn hooks
	preview_overlay = null
	preview_width = null
	preview_height = null
	#warn de-dock
	#warn de-transit
	#warn de-move

	//! legacy
	legacy_fuel_ports = null
	//! end

	return ..()

//* Initialization *//

/**
 * Called after all areas are made and all turfs are there,
 * but before atoms initialization.
 *
 * Used to auto-register everything
 *
 * **Extremely dangerous proc. Don't call it unless you know what you're doing.**
 */
/datum/shuttle/proc/before_bounds_init(datum/turf_reservation/from_reservation, datum/shuttle_template/from_template)
	SHOULD_NOT_OVERRIDE(TRUE)
	var/list/area/shuttle/area_cache = list()
	areas = list()
	ports = list()
	anchor = null
	// we do our own calculations always, because we cannot assume the map template is trimmed properly.
	var/bottomleft_x = INFINITY
	var/bottomleft_y = INFINITY
	var/topright_x = -INFINITY
	var/topright_y = -INFINITY
	// scan turfs & collect
	for(var/turf/scanning in from_reservation.get_unordered_turfs())
		if(!istype(scanning.loc, /area/shuttle))
			continue
		if(!area_cache[scanning.loc])
			var/area/shuttle/initializing = scanning.loc
			area_cache[scanning.loc] = initializing
			initializing.before_bounds_initializing(src, from_reservation, from_template)
		bottomleft_x = min(bottomleft_x, scanning.x)
		bottomleft_y = min(bottomleft_y, scanning.y)
		topright_x = max(topright_x, scanning.x)
		topright_y = max(topright_y, scanning.y)
		// make superstructure
		// todo: make superstructure a thing *maybe?*
		// new /obj/shuttle_structure(scanning)
		// todo: probably make sure baseturfs are fine
		var/static/list/cared_about_typecache = typecacheof(list(
			/obj/shuttle_anchor,
			/obj/shuttle_port,
		))
		for(var/atom/movable/AM as anything in scanning.contents)
			if(!cared_about_typecache[AM.type])
				continue
			if(istype(AM, /obj/shuttle_anchor))
				if(!isnull(anchor))
					stack_trace("duplicate anchor during init scan")
				anchor = AM
			else if(istype(AM, /obj/shuttle_port))
				var/obj/shuttle_port/port = AM
				ports += port
				if(port.primary_port)
					if(!port_primary)
						port_primary = port
					else
						stack_trace("duplicate primary port during init scan")
						port.primary_port = FALSE
				if(port.port_id)
					if(port_lookup[port.port_id])
						stack_trace("id collision on port id [port.port_id] (mangled)")
						port.port_id = null
					else
						port_lookup[port.port_id] = port

	// collect areas
	for(var/area/scanning in area_cache)
		areas[scanning] = TRUE
	// if we don't have an anchor, make one
	if(isnull(anchor))
		var/turf/center = from_reservation.get_approximately_center_turf()
		anchor = new(center)
	anchor.calculate_bounds(bottomleft_x, bottomleft_y, topright_x, topright_y, from_template.facing_dir)
	anchor.before_bounds_initializing(src, from_reservation, from_template)
	for(var/obj/shuttle_port/port in ports)
		port.before_bounds_initializing(src, from_reservation, from_template)

/**
 * Called after the bounds have initialized their atoms/areas
 *
 * **Extremely dangerous proc. Don't call / override it unless you know what you're doing.**
 */
/datum/shuttle/proc/after_bounds_init(datum/turf_reservation/from_reservation, datum/shuttle_template/from_template)
	return

/**
 * bind a controller to us
 */
/datum/shuttle/proc/bind_controller(datum/shuttle_controller/binding)
	. = FALSE
	ASSERT(isnull(binding.shuttle) && isnull(controller))
	controller = binding
	if(!controller.initialize(src))
		controller = null
		CRASH("controller refused to init")
	return TRUE

//* Bounding Box *//

/**
 * returns with the current direction of the shuttle
 */
/datum/shuttle/proc/aabb_ordered_turfs_here()
	return anchor.aabb_ordered_turfs_here()

/datum/shuttle/proc/aabb_ordered_turfs_at(turf/anchor, direction)
	return src.anchor.aabb_ordered_turfs_at(anchor, direction)

/datum/shuttle/proc/shuttle_turfs_here()
	return SSgrids.filter_ordered_turfs_via_area(areas, aabb_ordered_turfs_here())

/datum/shuttle/proc/shuttle_turfs_at(turf/anchor, direction)
	return SSgrids.filter_ordered_turfs_via_area(areas, aabb_ordered_turfs_at(anchor, direction))

//* Docking - Control *//

/**
 * checks if have docking codes for a dock
 */
/datum/shuttle/proc/has_codes_for(obj/shuttle_dock/dock)
	return controller?.has_codes_for(dock)

//* Docking - Action Helpers *//


/datum/shuttle/proc/

#warn AAAAAAAAAAAAAAAAAAAAAAAAA

//* Docking - Handling *//

/**
 * handles when an overlap occurs
 *
 * this is called before movable_overlap_handler.
 */
/datum/shuttle/proc/turf_overlap_handler(turf/from_turf, turf/to_turf)
	if(!to_turf.density)
		return
	// walls: obliteration.
	if(istype(to_turf, /turf/simulated/wall))
		var/turf/simulated/wall/wall = to_turf
		wall.atom_destruction(ATOM_DECONSTRUCT_DESTROYED)

/**
 * handles when an overlap occurs
 *
 * overlap always occurs on any movables that are non abstract and considered a game object
 */
/datum/shuttle/proc/movable_overlap_handler(atom/movable/entity, turf/from_turf, turf/to_turf)
	// we don't check for non-game/abstract, SSgrids does that.

	// get index in frontal pass
	// this is effectively our position left to right
	// 1 = leftmost turf of shuttle
	// matching [translating_forward_width] = rightmost turf of shuttle
	var/forward_lookup_index
	// get index in side pass
	// this is effectively our position front to back
	// 1 = frontmost turf of shuttle
	// matching [translating_side_length] = rearmost turf of shuttle
	var/side_lookup_index
	switch(translating_physics_direction)
		if(NORTH, SOUTH)
			forward_lookup_index = entity.x + translating_forward_offset
			side_lookup_index = entity.y + translating_side_offset
		if(EAST, WEST)
			forward_lookup_index = entity.y + translating_forward_offset
			side_lookup_index = entity.x + translating_side_offset

	// see if we should be kicked towards side
	var/use_side_heuristic = (forward_lookup_index > SHUTTLE_OVERLAP_FRONT_THRESHOLD) \
		&& ((side_lookup_index <= SHUTTLE_OVERLAP_SIDE_THRESHOLD) || (side_lookup_index > (translating_forward_width - SHUTTLE_OVERLAP_SIDE_THRESHOLD)))

	// get the cached target
	var/turf/overall_target = use_side_heuristic? (
			(side_lookup_index > (translating_forward_width / 2))? \
				translating_right_lookup[side_lookup_index] : \
				translating_left_lookup[side_lookup_index] \
		) : \
		(translating_forwards_lookup[forward_lookup_index])
	var/should_annihilate

	if(isnull(overall_target))
		// if no target, generate one
		var/turf/current_turf = get_turf(entity)
		if(use_side_heuristic)
			overall_target = movable_overlap_side_heuristic(
				current_turf,
				translating_physics_direction,
				side_lookup_index,
				forward_lookup_index,
			) || movable_overlap_front_heuristic(
				current_turf,
				translating_physics_direction,
				side_lookup_index,
				forward_lookup_index,
			) || SHUTTLE_OVERLAP_NO_FREE_SPACE
		else
			var/side_forgiveness = (forward_lookup_index <= SHUTTLE_OVERLAP_SIDE_FORGIVENESS \
				|| forward_lookup_index > (translating_forward_width - SHUTTLE_OVERLAP_SIDE_FORGIVENESS))
			overall_target = movable_overlap_front_heuristic(
				current_turf,
				translating_physics_direction,
				side_lookup_index,
				forward_lookup_index,
			) || (side_forgiveness && movable_overlap_side_heuristic(
				current_turf,
				translating_physics_direction,
				side_lookup_index,
				forward_lookup_index,
			)) || SHUTTLE_OVERLAP_NO_FREE_SPACE

			// cache; if we found none, we just tell stuff to get annihilated on hit
			translating_forwards_lookup[forward_lookup_index] = overall_target || SHUTTLE_OVERLAP_NO_FREE_SPACE

	if(overall_target == SHUTTLE_OVERLAP_NO_FREE_SPACE)
		// if we accepted there's no space,
		// obliterate it if possible
		should_annihilate = TRUE
		overall_target = movable_overlap_calculate_front_turf(entity, translating_physics_direction, side_lookup_index)

	// tell it to do stuff
	entity.shuttle_crushed(src, overall_target, should_annihilate)

// todo: get rid of all translating_ instance vars
/datum/shuttle/proc/movable_overlap_front_heuristic(turf/from_turf, direction, side_index, forward_index)
	var/forward_width = translating_forward_width

	var/turf/center = movable_overlap_calculate_front_turf(from_turf, direction, side_index)
	if(!center.density)
		return center

	var/turf/left = center
	var/turf/right = center

	var/left_dir = turn(direction, 90)
	var/right_dir = turn(direction, -90)

	for(var/i in 1 to SHUTTLE_OVERLAP_FRONT_DEFLECTION)
		// left
		if((forward_index - i) >= 1)
			left = get_step(left, left_dir)
		// right
		if((forward_index + i) <= (forward_width))
			right = get_step(right, right_dir)

		if(!left.density)
			if(!right.density)
				return pick(left, right)
			return left
		else if(!right.density)
			return right

// todo: get rid of all translating_ instance vars
/datum/shuttle/proc/movable_overlap_side_heuristic(turf/from_turf, direction, side_index, forward_index)
	var/midpoint = (translating_forward_width + 1) / 2
	var/go_left = (forward_index == midpoint)? prob(50) : (forward_index < midpoint)

	var/turf/center = go_left? \
		movable_overlap_calculate_left_turf(from_turf, direction, forward_index, translating_forward_width) : \
		movable_overlap_calculate_right_turf(from_turf, direction, forward_index, translating_forward_width)

	if(!center.density)
		return center

	// always slam them forwards if possible
	var/forwards_dir = direction
	var/turf/forwards = center
	for(var/i in 1 to min(SHUTTLE_OVERLAP_SIDE_FORWARDS_DEFLECTION, side_index))
		forwards = get_step(forwards, forwards_dir)
		if(!forwards.density)
			return forwards

	// then slam backwards if needed
	var/backwards_dir = turn(direction, 180)
	var/turf/backwards = center
	for(var/i in 1 to min(SHUTTLE_OVERLAP_SIDE_BACKWARDS_DEFLECTION, translating_side_length - side_index + 1))
		backwards = get_step(backwards, backwards_dir)
		if(!backwards.density)
			return backwards

/datum/shuttle/proc/movable_overlap_calculate_front_turf(atom/movable/entity, direction, side_index)
	// we abuse side_lookup_index to shift us forwards to the first tile that isn't the shuttle.
	// the shuttle system **should** prevent us from ever clipping through the zlevel borders
	// thanks to the bounding clip checks before movement.
	switch(direction)
		if(NORTH)
			return locate(
				entity.x,
				entity.y + side_index,
				entity.z,
			)
		if(SOUTH)
			return locate(
				entity.x,
				entity.y - side_index,
				entity.z,
			)
		if(EAST)
			return locate(
				entity.x + side_index,
				entity.y,
				entity.z,
			)
		if(WEST)
			return locate(
				entity.x - side_index,
				entity.y,
				entity.z,
			)

/datum/shuttle/proc/movable_overlap_calculate_left_turf(atom/movable/entity, direction, front_index, width)
	// ditto
	switch(direction)
		if(NORTH)
			return locate(
				entity.x - front_index,
				entity.y,
				entity.z,
			)
		if(SOUTH)
			return locate(
				entity.x + front_index,
				entity.y,
				entity.z,
			)
		if(EAST)
			return locate(
				entity.x,
				entity.y + front_index,
				entity.z,
			)
		if(WEST)
			return locate(
				entity.x,
				entity.y - front_index,
				entity.z,
			)

/datum/shuttle/proc/movable_overlap_calculate_right_turf(atom/movable/entity, direction, front_index, width)
	// ditto
	switch(direction)
		if(NORTH)
			return locate(
				entity.x - front_index + (width + 1),
				entity.y,
				entity.z,
			)
		if(SOUTH)
			return locate(
				entity.x + front_index - (width + 1),
				entity.y,
				entity.z,
			)
		if(EAST)
			return locate(
				entity.x,
				entity.y + front_index - (width + 1),
				entity.z,
			)
		if(WEST)
			return locate(
				entity.x,
				entity.y - front_index + (width + 1),
				entity.z,
			)

//* Docking - Backend; Don't mess with these. *//

/**
 * immediate shuttle move, undocking from any docked ports in the process
 *
 * * both use_before_turfs and use_a
	/// [x or y] cache (perpendicular to considered movement direction)
	/// of 'first non shuttle turf'
…	/// with the relative perpsective of its physics direction.
	var/list/translating_garbage_disposal_lookup_cache
	/// queued throws
	var/list/translating_needs_to_be_thrown_away
	/// queued objs needing to be damaged
	var/list/translating_needs_to_be_damaged
	#warn ugh
fter_turfs must be axis-aligned bounding-box turfs, in order.
 * * both use_before_turfs and use_after_turfs must include all turfs, without filtering!
 *
 * @return TRUE / FALSE on success / failure
 */
/datum/shuttle/proc/aligned_translation(turf/move_to, direction, obj/shuttle_port/align_with_port, list/use_before_turfs, list/use_after_turfs)
	#warn uhh

	// get ordered turfs
	if(isnull(use_before_turfs))
		use_before_turfs = aabb_ordered_turfs_here()
	if(isnull(use_after_turfs))
		use_after_turfs = align_with_port? align_with_port.aabb_ordered_turfs_at_and_clip_check(move_to, direction) : anchor.aabb_ordered_turfs_at_and_clip_check(move_to, direction)
		if(isnull(use_after_turfs))
			return FALSE

	. = unsafe_aligned_translation(move_to, direction, align_with_port, use_before_turfs, use_after_turfs)
	if(!.)
		return

/**
 * immediate shuttle move to a turf
 *
 * * all translations must use this.
 * * warning: absolutely no safety checks are done. none of the aftereffects are handled either. don't use this.
 * * both use_before_turfs and use_after_turfs must be axis-aligned bounding-box turfs, in order.
 * * both use_before_turfs and use_after_turfs must include all turfs, without filtering!
 *
 * optionally, align a port with that turf instead of aligning our anchor to that turf
 *
 * aligned = the port / anchor (if no port specified) is on the turf, and faces the same way,
 * respecting all necessary offsets.
 * ports should generally be centered.
 */
/datum/shuttle/proc/unsafe_aligned_translation(turf/move_to, direction, obj/shuttle_port/align_with_port, list/use_before_turfs, list/use_after_turfs)
	// cache old data
	var/turf/move_from = get_turf(anchor)
	ASSERT(isturf(move_from))

	// setup translation physics
	translating_physics_direction = direction
	var/parallel_length = anchor.overall_height(direction)
	var/perpendicular_length = anchor.overall_width(direction)
	translating_forwards_lookup = new /list(perpendicular_length)
	translating_left_lookup = new /list(parallel_length)
	translating_right_lookup = new /list(parallel_length)
	translating_forward_width = perpendicular_length
	translating_side_length = parallel_length

	#warn translating_forward_offset, translating_side_offset

	// get ordered turfs
	if(isnull(use_before_turfs))
		use_before_turfs = aabb_ordered_turfs_here()
	if(isnull(use_after_turfs))
		use_after_turfs = align_with_port? align_with_port.aabb_ordered_turfs_at(move_to, direction) : anchor.aabb_ordered_turfs_at(move_to, direction)

	// filter out non-moving turfs, but keep list orderings
	SSgrids.null_filter_translation_ordered_turfs_in_place_via_area(areas, use_before_turfs, use_after_turfs)

	// calculate motions of ports and anchors

	// list(x,y,z,dir)
	var/list/old_anchor_location = list(anchor.x, anchor.y, anchor.z, anchor.dir)
	// list(x,y,z,dir)
	var/list/new_anchor_location
	// port = list(x,y,z,dir)
	var/list/new_port_locations = list()

	// we first resolve new anchor location
	if(align_with_port)
		new_anchor_location = anchor.calculate_motion_with_respect_to(
			list(align_with_port.x, align_with_port.y, align_with_port.z),
			list(move_to.x, move_to.y, move_to.z),
			align_with_port.dir,
			direction,
		)
	else
		new_anchor_location = list(move_to.x, move_to.y, move_to.z, direction)

	// we then resolve new port locations via new anchor location
	for(var/obj/shuttle_port/port as anything in ports)
		new_port_locations[port] = port.calculate_motion_with_respect_to(
			old_anchor_location,
			new_anchor_location,
			old_anchor_location[4],
			new_anchor_location[4],
		)

	// move ports and anchors
	anchor.abstract_move(locate(new_anchor_location[1], new_anchor_location[2], new_anchor_location[3]))
	anchor.anchor_moving = TRUE
	anchor.setDir(new_anchor_location[4])
	anchor.anchor_moving = FALSE
	for(var/obj/shuttle_port/port as anything in new_port_locations)
		var/list/motion_tuple = new_port_locations[port]
		port.port_moving = TRUE
		port.abstract_move(locate(motion_tuple[1], motion_tuple[2], motion_tuple[3]))
		port.setDir(motion_tuple[4])
		port.port_moving = FALSE

	// everything's prepped, move.
	if(!SSgrids.translate(
		use_before_turfs,
		use_after_turfs,
		anchor.dir,
		direction,
		NONE,
		/turf/baseturf_skipover/shuttle,
		docked.base_area_instance(),
		null,
		null,
		BOUND_PROC(src, PROC_REF(turf_overlap_handler)),
		BOUND_PROC(src, PROC_REF(movable_overlap_handler)),
	))
		TO_WORLD(FORMAT_SERVER_FATAL("SSgrids.translate() failed during unsafe_aligned_translation of shuttle [id]. This is an unrecoverable error / undefined behavior state, and it is not recommended to continue usage of this shuttle. Please contact a coder immediately."))
		CRASH("SSgrids translation failed. Something has gone horribly wrong!")
	if(ceiling_type)
		// remove old ceiling from above shuttle
		if(SSmapping.cached_level_up[move_from.z])
			var/above_z = SSmapping.cached_level_up[move_from.z]
			// has above
			for(var/turf/above_turf in use_before_turfs)
				// remove ceiling
				above_turf.ScrapeFromLogicalBottom(CHANGETURF_INHERIT_AIR | CHANGETURF_PRESERVE_OUTDOORS, ceiling_type)
		// inject destination ceiling turfs above shuttle
		if(SSmapping.cached_level_up[move_to.z])
			var/above_z = SSmapping.cached_level_up[move_to.z]
			// has above
			for(var/turf/after_turf in use_after_turfs)
				// inject ceiling
				var/turf/above_turf = locate(after_turf.x, after_turf.y, above_z)
				above_turf.PlaceBelowLogicalBottom(ceiling_type, CHANGETURF_INHERIT_AIR | CHANGETURF_PRESERVE_OUTDOORS)

	// teardown translation physics
	translating_physics_direction \
		= translating_forwards_lookup \
		= translating_left_lookup \
		= translating_right_lookup \
		= translating_forward_offset \
		= translating_side_offset \
		= translating_forward_width \
		= translating_side_length \
		= null

//* Docking - Bounding Checks *//

#warn rework bounding checks they don't have direction :/

/**
 * check bounding boxes
 *
 * @params
 * * dock - dock to dock to
 * * port - port to align with dock; if null, we do a centered docking
 * * hard_checks_only - only check hard faults, allow trampling anything else.
 * * use_ordered_turfs - check these ordered turfs; you usually use this when about to translate.
 *
 * @return SHUTTLE_DOCKING_BOUNDING_X result define
 */
/datum/shuttle/proc/check_bounding(obj/shuttle_dock/dock, obj/shuttle_port/with_port, hard_checks_only, list/use_ordered_turfs)
	SHOULD_NOT_OVERRIDE(TRUE)
	var/list/ordered_turfs
	#warn check for overlap with zlevel borders - the last 3 turfs should be reserved
	#warn impl ordered turfs
	if(!check_bounding_overlap(dock, with_port, ordered_turfs))
		return SHUTTLE_DOCKING_BOUNDING_HARD_FAULT
	if(hard_checks_only)
		return SHUTTLE_DOCKING_BOUNDING_CLEAR
	if(!check_bounding_trample(dock, with_port, ordered_turfs))
		return SHUTTLE_DOCKING_BOUNDING_SOFT_FAULT
	return SHUTTLE_DOCKING_BOUNDING_CLEAR

/**
 * hard bounding check - do not override this.
 *
 * @return FALSE if overlapping
 */
/datum/shuttle/proc/check_bounding_overlap(obj/shuttle_dock/dock, obj/shuttle_port/with_port, list/ordered_turfs)
	SHOULD_NOT_OVERRIDE(TRUE)
	for(var/turf/T in ordered_turfs)
		if(istype(T.loc, /area/shuttle))
			return FALSE
		if(T.turf_flags & TURF_FLAG_LEVEL_BORDER)
			return FALSE
	return TRUE

/**
 * soft bounding check - override this for your own checks.
 *
 * @return FALSE if trampling sometihng we don't want to trample
 */
/datum/shuttle/proc/check_bounding_trample(obj/shuttle_dock/dock, obj/shuttle_port/with_port, list/ordered_turfs)
	#warn impl

//* Previews *//

/**
 * Get preview outline for docking and others.
 */
/datum/shuttle/proc/get_preview(regenerate)
	if(!isnull(preview_overlay) && !regenerate)
		return preview_overlay

	preview_generated_at = world.time

	preview_overlay = new /mutable_appearance
	preview_overlay.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	preview_overlay.icon = 'icons/system/blank_32x32.dmi'
	preview_overlay.icon_state = ""

	preview_width = anchor.overall_width(NORTH)
	preview_height = anchor.overall_height(NORTH)

	// get topleft to bottomright (left to right, then go downwards) list of turfs
	var/list/turf/turfs = SSgrids.null_filter_ordered_turfs_in_place_via_area(
		anchor.aabb_ordered_turfs_here(),
		areas,
	)

	// go through and add overlays as necessary
	var/mutable_appearance/stamp = new /mutable_appearance
	var/current_y = preview_height
	var/current_x = 1
	for(var/i in 1 to length(turfs))
		var/turf/turf = turfs[i]

		if(!isnull(turf))
			// clone turf appearance
			stamp.appearance = turf
			// generate pixel values
			stamp.pixel_x = (current_x - 1) * WORLD_ICON_SIZE
			stamp.pixel_y = (current_y - 1) * WORLD_ICON_SIZE
			// imprint the stamp
			preview_overlay.overlays += stamp

		// we move our stamp position regardless of if there's a turf
		++current_x
		if(current_x > preview_width)
			--current_y
			current_x = 1

	return preview_overlay

/**
 * slow proc; get the primary port. if none, we use first port.
 *
 * this is only used in roundstart loading.
 */
/datum/shuttle/proc/get_primary_port()
	for(var/obj/shuttle_port/port in ports)
		if(port.primary_port)
			return port
	if(!length(ports))
		return
	return ports[1]

//* Transit

/**
 * todo: todo
 */
/datum/shuttle/proc/move_to_transit()
	#warn uhh
	return SSshuttle.move_shuttle_to_transit(src)
