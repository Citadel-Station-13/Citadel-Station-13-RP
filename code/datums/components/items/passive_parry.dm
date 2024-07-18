//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * generic parry provider on items
 *
 * this is effectively the old rng block system
 *
 * also known as: autoparry.
 */
/datum/component/passive_parry
	registered_type = /datum/component/passive_parry

	/// passive parry data
	var/datum/passive_parry/parry_data
	/// callback to invoke before the parry is initiated
	///
	/// * if it returns a parry frame, it'll override the frame provided by the passive parry datum
	/// * if it returns null, it'll cancel the parry
	/// * invoked, if existing, with (obj/item/parent, mob/defending, list/shieldcall_args, datum/passive_parry/parry_data)
	/// * this allows you to construct a custom parry frame
	/// * this will be null'd, not qdel'd, when the component is qdel'd
	var/datum/callback/parry_intercept
	/// registered? just for optimizations
	var/hooked = FALSE

/datum/component/passive_parry/Initialize(datum/passive_parry/data, datum/callback/intercept)
	. = ..()
	if(. == COMPONENT_INCOMPATIBLE)
		return
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	data = fetch_data(data)
	if(!istype(data))
		. = COMPONENT_INCOMPATIBLE
		CRASH("invalid data")
	src.parry_data = data
	src.parry_intercept = intercept

/datum/component/passive_parry/Destroy()
	parry_data = null // parry data holds no refs
	parry_intercept = null // i'd hope this doesn't hold a ref to us.
	return ..()

/datum/component/passive_parry/proc/fetch_data(datum/passive_parry/datalike)
	if(IS_ANONYMOUS_TYPEPATH(datalike))
		return new datalike
	if(ispath(datalike))
		return resolve_passive_parry_data(datalike)
	if(istype(datalike))
		return datalike

/datum/component/passive_parry/RegisterWithParent()
	. = ..()

/datum/component/passive_parry/UnregisterFromParent()
	. = ..()

/datum/component/passive_parry/proc/on_equipped(obj/item/source, mob/user, slot, accessory)
	if(!check_slot(slot))
		return
	if(hooked)
		return
	hooked = TRUE
	if(parry_data.parry_chance_melee)
		#warn impl
	if(parry_data.parry_chance_touch)
		#warn impl
	if(parry_data.parry_chance_projectile)
		#warn impl
	if(parry_data.parry_chance_thrown)
		#warn impl

/datum/component/passive_parry/proc/on_unequipped(obj/item/source, mob/user, slot, accessory)
	if(!hooked)
		return
	hooked = FALSE

	UnregisterSignal(user, list(
		COMSIG_ATOM_BULLET_ACT,
	))

/datum/component/passive_parry/proc/on_bullet(mob/source, list/bullet_act_args)

/datum/component/passive_parry/proc/

/datum/component/passive_parry/proc/check_slot(slot_id)
	return islist(parry_data.parry_slot_id)? (slot_id in parry_data.parry_slot_id) : (!parry_data.parry_slot_id || (parry_data.parry_slot_id == slot_id))

#warn impl

//* Item *//

#warn impl
/**
 * Called by /datum/component/passive_parry when we're about to start up the parry frame
 * Called if parry intercept callback isn't set.
 *
 * @return parry frame datum to use, or null to cancel
 */
/obj/item/proc/passive_parry_intercept(mob/defending, list/shieldcall_args, datum/passive_parry/parry_data)
	return parry_data.parry_frame

#warn impl

//* Data *//

GLOBAL_LIST_EMPTY(passive_parry_data)
/**
 * get a cached version of a passive paary datum
 */
/proc/resolve_passive_parry_data(datum/passive_parry/datalike)
	if(IS_ANONYMOUS_TYPEPATH(datalike))
		return new datalike
	if(istype(datalike))
		return datalike
	if(!GLOB.passive_parry_data[datalike])
		GLOB.passive_parry_data[datalike] = new datalike
	return GLOB.passive_parry_data[datalike]

/**
 * datum for holding data on passive parrying
 */
/datum/passive_parry
	/// parry chance for harmful melee: [0, 100]
	var/parry_chance_melee
	/// parry chance for (seemingly) benign melee: [0, 100]
	var/parry_chance_touch
	/// parry chance for inbound projectile: [0, 100]
	var/parry_chance_projectile
	/// parry chance for inbound throw
	var/parry_chance_thrown
	/// default parry chance if one of the above is null
	var/parry_chance_default = 0

	/// passive parry arc
	var/parry_arc = 180
	/// passive parry arc should round down for non-projectiles
	var/parry_arc_round_down = TRUE

	/// valid slot ids; null for all, list for multiple, singular for single
	var/parry_slot_id = SLOT_ID_HANDS

	/// projectile types we autoparry on
	var/parry_projectile_types = ALL

	/// parry frame data to use by default
	///
	/// * can be a typepath
	/// * can be an anonymous typepath
	/// * can be a datum
	var/parry_frame = /datum/parry_frame/passive_block
	/// simulate a full parry frame with carry-through and duration, or just run the frame once
	var/parry_frame_simulated = FALSE
	/// if not simulated, what's our efficiency? [0, 1]
	var/parry_frame_efficiency = 1
	/// if simulated, how far in do we start? [0, infinity]
	var/parry_frame_timing = 0
	/// override the parry arc on our parry frame
	var/parry_frame_set_arc = TRUE

/datum/parry_frame/passive_block
	parry_can_prevent_contact = TRUE
