//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Handles generation and ticking of reality fracking points
 */
/datum/background_task/eldritch_reality_task
	//*                      tuning                      *//
	//* these should be configuration params and based   *//
	//* on map levels later but for now                  *//
	//* they're just variables.                          *//

	/// how many to generate on a zlevel baseline
	var/c_generate_baseline = 0
	/// how many to generate on a zlevel with eldritch cultists (additional)
	var/c_generate_baseline_active = 1
	/// how many to generate based on players on level; 0.5 = 0.5 per player
	var/c_generate_player_scaling = (1 / 10)
	/// MTTH divided by amount needed, in deciseconds, before a new reality disturbance spawns
	var/c_spawn_mtth = 10 MINUTES

	/// last fire
	var/last_run

// TODO: map based instead of level based
// TODO: /datum/map_level data-tags for this
// TODO: /datum/map_level_trait(s) for this

/datum/background_task/eldritch_reality_task/run(ticklimit)
	yield(1 MINUTES)
	return BACKGROUND_TASK_RETVAL_YIELD

// todo: bundle by map, bias towards activity? we want to spawn disturbances both
//       in unoccupied space as well more of them in player-occupied space to promote
//       conflict
