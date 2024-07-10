//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * projectile effects
 *
 * * can be anonymous type'd, so global cache exists for given projectile typepath, not here!
 */
/datum/projectile_effect
	/// has impact effect
	var/hook_impact = FALSE
	/// has moved effect
	var/hook_moved = FALSE
	/// has on-range / lifetime expired effect
	var/hook_lifetime = FALSE

/**
 * @return new impact flags
 */
/datum/projectile_effect/proc/on_impact(obj/projectile/proj, atom/target, impact_flags, def_zone)
	return impact_flags

/datum/projectile_effect/proc/on_lifetime(obj/projectile/proj)
	return

/datum/projectile_effect/proc/on_moved(obj/projectile/proj, atom/old_loc)
	return
