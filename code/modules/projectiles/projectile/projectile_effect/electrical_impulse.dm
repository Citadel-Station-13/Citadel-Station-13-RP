//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Electrical shocks; releases a shock on impact.
 */
/datum/projectile_effect/electrical_impulse
	hook_impact = TRUE

	/// in kj
	var/shock_energy = 0
	var/shock_damage = 0
	var/shock_agony = 0
	var/shock_flags = NONE

/datum/projectile_effect/electrical_impulse/on_impact(obj/projectile/proj, atom/target, impact_flags, def_zone)
	target.electrocute(shock_energy, shock_damage, shock_agony, shock_flags, def_zone, proj)
	return impact_flags
