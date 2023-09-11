//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * The movement manager for turf movements
 *
 * This is named after SS14's grids.
 * This is a subsystem for OOP/encapsulation reasons.
 */
SUBSYSTEM_DEF(grids)
	name = "Grids"
	subsystem_flags = SS_NO_FIRE | SS_NO_INIT

	/// global motion mutex
	var/translation_mutex = FALSE


/**
 * gets ordered turfs for operation
 */
/datum/controller/subsystem/grids/proc/get_ordered_turfs(x1, x2, y1, y2, z, dir)

/**
 * performs turf translation
 *
 * @params
 * * from_turfs - get_ordered_turfs return list
 * * from_dir - dir of from_turfs
 * * to_turfs - get_ordered_turfs return list
 * * to_dir - dir of to_turfs
 * * grid_flags - flags to pass during move to motion procs
 * * baseturf_boundary - if set, turfs move down to this baseturf boundary. if it's not there, the turf is automatically skipped.
 */
/datum/controller/subsystem/grids/proc/translate(list/from_turfs, list/to_turfs, from_dir, to_dir, grid_flags, baseturf_boundary)
	// While based on /tg/'s movement system, we do a few things differently.
	// First, limitations:
	// * base-areas aren't a thing. Areas are flat out trampled on move. On takeoff, areas are reset.
	#warn what to reset areas to?
	// * Turfs are assumed to be entirely described by baseturfs. So, flooring's just trampled too.
	// The actual process:
	// * The ordered list of turfs are translated across to provide a bed to place everything
	

#warn impl all


/turf/proc/grid_move(turf/target, rotation_angle, grid_flags, baseturf_boundary)
