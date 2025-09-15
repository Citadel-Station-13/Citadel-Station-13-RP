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
	if(!isliving(target))
		return impact_flags
	var/list/shock_results = target.electrocute(0, 0, 0, ELECTROCUTE_ACT_FLAG_SILENT, def_zone, proj)
	var/efficiency = shock_results[ELECTROCUTE_ACT_ARG_EFFICIENCY]
	var/mob/living/living_target = target
	living_target.apply_status_effect(status_effect_path, status_effect_duration * efficiency)
	return impact_flags
