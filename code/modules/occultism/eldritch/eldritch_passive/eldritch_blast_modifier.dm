//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/prototype/eldritch_passive/eldritch_blast_modifier
	abstract_type = /datum/prototype/eldritch_passive/eldritch_blast_modifier

	var/list/projectile_hooks
	var/list/projectile_effects

/datum/prototype/eldritch_passive/eldritch_blast_modifier/on_holder_enable(datum/eldritch_holder/holder, datum/eldritch_passive_context/context)
	..()
	RegisterSignal(holder, COMSIG_ELDRITCH_HOLDER_FIRE_PROJECTILE, PROC_REF(on_projectile))

/datum/prototype/eldritch_passive/eldritch_blast_modifier/on_holder_disable(datum/eldritch_holder/holder, datum/eldritch_passive_context/context)
	..()
	UnregisterSignal(holder, COMSIG_ELDRITCH_HOLDER_FIRE_PROJECTILE)

/datum/prototype/eldritch_passive/eldritch_blast_modifier/proc/on_projectile(datum/eldritch_holder/source, mob/firer, obj/projectile/proj)
	proj.add_projectile_effects(projectile_effects)
	proj.add_projectile_hooks(projectile_hooks)
