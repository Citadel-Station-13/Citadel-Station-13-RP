//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * eldritch blast spreads rust on impact
 */
/datum/prototype/eldritch_passive/eldritch_blast_rusting_impact
	id = "eldritch_blast_rusting_impact"

// TODO: impl

/datum/projectile_effect/eldritch_blast_rusting_impact
	hook_impact = TRUE

/datum/projectile_effect/eldritch_blast_rusting_impact/on_impact(obj/projectile/proj, atom/target, impact_flags, def_zone)
    . = ..()
