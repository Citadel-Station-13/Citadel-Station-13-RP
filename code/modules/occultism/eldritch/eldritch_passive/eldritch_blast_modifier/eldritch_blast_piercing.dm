//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Eldritch blasts invoked now have a piercing quality.
 */
/datum/prototype/eldritch_passive/eldritch_blast_piercing

/datum/prototype/eldritch_passive/eldritch_blast_piercing/on_holder_enable(datum/eldritch_holder/holder, datum/eldritch_passive_context/context)
	..()
	RegisterSignal(holder, COMSIG_ELDRITCH_HOLDER_FIRE_PROJECTILE, PROC_REF(on_projectile))

/datum/prototype/eldritch_passive/eldritch_blast_piercing/on_holder_disable(datum/eldritch_holder/holder, datum/eldritch_passive_context/context)
	..()
	UnregisterSignal(holder, COMSIG_ELDRITCH_HOLDER_FIRE_PROJECTILE)

/datum/prototype/eldritch_passive/eldritch_blast_piercing/proc/on_projectile(datum/eldritch_holder/source, mob/firer, obj/projectile/proj)

// TODO: impl

/datum/projectile_effect/eldritch_blast_piercing
	hook_impact = TRUE

/datum/projectile_effect/eldritch_blast_piercing/on_impact(obj/projectile/proj, atom/target, impact_flags, def_zone)
	. = ..()


