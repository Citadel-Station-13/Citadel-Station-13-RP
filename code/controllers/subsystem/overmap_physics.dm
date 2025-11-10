//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

SUBSYSTEM_DEF(overmap_physics)
	name = "Overmap Physics"
	priority = FIRE_PRIORITY_OVERMAP_PHYSICS
	subsystem_flags = NONE
	wait = 0.25

	/// processing
	var/static/list/obj/overmap/entity/moving = list()
	/// currentrun
	var/list/obj/overmap/entity/running

	//*                    Global Tuning                       *//
	//* Sim tuning goes in here; not balance                   *//
	//* Example: 'thrust mult' is balance, 'sim speed' is sim. *//

	/// hard movement limit in pixels / tick
	///
	/// * should be at or below 4 to prevent clipping through
	var/global_interpolate_limit = 4
	var/tmp/global_interpolate_limit_as_per_second = INFINITY

/datum/controller/subsystem/overmap_physics/fire(resumed)
	if(!resumed)
		src.running = src.moving.Copy()
	var/list/obj/overmap/entity/running = src.running
	var/index = 0
	for(index in length(running) to 1 step -1)
		var/obj/overmap/entity/to_run = running[index]
		to_run.physics_tick(nominal_dt_s)
		if(MC_TICK_CHECK)
			break
	running.len -= length(running) - index

/datum/controller/subsystem/overmap_physics/proc/set_global_interpolate_limit(pixels_per_tick)
	global_interpolate_limit = pixels_per_tick
	global_interpolate_limit_as_per_second = pixels_per_tick * ((1 SECONDS) / nominal_dt_ds)

	// go through all moving entities and make sure they're not speeding
	// sorry no breaking the galactic speed limit (clearly not the speed of light anymore)
	for(var/obj/overmap/entity/entity as anything in moving)
		// this will run it through interpolate limit check again
		// and preserve angle
		entity.set_velocity(entity.vel_x, entity.vel_y)

/datum/controller/subsystem/overmap_physics/recompute_wait_dt()
	..()
	// update interpolate limit
	set_global_interpolate_limit(global_interpolate_limit)
