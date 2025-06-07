//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Eldritch blasts invoked now have a piercing quality.
 */
/datum/prototype/eldritch_passive/patron/blade/eldritch_blast_piercing

/datum/prototype/eldritch_passive/patron/blade/eldritch_blast_piercing

// TODO: impl

/datum/projectile_effect/eldritch_blast_piercing
	hook_impact = TRUE

/datum/projectile_effect/eldritch_blast_piercing/on_impact(obj/projectile/proj, atom/target, impact_flags, def_zone)
	. = ..()


