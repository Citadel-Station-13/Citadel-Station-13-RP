/**
 * overmap entities
 *
 * capable of pixel movement and full simulation
 */
/atom/movable/overmap_object/entity
	// instance
	/// currently ticking?
	var/ticking = FALSE
	/// overmap we belong to
	var/datum/overmap/overmap

	// physics
	/// current physics mode
	var/physics_mode = ENTITY_PHYSICS_SIMULATED
	/// vel x
	var/velocity_x
	/// vel y
	var/velocity_y
	/// vel angle
	var/angular_velocity
	/// current x
	var/x
	/// current y
	var/y
	/// angle
	var/angle = 0
	/// physics pause sources
	var/physics_paused

/atom/movable/overmap_object/entity/get_bounds_overlay()
	return
	// return SSovermaps.entity_bounds_overlay(bound_x, bound_y, bound_width, bound_height)
