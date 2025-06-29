//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Eldritch blasts invoked now have an AoE that fractures everything nearby, dealing slice damage.
 */
/datum/prototype/eldritch_passive/eldritch_blast_modifier/eldritch_blast_fracturing_impact
	id = "eldritch_blast_fracturing_impact"
	projectile_hooks = list(
		new /datum/projectile_hook/eldritch_blast_fracturing_impact,
	)

/datum/projectile_hook/eldritch_blast_fracturing_impact
	hook_impact = TRUE

/datum/projectile_hook/eldritch_blast_fracturing_impact/on_impact(obj/projectile/proj, atom/target, impact_flags, def_zone)
	if(isturf(target))
		return
	. = ..()

#warn impl
