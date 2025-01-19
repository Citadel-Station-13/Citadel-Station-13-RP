//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Electrical stuns; releases a shock on impact.
 */
/datum/projectile_effect/electrical_stun
	hook_impact = TRUE

/datum/projectile_effect/electrical_stun/on_impact(obj/projectile/proj, atom/target, impact_flags, def_zone)
	return impact_flags

#warn impl
