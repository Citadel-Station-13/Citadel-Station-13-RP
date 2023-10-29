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
 * called when something with this material attacks an atom that isn't a mob
 *
 * @params
 * * host - the atom attacking them that has us as a material
 * * data - metadata
 * * target - atom being hit
 * * weapon - what's damaging them. datatype semantics differs based on attack type
 * * attack_type - ATTACK_TYPE_* define
 */
/datum/material_trait/proc/on_obj_attack(atom/host, data, atom/target, datum/weapon, attack_type)
	return

/**
 * called when an atom with this material has its shieldcalls invoked
 *
 * @params
 * * host - the atom calling that has us as a material
 * * data - metadata
 * * shieldcall_args - indexed list of shieldcall args.
 */
/datum/material_trait/proc/on_shieldcall(atom/host, data, list/shieldcall_args)
	return

#warn mob shieldcall?

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
 * * destroying - called if this is during qdel; in that case, our_data is null.
 *
 * If it is mid-destroy, it is **not** necessary to clean up ticking, because the Destroy() proc will do it for us.appearance
 *
 * @return changed data, or null to fully remove.
 */
/datum/material_trait/proc/on_remove(atom/host, existing_data, our_data, destroying)
	if(destroying)
		return
	// by default, just track how many copies we're on something
	return (existing_data - 1) || null

/datum/material_trait/proc/start_ticking_on(atom/target)
	if(!target.material_ticking_counter)
		START_TICKING_MATERIALS(target)
	++target.material_ticking_counter

/datum/material_trait/proc/stop_ticking_on(atom/target)
	--target.material_ticking_counter
	if(!target.material_ticking_counter)
		STOP_TICKING_MATERIALS(target)
