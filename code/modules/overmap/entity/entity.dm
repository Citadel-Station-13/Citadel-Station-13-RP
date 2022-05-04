/**
 * overmap entities
 *
 * capable of pixel movement and full simulation
 */
/atom/movable/overmap_object/entity
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
	/// vel x
	var/velocity_x
	/// vel y
	var/velocity_y
	/// vel angle
	var/angular_velocity
	/// current x - this is not in pixels, this is in overmaps distance
	var/position_x
	/// current y - this is not in pixels, this is in overmaps distance
	var/position_y
	/// angle
	var/angle = 0
	/// physics pause sources
	var/physics_paused
	/// currently undergoing a physics dock/undock operation - used to prevent hooks from forcing the proc to be repeated
	var/physics_docking = FALSE

/atom/movable/overmap_object/entity/New()
	// assign id immediately
	id = "[++id_next]"
	reset_physics()
	return ..()

/atom/movable/overmap_object/entity/Initialize(mapload)
	. = ..()
	#warn regist ovmp

/atom/movable/overmap_object/entity/Destroy()
	kill_physics()
	#warn unregist ovmp
	return ..()

/atom/movable/overmap_object/entity/get_bounds_overlay()
	return
	// return SSovermaps.entity_bounds_overlay(bound_x, bound_y, bound_width, bound_height)

/**
 * overmap entities always have static, global perspectives
 */
/atom/movable/overmap_object/entity/get_perspective()
	ensure_self_perspective()
	return ..()
