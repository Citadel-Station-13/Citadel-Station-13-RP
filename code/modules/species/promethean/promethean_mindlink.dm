//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Encapsulates a single link between a Stargazer and another entity.
 * * This is **mind-based**, **not** mob-based. If you are reading this and go,
 *   "won't this result in some really weird situations", the answer is yes.
 */
/datum/promethean_mindlink
	/// Target mind
	/// * Nullable
	var/datum/mind_ref/mind_ref
	/// Owning Stargazer mindnet
	var/datum/promethean_mindnet/mindnet
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
	///   from across the overmap.
	var/attunement_power_global = 0
	/// Passive attunement from same-overmap
	var/attunement_power_same_overmap = 10

	var/attunement_power_proximity_radius_min = 5
	var/attunement_power_proximity_radius_max = 25
	/// linear interpolated between proximity radius min/max
	var/attunement_power_proximity_max_power = 150

#warn impl
