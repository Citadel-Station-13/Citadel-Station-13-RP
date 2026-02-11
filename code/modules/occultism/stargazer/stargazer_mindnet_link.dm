//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * Encapsulates a single link between a Stargazer and another entity.
 * * This is **mind-based**, **not** mob-based. If you are reading this and go,
 *   "won't this result in some really weird situations", the answer is yes, as that's intended.
 */
/datum/stargazer_mindnet_link
	/// Target mind
	/// * Nullable
	var/datum/mind_ref/mind_ref
	/// Owning Stargazer mindnet
	var/datum/stargazer_mindnet/mindnet
	/// What we know to be their name
	/// * Doesn't automatically update; only updates when the Promethean
	///   directly looks at them with unobstructed FoV
	/// * Nullable
	var/known_name
	/// Established at (world.time)
	/// * Nullable
	var/established_at

	/// Passive attunement always
	/// * Leave this at 0; this is only here for admin edit reasons. Putting it
	///   to non-0 will allow a Promethean to sense someone / talk to them
	///   from across the overmap depending on how high it is.
	var/attunement_power_global = 0
	/// Passive attunement from same-overmap
	var/attunement_power_same_overmap = 20

	var/attunement_power_proximity_radius_min = 9
	var/attunement_power_proximity_radius_max = 48
	/// linear interpolated between proximity radius min/max
	var/attunement_power_proximity_max_power = 150

	var/attunement_power_see_target_min
	var/attunement_power_see_target_max
	var/attunement_power_see_owner_max
	var/attunement_power_see_owner_min

	var/tmp/cached_attunement_power
	var/tmp/cached_attunement_last_update
	var/tmp/cached_attunement_update_interval = 3 SECONDS

/datum/stargazer_mindnet_link/New(datum/stargazer_mindnet/mindnet, datum/mind_ref/mind_ref)
	src.mind_ref = mind_ref
	src.mindnet = mindnet

/datum/stargazer_mindnet_link/proc/get_attunement_power(force_update)
	update_attunement(force_update)
	return cached_attunement_power

/**
 * Gets current attunement with the target.
 *
 * @return TRUE if updated, FALSE otherwise
 */
/datum/stargazer_mindnet_link/proc/update_attunement(force_update)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

/**
 * * Please keep in mind that 'resolved_mob' very much may be an observer or something, or even null.
 *   This system targets **minds**, not **mobs**, for a reason.
 */
/datum/stargazer_mindnet_link/proc/update_attunement_impl(mob/resolved_mob)


#warn impl
