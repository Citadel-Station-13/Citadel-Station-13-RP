//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/material_trait
	/// trait flags: what we care about
	var/material_trait_flags = NONE
	/// only register for a material that's primary
	var/primary_only = FALSE

/**
 * called when something with this material attacks a mob
 *
 * todo: need a better hook system for melee vs ranged attacks, much like shieldcall is for defense.
 *
 * @params
 * * host - the atom attacking them that has us as a material
 * * data - metadata
 * * target - mob being hit
 * * zone - target zone
 * * weapon - what's damaging them. datatype semantics differs based on attack type
 * * attack_type - ATTACK_TYPE_* define
 */
/datum/material_trait/proc/on_mob_attack(atom/host, data, mob/target, zone, datum/weapon, attack_type)
	return

/**
 * called when used as armor against melee or projectile
 *
 * todo: use atom shieldcall system instead
 * todo: or use run mob armor system and figure out a way to put shieldcall-like flags on it
 *
 * @params
 * * host - the item defending them that has us as a material
 * * data - metadata
 * * target - mob being hit
 * * zone - target zone
 * * weapon - what's damaging them. datatype semantics differs based on attack type
 * * attack_type - ATTACK_TYPE_* define
 *
 * @return MATERIAL_DEFEND_* flags
 */
/datum/material_trait/proc/on_mob_defense(obj/item/host, data, mob/target, zone, datum/weapon, attack_type)
	return

/**
 * called when examined
 *
 * @params
 * * host - the thing being examined
 * * data - metadata
 * * examine_list - the examine list
 * * examiner - person examining
 * * distance - distance being examined at
 */
/datum/material_trait/proc/on_examine(atom/host, data, list/examine_list, atom/examiner, distance)
	return

/**
 * called on tick from SSmaterials
 */
/datum/material_trait/proc/tick(atom/host, data, dt)
	return

/**
 * called when we're added to something
 *
 * use this to set up scratch list & effects
 *
 * @params
 * * host - the thing that has a material with us as a trait
 * * existing_data - the data of this trait already on the thing
 * * our_data - the data we're associated to on the material
 *
 * @return changed data, that isn't null.
 */
/datum/material_trait/proc/on_add(atom/host, existing_data, our_data)
	// by default, just track how many copies we're on something
	return existing_data + 1

/**
 * called when we're removed from something
 *
 * use this to tear down scratch list & effects
 *
 * @params
 * * host - the thing that has a material with us as a trait
 * * existing_data - the data of this trait already on the thing
 * * our_data - the data we're associated to on the material
 *
 * @return changed data, or null to fully remove.
 */
/datum/material_trait/proc/on_remove(atom/host, existing_data, our_data)
	// by default, just track how many copies we're on something
	return (existing_data - 1) || null
