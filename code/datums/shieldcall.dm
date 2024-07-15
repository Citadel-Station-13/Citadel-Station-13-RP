//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

GLOBAL_LIST_EMPTY(cached_shieldcall_datums)

/**
 * return a globally cached shieldcall
 * mostly for hardcoded ones that always work a certain way regardless of what it's actually representing
 */
/proc/fetch_cached_shieldcall(path)
	if(GLOB.cached_shieldcall_datums[path])
		return GLOB.cached_shieldcall_datums[path]
	GLOB.cached_shieldcall_datums[path] = new path
	return GLOB.cached_shieldcall_datums[path]

/**
 * Shieldcall handling datums
 *
 * These are semi-expensive datums that act as hooks
 * to intercept arbitrary attacks at the /atom level.
 *
 * Please be careful with their usage.
 * They hook most attacks, and as such are pretty expensive to have on an atom, compute-wise.
 * This is pretty much only efficient for single-target; if it's possible, any suppression hook for attacks
 * is better than using this on a large number of targets.
 */
/datum/shieldcall
	/// priority ; should never change once we're registered on something. lower has higher priority.
	var/priority = 0
	/// goes to mob when in inventory - whether equipped to slot or in hand
	/// do not modify while applied. it will not un/register properly.
	///
	/// * Turn this off if you're doing your own handling.
	var/shields_in_inventory = TRUE
	/// Allow interception of `atom_shieldcall`.
	///
	/// * "Yes, I read and understand the terms and conditions"
	/// * "Yes, I will handle SHIELDCALL_RETURN_SECOND_CALL to prevent a double-block scenario"
	/// * "Yes, I understand that atom_shieldcall is low level and is called in addition to other shieldcall handling procs"
	var/low_level_intercept = FALSE

/**
 * sent over from the atom
 *
 * @params
 * * defending - the atom in question
 * * shieldcall_args - indexed list of shieldcall args.
 * * fake_attack - just checking!
 *
 * @return nothing, because you should be modifying the return flags via shieldcall_args list!
 */
/datum/shieldcall/proc/handle_shieldcall(atom/defending, list/shieldcall_args, fake_attack)
	return

//* Projectile Handling *//

/**
 * sent over from the atom
 *
 * * this is pre-intercept for projectiles; please keep this cheap.
 * * for stuff like reactive teleport armor, use this because it will stop the hit entirely.
 * * passed in bullet act args is mutable.
 * * we DO NOT process SHIELDCALL_RETURN flags other than _TERMINATE, because we have direct access to impact_flags of the bullet!
 *
 * @params
 * * defending - the atom in question
 * * bullet_act_args - indexed list of bullet_act args.
 * * shieldcall_returns - existing returns from other shieldcalls
 * * fake_attack - just checking!
 *
 * @return SHIELDCALL_TERMINATE or NONE
 */
/datum/shieldcall/proc/handle_bullet(atom/defending, list/bullet_act_args, shieldcall_returns, fake_attack)
	return NONE
