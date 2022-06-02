/**
 * overmap entities
 *
 * capable of pixel movement and full simulation
 *
 * - physics
 * we use a detached free body sim
 * velocity x, y, angle, and the actual angle have nothing to do with each other.
 * velocity x and y are relative to the map, not the object's front.
 */
/atom/movable/overmap_object/entity
	icons = 'icons/overmaps/entity.dmi'
	plane = OVERMAP_ENTITY_PLANE

	// identity
	/// id
	var/id
	/// next id
	var/static/id_next = 0

	// overmap
	/// currently ticking?
	var/ticking = FALSE
	/// currently ticking physics?
	var/moving = FALSE
	/// overmap we belong to - **nested objects are still on this, use is_on_map to determine!**
	var/datum/overmap/overmap
	/// are we currently on the overmap or contained by something?
	var/is_on_map = FALSE
	/// spatial hash index we're in
	var/tmp/_overmap_spatial_hash_index

	// physics
	/// current physics mode
	var/physics_mode = ENTITY_PHYSICS_SIMULATED
	/// vel x in overmaps coordinates per second
	var/velocity_x
	/// vel y in overmaps coordinates per second
	var/velocity_y
	/// vel angle in degrees clockwise per second
	var/angular_velocity
	/// current x - this is not in pixels, this is in overmaps distance
	var/position_x
	/// current y - this is not in pixels, this is in overmaps distance
	var/position_y
	/// angle in degrees clockwise from north
	var/angle = 0
	/// physics pause sources
	var/physics_paused
	/// currently undergoing a physics dock/undock operation - used to prevent hooks from forcing the proc to be repeated
	var/physics_docking = FALSE
	/// used for optimized spatial hash re-positioning
	var/last_spatial_x
	/// used for optimized spatial hash re-positioning
	var/last_spatial_y
	/// are we about to forcemove? used to prevent forceMove hook from firing
	var/jumping = FALSE

	// location
	/// our location datum
	var/datum/overmap_location/location
	/// our instantiation mode
	var/instantiation = OVERMAP_ENTITY_INSTANTIATION_VIRTUAL

	// hazards
	/// active hazards associated to severities
	var/list/active_hazards

/atom/movable/overmap_object/entity/New()
	// assign id immediately
	id = "[++id_next]"
	return ..()

/atom/movable/overmap_object/entity/Initialize(mapload)
	. = ..()
	add_to_overmap()
	add_bounds_overlay()

/atom/movable/overmap_object/entity/Destroy()
	kill_physics()
	remove_from_overmap()
	return ..()

/atom/movable/overmap_object/entity/get_bounds_overlay()
	return
	// TODO: pixel movement
	// return SSovermaps.entity_bounds_overlay(bound_x, bound_y, bound_width, bound_height)

/**
 * overmap entities always have static, global perspectives
 */
/atom/movable/overmap_object/entity/get_perspective()
	ensure_self_perspective()
	return ..()

/**
 * pretty name for non-internal logging
 */
/atom/movable/overmap_object/entity/proc/pretty_log_name()
	return "[name] ([id])"

/**
 * normal, non-physics ticks
 */
/atom/movable/overmap_object/entity/proc/tick(seconds)
	if(length(active_hazards))
		for(var/id in active_hazards)
			var/datum/overmap_hazard/H = SSovermaps.resolve_hazard(id)
			if(!H)
				stack_trace("bad hazard id [id] found")
				active_hazards -= id
			H.tick(src, active_hazards[id], seconds)

/**
 * should we be ticking?
 */
/atom/movable/overmap_object/entity/proc/should_tick()
	return (
		length(active_hazards)
	)

/**
 * put us on ticking if not ticking and ticking is needed
 */
/atom/movable/overmap_object/entity/proc/check_ticking()
	if(!overmap)
		return
	if(ticing == should_tick())
		return
	// at this point ticking is not should tick, so do opposite of ticking
	if(ticking)
		ticking = FALSE
		overmap.ticking -= src
		return
	else
		ticking = TRUE
		overmap.ticking += src

