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

	//*                    Global Tuning                       *//
	//* Sim tuning goes in here; not balance                   *//
	//* Example: 'thrust mult' is balance, 'sim speed' is sim. *//

	/// hard movement limit in pixels / tick
	///
	/// * should be at or below 4 to prevent clipping through
	var/global_interpolate_limit = 4

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
