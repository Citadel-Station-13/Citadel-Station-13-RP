//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//* Page has all balancing parameters + algorithms for dynamic attribute computations for things like armor

/**
 * creates an armor datum based off of our stats
 *
 * @params
 * * significance - relative amount of this material used should be a multiplier of MATERIAL_SIGNIFICANCE_BASELINE
 * * mob_armor - is this going to be used as mob armor? mob armor generally won't have vulnerability.
 *
 * @return /datum/armor instance
 */
/datum/material/proc/create_armor(significance = MATERIAL_SIGNIFICANCE_BASELINE, mob_armor)
	#warn params
	#warn impl - this requires caching

/**
 * combines multiple material armors into one
 *
 * @params
 * * materials - material instances associated to significance.
 *
 * @return /datum/armor instance
 */
/datum/controller/subsystem/materials/proc/combined_materials_armor(list/datum/material/materials)
	#warn impl - this requires caching

/**
 * combines multiple material armors into one
 * used for reinforcing / whatevers
 *
 * @params
 * * materials - material instances associated to significance. first is lowest; put exterior armors on last!
 *
 * @return /datum/armor instance
 */
/datum/controller/subsystem/materials/proc/reinforcing_materials_armor(list/datum/material/materials)
	#warn impl - this requires caching

/**
 * get melee stats
 * autodetect with initial damage modes of item
 * alternatively forced modes can be specified via the param
 *
 * @return list(damage, armorflag, tier, mode)
 */
/datum/material/proc/melee_stats(initial_modes, multiplier = 1)
	. = new /list(MATERIAL_MELEE_STATS_LISTLEN)
	#warn impl - this requires caching

