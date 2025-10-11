//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * agitation stages
 *
 * this is datumized to make switching between very fast to check for as we can order them by strictly
 * increasing ranges.
 */
/datum/chimeric_agitation_stage
	/// requires agitation at or above this
	var/agitation_low = IFNINITY
	/// requires agitation at or below this
	var/agitation_high = INFINITY

/datum/chimeric_agitation_stage/proc/on_enter(obj/item/organ/internal/chimeric_core/core)

/datum/chimeric_agitation_stage/proc/(obj/item/organ/internal/chimeric_core/core)


#warn impl all
