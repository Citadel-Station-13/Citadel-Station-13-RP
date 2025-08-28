//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

GLOBAL_REAL(CVARS, /datum/controller/cvars)

/**
 * * Faster than config
 * * Supports VV guarding
 * * Namespaces a lot of balancing variables away from GLOB
 * * Shouldn't be config'd/changed like configs, though
 *
 * Variable format is `snake_case`.
 */
/datum/controller/cvars
	//* power *//
	/// joules per unit
	var/energy_cost_electric_welder = 12000

/datum/controller/cvars/New()
	if(CVARS)
		stack_trace("old instance of cvar controller found; annihilating it and replacing")
		QDEL_NULL(CVARS)
	CVARS = src
