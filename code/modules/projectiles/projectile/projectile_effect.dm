//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

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
	/// has damage effect
	var/hook_damage = FALSE

/**
 * * you'll note that [efficiency] is not a thing here
 * * this is because this runs regardless of target's opinion
 * * this means you should probably be careful and check impact_flags!
 *
 * @return new impact flags
 */
/datum/projectile_effect/proc/on_impact(obj/projectile/proj, atom/target, impact_flags, def_zone)
	return impact_flags

/**
 * * you'll note that [efficiency] **is** a thing here
 * * this only runs if we're able to damage the target
 *
 * @return new impact flags
 */
/datum/projectile_effect/proc/on_damage(obj/projectile/proj, atom/target, impact_flags, def_zone, efficiency)
	return impact_flags

/**
 * Do not delete the projectile, the projectile does that.
 *
 * todo: add way to delete projectile so it doesn't drop stuff i guess for foam and whatnot
 *
 * @params
 * * proj - the projectile
 * * impact_ground_on_expiry - we should impact the ground on expiry; a projectile var, but relay'd in for override capability later
 */
/datum/projectile_effect/proc/on_lifetime(obj/projectile/proj, impact_ground_on_expiry)
	return

/datum/projectile_effect/proc/on_moved(obj/projectile/proj, atom/old_loc)
	return
