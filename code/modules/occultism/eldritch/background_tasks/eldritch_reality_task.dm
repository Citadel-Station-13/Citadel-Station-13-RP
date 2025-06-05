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

#warn impl

// TODO: /datum/map_level datatags for this
// TODO: /datum/map_level_trait(s) for this
