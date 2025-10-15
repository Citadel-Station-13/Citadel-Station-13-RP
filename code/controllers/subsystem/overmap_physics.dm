//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

SUBSYSTEM_DEF(overmap_physics)
	name = "Overmap Physics"
	priority = FIRE_PRIORITY_OVERMAP_PHYSICS
	subsystem_flags = SS_NO_INIT
	wait = 0.25

	/// processing
	var/static/list/obj/overmap/entity/moving = list()
	/// currentrun
	var/list/obj/overmap/entity/running

/datum/controller/subsystem/overmap_physics/fire(resumed)
	if(!resumed)
		src.running = src.moving.Copy()
	var/list/obj/overmap/entity/running = src.running
	// tick_lag is in deciseconds
	// in ticker, our wait is that many ds
	// in non-ticker, our wait is either wait in ds, or a minimum of tick_lag in ds
	// we convert it to seconds with * 0.1
	var/dt = (subsystem_flags & SS_TICKER? (wait * world.tick_lag) : max(world.tick_lag, wait)) * 0.1
	var/index = 0
	for(index in length(running) to 1 step -1)
		var/obj/overmap/entity/to_run = running[index]
		to_run.physics_tick(dt)
		if(MC_TICK_CHECK)
			break
	running.len -= length(running) - index
