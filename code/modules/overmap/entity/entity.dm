//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * entities
 *
 * overmap objects capable of motion
 *
 * * overmap objects use pixel movement
 * * overmap objects call Moved() at very, very weird times.
 * * overmap objects do not respond to normal Enter/Exit checks, overmap turfs and objects must use Cross()/Uncross() and their -ed versions.
 */
/obj/overmap/entity
	// pixel movement gaming
	appearance_flags = KEEP_TOGETHER
	pixel_movement = TRUE
	animate_movement = NONE
	glide_size = 128
	step_size = INFINITY
	uses_bounds_overlay = TRUE

	//* identity *//
	/// id
	var/id
	/// next id
	var/static/id_next = 0

	//* location *//
	/// our location, if any
	var/datum/overmap_location/location

	//* overmap *//
	/// if we're currently in an overmap; if so, which?
	var/datum/overmap/overmap

	//* physics *//
	/// velocity x in overmap units per second
	var/vel_x
	/// velocity y in overmap units per second
	var/vel_y
	/// cached, read-only cached center x in overmap dist
	var/pos_x
	/// cached, read-only cached center y in overmap dist
	var/pos_y
	/// bump was handled
	var/bump_handled = FALSE

	/// max speed in overmap units per second
	var/max_speed = OVERMAP_DISTANCE_TILE * 2
	/// is moving
	var/tmp/is_moving = FALSE
	/// is forced moving
	///
	/// todo: reevaluate if this is the right way to perform forced movements like wrapping.
	var/tmp/is_forced_moving = FALSE

/obj/overmap/entity/New()
	// assign id immediately
	id = "[GLOB.round_id? "[GLOB.round_id]_" : ""][num2text(++id_next, 999)]"
	return ..()

/obj/overmap/entity/Initialize(mapload, datum/overmap_location/location)
	. = ..()
	// bind location
	if(location)
		set_location(location)
	// join overmap
	if(isturf(loc) && !overmap && istype(loc.loc, /area/overmap))
		loc.loc.Entered(src)
	// init physics
	initialize_physics()
	update_velocity_ticking()
	// add to spatial grid
	AddComponent(/datum/component/spatial_grid, SSspatial_grids.overmap_entities)

/obj/overmap/entity/Destroy()
	// stop physics
	deactivate_physics()
	// unbind location
	QDEL_NULL(location)
	return ..()

/obj/overmap/entity/set_glide_size(new_glide_size, recursive)
	return

/obj/overmap/entity/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change)
	. = ..()
	if(!isturf(old_loc) || (forced && !is_forced_moving))
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

/obj/overmap/entity/get_bounds_overlay()
	return SSovermaps.entity_bounds_overlay(bound_x, bound_y, bound_width, bound_height)
