//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

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
	/// * "Yes, I will handle SHIELDCALL_FLAG_SECOND_CALL to prevent a double-block scenario"
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

//* Melee Handling *//

/**
 * sent over from the atom
 *
 * * this is generic pre-intercept for melee; please keep this cheap
 * * for stuff like reactive teleport armor, use this because it will stop the hit entirely.
 * * for damage modification, inject directly into e_args
 *
 * @params
 * * defending - the atom being attacked
 * * shieldcall_returns - existing returns from other shieldcalls
 * * fake_attack - just checking!
 * * clickchain (optional) the clickchain event, if any; **This is mutable.**
 * * clickchain_flags (optional) the clickchain flags being used
 * * weapon - (optional) the item being used to swing with
 * * style - the melee_attack/weapon datum being used
 *
 * @return SHIELDCALL_FLAG_* flags
 */
/datum/shieldcall/proc/handle_melee(atom/defending, shieldcall_returns, fake_attack, datum/event_args/actor/clickchain/clickchain, clickchain_flags, obj/item/weapon, datum/melee_attack/weapon/style)
	return NONE

//* Interaction Handling *//

/**
 * sent over from the atom
 *
 * * for generic 'tried to touch' things
 * * this is really funny because it lets us do things like teleport the RD on a hug
 *
 * @params
 * * defending - the atom in question
 * * shieldcall_returns - existing returns from other shieldcalls
 * * fake_attack - just checking!
 * * clickchain (optional) the clickchain event, if any; **This is mutable.**
 * * clickchain_flags (optional) the clickchain flags being used
 * * contact_flags - SHIELDCALL_CONTACT_FLAG_*
 * * contact_specific - SHIELDCALL_CONTACT_SPECIFIC_*
 *
 * @return SHIELDCALL_FLAG_* flags
 */
/datum/shieldcall/proc/handle_touch(atom/defending, shieldcall_returns, fake_attack, datum/event_args/actor/clickchain/clickchain, clickchain_flags, contact_flags, contact_specific)
	return NONE

//* Projectile Handling *//

/**
 * sent over from the atom
 *
 * * this is pre-intercept for projectiles; please keep this cheap.
 * * for stuff like reactive teleport armor, use this because it will stop the hit entirely.
 * * passed in bullet act args is mutable.
 * * we DO NOT process SHIELDCALL_FLAG flags other than _TERMINATE, because we have direct access to impact_flags of the bullet!
 *
 * @params
 * * defending - the atom in question
 * * shieldcall_returns - existing returns from other shieldcalls
 * * fake_attack - just checking!
 * * bullet_act_args - indexed list of bullet_act args.
 *
 * @return SHIELDCALL_FLAG_TERMINATE or NONE
 */
/datum/shieldcall/proc/handle_bullet(atom/defending, shieldcall_returns, fake_attack, list/bullet_act_args)
	return NONE

//* Throw Handling *//

/**
 * sent over from the atom
 *
 * * this is pre-intercept for throwns
 * * for stuff like reactive teleport armor, use this because it will stop the hit entirely
 *
 * @params
 * * defending - the thing being hit
 * * shieldcall_returns - existing returns from other shieldcalls
 * * fake_attack - just checking!
 * * thrown - the thrown object's data
 *
 * @return SHIELDCALL_FLAG_* flags
 */
/datum/shieldcall/proc/handle_throw_impact(atom/defending, shieldcall_returns, fake_attack, datum/thrownthing/thrown)
	return

//* Bound Variant *//

/datum/shieldcall/bound
	var/expected_type
	var/datum/bound

/datum/shieldcall/bound/New(datum/binding)
	ASSERT(expected_type && istype(binding, expected_type))
	src.bound = binding

/datum/shieldcall/bound/Destroy()
	src.bound = null
	return ..()
