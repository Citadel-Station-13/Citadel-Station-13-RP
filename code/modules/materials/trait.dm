//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/material_trait
	/// trait flags: what we care about
	var/material_trait_flags = NONE

/datum/material_trait/proc/on_mob_outbound_melee(mob/target, obj/item/using, mob/attacker, mult = 1)

/datum/material_trait/proc/on_mob_inbound_melee(mob/target, obj/item/defending, mob/attacker, mult = 1)

/datum/material_trait/proc/on_mob_outbound_projectile(mob/target, obj/projectile/using)

/datum/material_trait/proc/on_mob_inbound_projectile(mob/target, obj/item/defending, obj/projectile/proj)

/datum/material_trait/proc/on_examine(atom/examining, list/examine_list)

/datum/material_trait/proc/tick(dt, atom/owner)

#warn impl all
