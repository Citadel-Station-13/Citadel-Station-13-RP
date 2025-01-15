//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Electrical probes; hits the target with an electrical stun probe
 */
/datum/projectile_effect/electrical_probe
	hook_impact = TRUE
	/// stun effect
	var/status_effect_path = /datum/status_effect/taser_stun
	/// stun effect duration
	var/status_effect_duration = 5 SECONDS

/datum/projectile_effect/electrical_probe/on_impact(obj/projectile/proj, atom/target, impact_flags, def_zone)
	return impact_flags

#warn impl
