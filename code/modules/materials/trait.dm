//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/material_trait
	/// trait flags: what we care about
	var/material_trait_flags = NONE

/**
 * called when something with this material attacks a mob
 *
 * todo: need a better hook system for melee vs ranged attacks, much like shieldcall is for defense.
 *
 * @params
 * * target - mob being hit
 * * zone - target zone
 * * attack_source - what's damaging them. datatype semantics differs based on attack type
 * * attack_type - ATTACK_TYPE_* define
 * * attacking - the atom attacking them that has us as a material
 */
/datum/material_trait/proc/on_mob_attack(mob/target, zone, atom/attack_source, attack_type, atom/attacking)
	return

/**
 * called when used as armor against melee or projectile
 *
 * todo: use atom shieldcall system instead
 * todo: or use run mob armor system and figure out a way to put shieldcall-like flags on it
 *
 * @params
 * * target - mob being hit
 * * zone - target zone
 * * damage_source - what's damaging them. datatype semantics differs based on attack type
 * * attack_type - ATTACK_TYPE_* define
 * * defending - the item defending them that has us as a material
 *
 * @return MATERIAL_DEFEND_* flags
 */
/datum/material_trait/proc/on_mob_defense(mob/target, zone, atom/damage_source, attack_type, obj/item/defending)
	return

/**
 * called when examined
 */
/datum/material_trait/proc/on_examine(atom/examining, list/examine_list, atom/examiner, distance)
	return

#warn lazy ticking - start/stop ticking?? on atom.

/**
 * called on tick from SSmaterials
 */
/datum/material_trait/proc/tick(dt, atom/owner)

/**
 * called when we're added to something
 *
 * use this to set up scratch list & effects
 */
/datum/material_trait/proc/on_add(atom/what)

/**
 * called when we're removed from something
 *
 * use this to tear down scratch list & effects
 */
/datum/material_trait/proc/on_remove(atom/what)

#warn impl all
