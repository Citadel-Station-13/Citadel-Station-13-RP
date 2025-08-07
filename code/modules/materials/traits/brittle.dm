//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * Brittle materials allow things to shatter.
 */
/datum/prototype/material_trait/brittle
	id = "brittle"

// #warn impl

/**
 * called by /datum/prototype/material_trait/brittle to shatter.
 */
/atom/proc/material_trait_brittle_shatter()
	return
