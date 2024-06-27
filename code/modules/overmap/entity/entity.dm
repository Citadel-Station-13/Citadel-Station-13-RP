/**
 * entities
 *
 * overmap objects capable of motion
 */
/obj/overmap/entity
	//* identity *//
	/// id
	var/id
	/// next id
	var/static/id_next = 0

	//* overmap *//
	/// if we're currently in an overmap; if so, which?
	var/datum/overmap/overmap

	//* physics *//
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
	// init physics
	initialize_physics()
	update_velocity_ticking()
	// add to spatial grid
	AddComponent(/datum/component/spatial_grid, SSspatial_grids.overmap_entities)

/obj/overmap/entity/Destroy()
	// stop physics
	deactivate_physics()
	return ..()

/obj/overmap/entity/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change)
	. = ..()
	if(!isturf(old_loc) || forced)
		initialize_physics()

/obj/overmap/entity/vv_edit_var(var_name, var_value, mass_edit, raw_edit)
	switch(var_name)
		if(NAMEOF(src, vel_x))
			set_velocity(vx = var_value)
			return TRUE
		if(NAMEOF(src, vel_y))
			set_velocity(vy = var_value)
			return TRUE
	return ..()

/**
 * called when we join an overmap
 */
/obj/overmap/entity/proc/on_overmap_join(datum/overmap/map)
	src.overmap = map

/**
 * called when we leave an overmap
 */
/obj/overmap/entity/proc/on_overmap_leave(datum/overmap/map)
	src.overmap = map
