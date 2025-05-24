//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * Like components, but for materials.
 */
/datum/prototype/material_trait
	/// trait flags: what we care about
	var/material_trait_flags = NONE
	/// only register for a material that's primary
	var/primary_only = FALSE
	/// our shieldcall, if any
	var/datum/shieldcall/material_trait/shieldcall
	/// shieldcall should react to equipped
	var/should_shield_inventory = TRUE

/datum/prototype/material_trait/New()
	if(material_trait_flags & MATERIAL_TRAIT_SHIELD)
		init_shieldcall(should_shield_inventory)

//* Basic procs; handled by add/remove abstraction API *//

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
/datum/prototype/material_trait/proc/on_add(atom/host, existing_data, our_data)
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
/datum/prototype/material_trait/proc/on_remove(atom/host, existing_data, our_data, destroying)
	if(destroying)
		return
	// by default, just track how many copies we're on something
	return (existing_data - 1) || null

/datum/prototype/material_trait/proc/start_ticking_on(atom/target)
	if(!target.material_ticking_counter)
		START_TICKING_MATERIALS(target)
	++target.material_ticking_counter

/datum/prototype/material_trait/proc/stop_ticking_on(atom/target)
	--target.material_ticking_counter
	if(!target.material_ticking_counter)
		STOP_TICKING_MATERIALS(target)

/**
 * creates a shieldcall datum that redirects to us
 */
/datum/prototype/material_trait/proc/init_shieldcall(should_shield_inventory)
	if(!isnull(shieldcall))
		CRASH("attempted to double-init shieldcalls")
	shieldcall = new(src, should_shield_inventory)

/**
 * called when something with this material attacks a mob
 *
 * todo: need a better hook system for melee vs ranged attacks, much like shieldcall is for defense.
 *
 * @params
 * * host - the atom attacking them that has us as a material
 * * data - metadata
 * * clickchain - clickchain data
 * * clickchain_flags - clickchain flags
 * * attack_style - attack style used
 */
/datum/prototype/material_trait/proc/on_melee_finalize(atom/host, data, datum/event_args/actor/clickchain/clickchain, clickchain_flags, datum/melee_attack/weapon/attack_style)
	return

/**
 * called when an atom with this material has its shieldcalls invoked
 *
 * The way this works is you need to register this trait's shieldcall,
 * which is generated on New() if MATERIAL_TRAIT_SHIELD is set in flags,
 * on atoms via [on_add()] and [on_remove()].
 *
 * The shieldcall will react to inventory if [should_should_inventroy] is set.
 *
 * todo: the way this works is a bit inefficient.
 *
 * @params
 * * host - the atom calling that has us as a material
 * * data - metadata
 * * shieldcall_args - indexed list of shieldcall args.
 */
/datum/prototype/material_trait/proc/on_shieldcall(atom/host, data, list/shieldcall_args)
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
/datum/prototype/material_trait/proc/on_examine(atom/host, data, list/examine_list, atom/examiner, distance)
	return

/**
 * called on tick from SSmaterials
 */
/datum/prototype/material_trait/proc/tick(atom/host, data, dt)
	return

/**
 * material trait shieldcalls
 */
/datum/shieldcall/material_trait
	var/datum/prototype/material_trait/trait

/datum/shieldcall/material_trait/New(datum/prototype/material_trait/trait, should_shield_inventory)
	..()
	src.trait = trait
	src.shields_in_inventory = should_shield_inventory

/datum/shieldcall/material_trait/handle_shieldcall(atom/defending, list/shieldcall_args)
	return trait.on_shieldcall(defending, defending.material_traits[trait], shieldcall_args)
