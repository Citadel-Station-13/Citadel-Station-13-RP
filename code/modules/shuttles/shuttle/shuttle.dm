//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

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
	//* Intrinsics *//
	/// are we mid-delete? controls whether we, and our components are immune to deletion.
	var/being_deleted = FALSE
	/// our globally persistent-unique identifier string
	var/id
	/// our unique template id; this is *not* our ID and is *not* unique!
	var/template_id
	/// our descriptor instance; this is what determines how we act
	/// to our controller, as well as things like overmaps.
	var/datum/shuttle_descriptor/descriptor

	//* Composition *//
	/// our shuttle controller
	var/datum/shuttle_controller/controller
	/// our physical shuttle object
	var/obj/shuttle_anchor/anchor
	#warn don't move this snowflake-ly, only move anchor like that, this goes with grid
	/// our physical shuttle port objects
	var/list/obj/shuttle_port/ports
	#warn nuke this don't need it just for loop like a normal person
	/// port lookup by id
	var/list/obj/shuttle_port/port_lookup
	#warn nuke this don't need it just for loop like a normal person
	/// our primary port, if any.
	/// roundstart docking will use this port.
	var/obj/shuttle_port/port_primary
	/// the areas in our shuttle, associated to a truthy value
	var/list/area/shuttle/areas

	//* Docking *//
	/// where we are docked, if any
	var/obj/shuttle_dock/docked
	/// the port we're using
	var/obj/shuttle_port/docked_via_port

	//* Movement - Ephemeral / In-Move *//
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

	//* Hooks *//
	/// registered shuttle hooks
	var/list/datum/shuttle_hook/hooks

	//* Identity *//
	/// real / code name
	var/name = "Unnamed Shuttle"
	/// description for things like admin interfaces
	var/desc = "Some kind of shuttle. The coder forgot to set this."

	//* Preview *//
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

	//* Structure *//
	/// if set, we generate a ceiling above the shuttle of this type, on the bottom of the turf stack.
	//  todo: vv hook this
	var/ceiling_type = /turf/simulated/shuttle_ceiling

	//* Transit *//

	//? This is in shuttle, not controller, because
	//? we cannot afford a memory leak in transit and therefore
	//? shuttle-side will ensure things are cleaned up as needed.
	//?
	//? Note that our 'transit' is physically managing transit
	//? and the dock / reservation.
	//?
	//? Shuttle controller 'transit' is the actual act of moving from
	//? one place to another.

	/// Shuttle is in transit
	var/in_transit = FALSE
	/// Current transit reservation
	var/datum/turf_reservation/transit/transit_reservation

	//* legacy stuff *//
	// todo: this should be a default, and engine/takeoff type (?) can override
	var/legacy_sound_takeoff = 'sound/effects/shuttles/shuttle_takeoff.ogg'
	var/legacy_sound_landing = 'sound/effects/shuttles/shuttle_landing.ogg'
	var/legacy_takeoff_unsecured_knockdown = 2 SECONDS
	var/legacy_takeoff_unsecured_paralyze = 0.75 SECONDS
	var/legacy_takeoff_shake_secured = 3
	var/legacy_takeoff_shake_unsecured = 10
	var/legacy_takeoff_throw_force = THROW_FORCE_DEFAULT
	var/legacy_takeoff_throw_distance = 3
	#warn hook these
	var/list/obj/structure/fuel_port/legacy_fuel_ports = list()

#warn impl all

/datum/shuttle/Destroy(force)
	if(!force)
		stack_trace("something tried to delete a shuttle")
		return QDEL_HINT_LETMELIVE
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
	// as a result of how our areas work, deleting a shuttle
	// in normal space leaves the turfs behind on the base areas,
	// but deleting it in transit will just wipe out the entire
	// shuttle as the transit turf reservation is destroyed.
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
	for(var/turf/scanning in from_reservation.unordered_inner_turfs())
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
				if(!port.port_id)
					var/hex
					do
						hex = num2hex(rand(1, 65535), 4)
					while(port_lookup[hex])
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
	forward_lookup_index = abs(forward_lookup_index)
	side_lookup_index = abs(side_lookup_index)

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
 * immediate shuttle move, undocking from any docked ports in the process and docking with the destination port
 *
 * * both use_before_turfs and use_after_turfs must be axis-aligned bounding-box turfs, in order.
 * * both use_before_turfs and use_after_turfs must include all turfs, without filtering!
 * * does not fire off shuttle hooks; shuttle transit cycles and controllers do that.
 *
 * @params
 * * dock - the dock to use
 * * align_with_port - if provided, we align to this port; overrides 'centered' and 'direction'
 * * centered - use centered? if not, we move directly onto the dock
 * * direction - docking direction for centered and direct-alignment
 * * use_before_turfs - ...
 * * use_after_turfs - ...
 *
 * @return TRUE / FALSE on success / failure
 */
/datum/shuttle/proc/dock(obj/shuttle_dock/dock, obj/shuttle_port/align_with_port, centered, direction, list/use_before_turfs, list/use_after_turfs)
	if(dock.inbound && dock.inbound != src)
		return FALSE
	if(dock.docked)
		return FALSE
	#warn impl

/**
 * immediate shuttle move, undocking from any docked ports in the process
 *
 * * both use_before_turfs and use_after_turfs must be axis-aligned bounding-box turfs, in order.
 * * both use_before_turfs and use_after_turfs must include all turfs, without filtering!
 * * does not fire off shuttle hooks; shuttle transit cycles and controllers do that.
 * * DO NOT USE THIS FOR DOCKING. It only handles undocking, not docking!
 *
 * @return TRUE / FALSE on success / failure
 */
/datum/shuttle/proc/aligned_translation(turf/move_to, direction, obj/shuttle_port/align_with_port, list/use_before_turfs, list/use_after_turfs)
	#warn unbind from dock

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
 * * warning: this does not fire hooks or do anything. [aligned_translation()] does that. seriously, do not mess with this.
 * * warning: absolutely no safety checks are done. none of the aftereffects are handled either. don't use this.
 * * this means if you fuck up, things just flat out get annihilated or scrambled. the round might even crash, and you might get angry Discord messages.
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
	PRIVATE_PROC(TRUE)
	// cache old data
	var/turf/move_from = get_turf(anchor)
	ASSERT(isturf(move_from))

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

	// - POINT OF NO RETURN -//

	// fire premove hook
	var/datum/event_args/shuttle/translation/pre_move/pre_move_event = new
	pre_move_event.old_location = old_anchor_location
	pre_move_event.new_location = new_anchor_location
	fire_translation_hooks(pre_move_event)

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

	// setup translation physics
	translating_physics_direction = direction
	var/parallel_length = anchor.overall_height(direction)
	var/perpendicular_length = anchor.overall_width(direction)
	translating_forwards_lookup = new /list(perpendicular_length)
	translating_left_lookup = new /list(parallel_length)
	translating_right_lookup = new /list(parallel_length)
	translating_forward_width = perpendicular_length
	translating_side_length = parallel_length

	var/list/llx_lly_urx_ury = \
		anchor.absolute_llx_lly_urx_ury_coords_at(
			new_anchor_location,
			new_anchor_location[4],
		)

	switch(direction)
		if(NORTH)
			// forward offset is the negated x right outside the left of shuttle,
			// so adding x to it gets your forward index when abs()'d
			translating_forward_offset = -(llx_lly_urx_ury[1] - 1)
			// side offset is the negated y on turf right outside the front of the shuttle,
			// so adding y to it gets your side index when abs()'d
			translating_side_offset = -(llx_lly_urx_ury[4] + 1)
		if(SOUTH)
			// forward offset is the negated x right outside the right of shuttle,
			// so adding x to it gets your forward index when abs()'d
			translating_forward_offset = -(llx_lly_urx_ury[3] + 1)
			// side offset is the negated y on turf right outside the back of the shuttle,
			// so adding y to it gets your side index when abs()'d
			translating_side_offset = -(llx_lly_urx_ury[2] - 1)
		if(EAST)
			// not going to bother commenting this, this is just rotation math
			// and my brain hurts oh my days
			translating_forward_offset = -(llx_lly_urx_ury[4] + 1)
			translating_side_offset = -(llx_lly_urx_ury[3] + 1)
		if(WEST)
			// not going to bother commenting this, this is just rotation math
			// and my brain hurts oh my days
			translating_forward_offset = -(llx_lly_urx_ury[2] - 1)
			translating_side_offset = -(llx_lly_urx_ury[1] - 1)

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

	// handle ceilings if necessary
	if(ceiling_type)
		// remove old ceiling from above shuttle
		if(SSmapping.cached_level_up[move_from.z])
			var/above_z = SSmapping.cached_level_up[move_from.z]
			// has above
			// (this is null filtered on purpose)
			// also, this *should* include non-moved turfs too (aka turfs that got too broken / the baseturf marker removed),
			// because use_before_turfs and use_after_turfs are area filtered, not turf filtered.
			for(var/turf/before_turf in use_before_turfs)
				var/turf/above_turf = locate(before_turf.x, before_turf.y, above_z)
				// remove ceiling
				above_turf.ScrapeFromLogicalBottom(CHANGETURF_INHERIT_AIR | CHANGETURF_PRESERVE_OUTDOORS, ceiling_type)
		// inject destination ceiling turfs above shuttle
		if(SSmapping.cached_level_up[move_to.z])
			var/above_z = SSmapping.cached_level_up[move_to.z]
			// has above
			// (this is null filtered on purpose)
			// also, this *should* include non-moved turfs too (aka turfs that got too broken / the baseturf marker removed),
			// because use_before_turfs and use_after_turfs are area filtered, not turf filtered.
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

	// fire postmove hook
	var/datum/event_args/shuttle/translation/post_move/post_move_event = new
	post_move_event.old_location = old_anchor_location
	post_move_event.new_location = new_anchor_location
	fire_translation_hooks(post_move_event)

	// -- Finished -- //

	pass()

//* Docking - Bounding Checks *//

/**
 * check bounding boxes
 *
 * basically, wrapper for check_bounding
 *
 * @params
 * * dock -  dock to dock to
 * * with_port - port to align with dock; if null, we do a centered docking
 * * hard_checks_only - only check for hard faults. this is usually set to TRUE for dock landings, because docks are consdiered protected!
 * * use_ordered_turfs - pass in ordered turfs to use instead of the normal bounds check
 */
/datum/shuttle/proc/check_docking_bounds(obj/shuttle_dock/dock, obj/shuttle_port/with_port, hard_checks_only, list/turf/use_ordered_turfs)
	if(isnull(hard_checks_only))
		hard_checks_only = dock.trample_bounding_box
	#warn impl

#warn we're going to need a way to allow crashing into things liek trees..

/**
 * direct bounding box check
 *
 * @params
 * * turf/location - location anchor will be at
 * * direction - direction anchor will be at
 * * hard_checks_only - only check for hard faults
 * * use_ordered_turfs - pass in ordered turfs to use instead of the normal bounds check
 * * docking_at - dock we're going to. used to exclude it from dock boundary checks.
 */
/datum/shuttle/proc/check_bounding(turf/location, direction, hard_checks_only, list/turf/use_ordered_turfs, obj/shuttle_dock/docking_at)
	if(isnull(use_ordered_turfs))
		use_ordered_turfs = anchor.aabb_ordered_turfs_at_and_clip_check(location, direction)
	if(isnull(use_ordered_turfs))
		return SHUTTLE_DOCKING_BOUNDING_HARD_FAULT
	if(hard_checks_only)
		return SHUTTLE_DOCKING_BOUNDING_CLEAR
	for(var/obj/shuttle_dock/enemy_dock in SSshuttle.docks_by_level[location.z])
		if(enemy_dock == docking_at)
			continue
		if(!enemy_dock.should_protect_bounding_box())
			continue
		if(!anchor.intersects_dock(enemy_dock))
			continue
		// we do intersect
		return SHUTTLE_DOCKING_BOUNDING_SOFT_FAULT
	if(!check_bounding_trample_turfs_binary(use_ordered_turfs))
		return SHUTTLE_DOCKING_BOUNDING_SOFT_FAULT
	return SHUTTLE_DOCKING_BOUNDING_CLEAR

/**
 * called binary because we return TRUE / FALse only
 *
 * @return FALSE if we will trample something
 */
/datum/shuttle/proc/check_bounding_trample_turfs_binary(list/ordered_turfs)
	for(var/turf/T as anything in ordered_turfs)
		if(!check_bounding_trample_turf(T))
			return FALSE
	return TRUE

/**
 * @params
 * * ordered_turfs - turfs to check
 * * bad_turfs_out - turfs that get trampled are put in here
 *
 * @return FALSE if we will trample something
 */
/datum/shuttle/proc/check_bounding_trample_turfs_extract(list/ordered_turfs, list/bad_turfs_out = list())
	. = TRUE
	for(var/turf/T as anything in ordered_turfs)
		if(isnull(T))
			continue
		if(!check_bounding_trample_turf(T))
			. = FALSE
			bad_turfs_out += T

/**
 * @params
 * * ordered_turfs - turfs to check
 * * bad_turfs_out - turfs that get trampled are put in here, rest of entries are null. same ordering as ordered_turfs
 *
 * @return FALSE if we will trample something
 */
/datum/shuttle/proc/check_bounding_trample_turfs_ordered_extract(list/ordered_turfs, list/bad_turfs_out = list())
	. = TRUE
	bad_turfs_out.len = length(ordered_turfs)
	for(var/i in 1 to length(ordered_turfs))
		var/turf/T = ordered_turfs[i]
		if(isnull(T))
			continue
		if(!check_bounding_trample_turf(T))
			. = FALSE
			bad_turfs_out[i] = T

/**
 * soft bounding check - override this for your own checks.
 *
 * @return FALSE if trampling sometihng we don't want to trample
 */
/datum/shuttle/proc/check_bounding_trample_turf(turf/T)
	// 1. are we space?
	if(istype(T, /turf/space))
		// we're fine
		return TRUE
	// 2. is the turf dense?
	if(T.density)
		// don't run it over
		return FALSE
	// 3. is the turf outdoors?
	if(!T.outdoors)
		// no landing indoors unless it's a dock
		return FALSE
	return TRUE

//* Hooks *//

/datum/shuttle/proc/fire_translation_hooks(datum/event_args/shuttle/translation/event)
	SHOULD_NOT_SLEEP(TRUE)
	for(var/datum/shuttle_hook/hook as anything in hooks)
		hook.on_translation_event(event)

/datum/shuttle/proc/fire_docking_hooks(datum/event_args/shuttle/dock/event)
	SHOULD_NOT_SLEEP(TRUE)
	for(var/datum/shuttle_hook/hook as anything in hooks)
		hook.on_dock_event(event)

//* Location *//

/**
 * Gets our overmap entity, if any
 */
/datum/shuttle/proc/get_overmap_entity()
	if(!istype(controller, /datum/shuttle_controller/overmap))
		return
	var/datum/shuttle_controller/overmap/overmap_controller = controller
	return overmap_controller.entity

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

//* SFX / VFX *//

/**
 * get people in range of general SFX / VFX associated to their
 * ranges outside the shuttle
 *
 * * this only grabs players
 * * this uses the range from anchor
 */
/datum/shuttle/proc/sfx_players_in_range(maximum_range = 21)
	var/our_z = anchor.z
	. = list()
	for(var/mob/player as anything in GLOB.players_by_zlevel[our_z])
		var/dist = get_dist(player, anchor)
		if(dist <= maximum_range)
			.[player] = dist

/datum/shuttle/proc/make_sounds(sound, maximum_range, volume = 65)
	var/list/mob/hearing = sfx_players_in_range(maximum_range)
	var/sound/resolved = get_sfx(sound)
	for(var/mob/heard as anything in hearing)
		heard.playsound_local(
			soundin = resolved,
			vol = volume,
			falloff = FALSE,
		)

//* Transit *//

/datum/shuttle/proc/prepare_transit()
	ASSERT(!transit_reservation)
	#warn uhh
	#warn make sure we have a border

/**
 * tears down our transit reservation
 * you usually want to call this after we lave
 *
 * if handlers are not provided,
 *
 * * turfs are deleted
 * * movables that aren't marked with [MOVABLE_NO_LOST_IN_SPACE] are deleted
 * * movables that are marked with that are translated with the shuttle if possible, otherwise kicked to a spot near the shuttle
 *
 * @params
 * * movable_handler - called with (AM) for the movables outside the shuttle
 * * turf_handler - called with (T) for turfs that aren't part of the shuttle or reservation's base turf
 * * skyfall - default movable handler (if not provided) should throw movables out of the sky in planets
 * * all_movables - call movable_handler on all movables, not just ones marked with NO_LOST_IN_SPACE
 */
/datum/shuttle/proc/teardown_transit(datum/callback/movable_handler, datum/callback/turf_handler, skyfall, all_movables)
	if(!transit_reservation)
		return
	if(transit_reservation.is_atom_inside(anchor))
		CRASH("tried to teardown transit while inside it!")

	movable_handler = movable_handler || CALLBACK(src, PROC_REF(default_transit_movable_cleaner))
	#warn impl
	#warn how to handle turns and translations??

	if(turf_handler)
		for(var/turf/T as anything in transit_reservation.unordered_inner_turfs())
			if(T.type == transit_reservation.turf_type)
				continue
			turf_handler.Invoke(T)

/datum/shuttle/

//* UI Helpers *//

/**
 * exports information about which ways we can dock with a dock
 */
/datum/shuttle/proc/ui_docking_alignment_query(obj/shuttle_dock/dock)
	var/list/matching_ports = list()
	for(var/id in port_lookup)
		var/obj/shuttle_port/port = port_lookup[id]
		var/port_results = port.check_dock_seal(dock)
		if(port_results == SHUTTLE_DOCKING_SEAL_FAULT)
			continue
		matching_ports[port.port_id] = port.name
	/**
	 * centerDirs: NORTH | SOUTH | EAST | WEST as 1, 2, 4, 8
	 * ports: Record<id: string, name: string>
	 */
	return list(
		"centerDirs" = anchor.centered_docking_dir_bits_we_fit(),
		"ports" = matching_ports,
	)
