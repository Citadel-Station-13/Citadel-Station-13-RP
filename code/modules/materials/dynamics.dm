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
 * @params
 * * initial_modes - modes of attack the weapon normally is
 * * significance - a modifier that determines how well materials scale; lighter weapons scale less, etc. this is a very arbitrary value.
 *
 * @return list(damage, armorflag, tier, mode)
 */
/datum/material/proc/melee_stats(initial_modes, significance = MATERIAL_SIGNIFICANCE_BASELINE)
	var/cache_key = "[initial_modes]_[significance]"
	if(!isnull(melee_cache[cache_key]))
		return melee_cache[cache_key]
	. = new /list(MATERIAL_MELEE_STATS_LISTLEN)

	// https://www.desmos.com/calculator/dzyyj0vpem
	// this is far less documented than carry weight but this shit is hellish so whatever.

	// todo: damage mode flag has some overlap/confusing semantics
	if(initial_modes & (DAMAGE_MODE_PIERCE | DAMAGE_MODE_SHARP | DAMAGE_MODE_EDGE))
		// use hardness
		.[MATERIAL_MELEE_STATS_FLAG] = ARMOR_MELEE
		.[MATERIAL_MELEE_STATS_MODE] = initial_modes
		var/damage = (MATERIAL_DYNAMICS_DAMAGE_CEILING / (1 + (NUM_E ** -(MATERIAL_DYNAMICS_DAMAGE_LOGISTIC * ((hardness * MATERIAL_SIGNIFICANCE_TO_DAMAGE_INTENSIFIER(significance) * MATERIAL_DENSITY_TO_DAMAGE_INTENSIFIER(density) - MATERIAL_DYNAMICS_DAMAGE_SHIFT) / MATERIAL_DYNAMICS_DAMAGE_DIVISOR)))))
		.[MATERIAL_MELEE_STATS_DAMAGE] = damage
		.[MATERIAL_MELEE_STATS_TIER]
	else
		// use toughness, density
		.[MATERIAL_MELEE_STATS_FLAG] = ARMOR_MELEE
		.[MATERIAL_MELEE_STATS_MODE] = initial_modes
		var/damage = (MATERIAL_DYNAMICS_DAMAGE_CEILING / (1 + (NUM_E ** -(MATERIAL_DYNAMICS_DAMAGE_LOGISTIC * ((hardness * MATERIAL_SIGNIFICANCE_TO_DAMAGE_INTENSIFIER(significance) * MATERIAL_DENSITY_TO_DAMAGE_INTENSIFIER(density) - MATERIAL_DYNAMICS_DAMAGE_SHIFT) / MATERIAL_DYNAMICS_DAMAGE_DIVISOR)))))
		.[MATERIAL_MELEE_STATS_DAMAGE] = damage
		.[MATERIAL_MELEE_STATS_TIER]
	#warn impl

	melee_cache[cache_key] = .

