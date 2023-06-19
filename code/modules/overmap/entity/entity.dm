/**
 * entities
 *
 * overmap objects capable of motion
 */
/obj/overmap/entity
	//* identity
	/// id
	var/id
	/// next id
	var/static/id_next = 0

	//* physics
	/// velocity x in overmap units per second
	var/vel_x
	/// velocity y in overmap units per second
	var/vel_y
	/// position x in overmap units
	var/pos_x
	/// position y in overmap units
	var/pos_y
	/// max speed in overmap units per second
	var/max_speed = OVERMAP_DISTANCE_TILE
	/// is moving
	var/tmp/is_moving = FALSE

/obj/overmap/entity/New()
	// assign id immediately
	id = "[GLOB.round_id? "[GLOB.round_id]_" : ""][num2text(++id_next, 999)]"
	return ..()

/obj/overmap/entity/Initialize(mapload)
	. = ..()
	initialize_physics()
	update_velocity_ticking()

/obj/overmap/entity/Destroy()
	deactivate_physics()
	return ..()

/obj/overmap/entity/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change)
	. = ..()
	if(!isturf(old_loc) || forced)
		initialize_physics()
