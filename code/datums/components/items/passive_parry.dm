//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Shieldcall used as a listener for [/datum/component/passive_parry]
 */
/datum/shieldcall/bound/passive_parry
	expected_type = /datum/component/passive_parry

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
	/// * must return /datum/parry_frame or null.
	/// * if it returns a parry frame, it'll override the frame provided by the passive parry datum
	/// * if it returns null, it'll cancel the parry
	/// * invoked, if existing, with (obj/item/parent, mob/defending, attack_type, datum/attack_source, datum/passive_parry/parry_data)
	/// * this allows you to construct a custom parry frame
	/// * this will be null'd, not qdel'd, when the component is qdel'd
	var/datum/callback/parry_intercept
	/// our registered shieldcall
	var/datum/shieldcall/bound/passive_parry/hooked_shieldcall
	/// the mob we're registered with right now
	var/mob/hooked

/datum/component/passive_parry/Initialize(datum/passive_parry/data, datum/callback/intercept)
	. = ..()
	if(. == COMPONENT_INCOMPATIBLE)
		return
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	data = fetch_data(data)
	if(!data)
		stack_trace("invalid data")
		return COMPONENT_INCOMPATIBLE
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

/**
 * About to start a parry. Resolve parry_frame datum.
 */
/datum/component/passive_parry/proc/ignite(atom/defending, attack_type, datum/attack_source)
	RETURN_TYPE(/datum/parry_frame)
	if(parry_intercept)
		return parry_intercept.invoke_no_sleep(parent, defending, attack_type, attack_source, parry_data)
	else
		var/obj/item/item = parent
		return item.passive_parry_intercept(defending, attack_type, attack_source, parry_data)

/datum/component/passive_parry/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equipped))
	RegisterSignal(parent, COMSIG_ITEM_DROPPED, PROC_REF(on_dropped))
	if(!hooked)
		var/obj/item/item = parent
		if(item.get_worn_mob())
			on_equipped(item, item.get_worn_mob(), item.worn_slot)

/datum/component/passive_parry/UnregisterFromParent()
	. = ..()
	UnregisterSignal(parent, COMSIG_ITEM_EQUIPPED)
	if(hooked)
		var/obj/item/item = parent
		on_unequipped(item, hooked)

/datum/component/passive_parry/proc/on_dropped(obj/item/source, inv_op_flags, atom/new_loc)
	// delete on drop to save memory
	qdel(src)

/datum/component/passive_parry/proc/on_equipped(obj/item/source, mob/user, slot)
	if(!check_slot(slot))
		return
	if(hooked)
		return
	ASSERT(user)
	hooked = user
	hooked_shieldcall = new(src)
	user.register_shieldcall(hooked_shieldcall)
	RegisterSignal(user, COMSIG_ATOM_SHIELDCALL_ITERATION, PROC_REF(shieldcall_iterating))

/datum/component/passive_parry/proc/on_unequipped(obj/item/source, mob/user)
	ASSERT(user == hooked)
	hooked = null
	user.unregister_shieldcall(hooked_shieldcall)
	QDEL_NULL(hooked_shieldcall)
	UnregisterSignal(user, COMSIG_ATOM_SHIELDCALL_ITERATION, PROC_REF(shieldcall_iterating))

/datum/component/passive_parry/proc/check_slot(slot_id)
	return islist(parry_data.parry_slot_id)? (slot_id in parry_data.parry_slot_id) : (!parry_data.parry_slot_id || (parry_data.parry_slot_id == slot_id))

/datum/component/passive_parry/proc/shieldcall_iterating(mob/source, shieldcall_type)
	SIGNAL_HANDLER
	ASSERT(source == hooked)
	var/datum/passive_parry/data = fetch_data(parry_data)
	// normal shieldcall handlers handle it
	if(!data.parry_frame_simulated)
		return
	var/datum/parry_frame/resolved = ignite(source)
	if(!resolved)
		return
	// for now, we only care about if they already have a frame
	// in the future, maybe this can fire as long as we aren't the source of a parry frame on them.
	// todo: cooldown enforcement
	// todo: mobility enforcement
	// todo: full parry swing cycle?
	if(!source.GetComponent(/datum/component/parry_frame))
		source.AddComponent(/datum/component/parry_frame, resolved, data.parry_frame_timing)

//* Bindings - Bullet *//

/datum/shieldcall/bound/passive_parry/handle_bullet(atom/defending, shieldcall_returns, fake_attack, list/bullet_act_args)
	// todo: no support for fake attacks yet
	if(fake_attack)
		return
	// this is a definite 'do as i say, not as i do' moment
	// this works because the proc names and args and types are **exactly** matching
	// this is why the procs are all together
	// do NOT try this at home.
	return bound:handle_bullet(arglist(args))

/datum/component/passive_parry/proc/handle_bullet(atom/defending, shieldcall_returns, fake_attack, list/bullet_act_args)
	var/datum/passive_parry/data = parry_data
	if(data.parry_frame_simulated)
		return
	if(!prob(isnull(data.parry_chance_projectile) ? data.parry_chance_default : data.parry_chance_projectile))
		return
	if(!check_defensive_arc_tile(defending, bullet_act_args[BULLET_ACT_ARG_PROJECTILE], data.parry_arc, !data.parry_arc_round_down))
		return
	// - Projectile-specific -
	var/obj/projectile/proj = bullet_act_args[BULLET_ACT_ARG_PROJECTILE]
	if(!(proj.projectile_type & data.parry_projectile_types))
		return
	// - End -
	var/datum/parry_frame/resolved = ignite(defending, ATTACK_TYPE_PROJECTILE, bullet_act_args[BULLET_ACT_ARG_PROJECTILE])
	if(!resolved)
		return
	return resolved.handle_bullet(defending, shieldcall_returns | SHIELDCALL_FLAG_SINGLE_PARRY, fake_attack, data.parry_frame_efficiency, bullet_act_args, parent)

//* Bindings - Melee *//

/datum/shieldcall/bound/passive_parry/handle_melee(atom/defending, shieldcall_returns, fake_attack, datum/event_args/actor/clickchain/clickchain, clickchain_flags, obj/item/weapon, datum/melee_attack/weapon/style)
	// todo: no support for fake attacks yet
	if(fake_attack)
		return
	// this is a definite 'do as i say, not as i do' moment
	// this works because the proc names and args and types are **exactly** matching
	// this is why the procs are all together
	// do NOT try this at home.
	return bound:handle_melee(arglist(args))

/datum/component/passive_parry/proc/handle_melee(atom/defending, shieldcall_returns, fake_attack, datum/event_args/actor/clickchain/clickchain, clickchain_flags, obj/item/weapon, datum/melee_attack/weapon/style)
	var/datum/passive_parry/data = parry_data
	if(data.parry_frame_simulated)
		return
	if(!prob(isnull(data.parry_chance_melee) ? data.parry_chance_default : data.parry_chance_melee))
		return
	if(!check_defensive_arc_tile(defending, clickchain.performer, data.parry_arc, !data.parry_arc_round_down))
		return
	var/datum/parry_frame/resolved = ignite(defending, ATTACK_TYPE_MELEE, clickchain)
	if(!resolved)
		return
	return resolved.handle_melee(defending, shieldcall_returns | SHIELDCALL_FLAG_SINGLE_PARRY, fake_attack, data.parry_frame_efficiency, clickchain, style, weapon, parent)

/datum/shieldcall/bound/passive_parry/handle_touch(atom/defending, shieldcall_returns, fake_attack, datum/event_args/actor/clickchain/clickchain, clickchain_flags, contact_flags, contact_specific)
	// todo: no support for fake attacks yet
	if(fake_attack)
		return
	// this is a definite 'do as i say, not as i do' moment
	// this works because the proc names and args and types are **exactly** matching
	// this is why the procs are all together
	// do NOT try this at home.
	return bound:handle_touch(arglist(args))

/datum/component/passive_parry/proc/handle_touch(atom/defending, shieldcall_returns, fake_attack, datum/event_args/actor/clickchain/clickchain, clickchain_flags, contact_flags, contact_specific)
	var/datum/passive_parry/data = parry_data
	if(data.parry_frame_simulated)
		return
	if(!prob(isnull(data.parry_chance_touch) ? data.parry_chance_default : data.parry_chance_touch))
		return
	if(!check_defensive_arc_tile(defending, clickchain.performer, data.parry_arc, !data.parry_arc_round_down))
		return
	var/datum/parry_frame/resolved = ignite(defending, ATTACK_TYPE_TOUCH, null)
	if(!resolved)
		return
	return resolved.handle_touch(defending, shieldcall_returns | SHIELDCALL_FLAG_SINGLE_PARRY, fake_attack, data.parry_frame_efficiency, clickchain, contact_flags, contact_specific, parent)

//* Bindings - Thrown *//

/datum/shieldcall/bound/passive_parry/handle_throw_impact(atom/defending, shieldcall_returns, fake_attack, datum/thrownthing/thrown)
	// todo: no support for fake attacks yet
	if(fake_attack)
		return
	// this is a definite 'do as i say, not as i do' moment
	// this works because the proc names and args and types are **exactly** matching
	// this is why the procs are all together
	// do NOT try this at home.
	return bound:handle_throw_impact(arglist(args))

/datum/component/passive_parry/proc/handle_throw_impact(atom/defending, shieldcall_returns, fake_attack, datum/thrownthing/thrown)
	var/datum/passive_parry/data = parry_data
	if(data.parry_frame_simulated)
		return
	if(!prob(isnull(data.parry_chance_thrown) ? data.parry_chance_default : data.parry_chance_thrown))
		return
	if(!check_defensive_arc_tile(defending, thrown, data.parry_arc, !data.parry_arc_round_down))
		return
	var/datum/parry_frame/resolved = ignite(defending, ATTACK_TYPE_THROWN, thrown)
	if(!resolved)
		return
	return resolved.handle_throw_impact(defending, shieldcall_returns | SHIELDCALL_FLAG_SINGLE_PARRY, fake_attack, data.parry_frame_efficiency, thrown, parent)

//* Item *//

/**
 * Called by /datum/component/passive_parry when we're about to start up the parry frame
 * Called if parry intercept callback isn't set.
 *
 * @params
 * * defending - mob being defended
 * * attack_type - (optional) attack type
 * * weapon - (optional) the weapon
 * * parry_data - (optional) the existing parry data
 *
 * @return parry frame datum to use, or null to cancel
 */
/obj/item/proc/passive_parry_intercept(mob/defending, attack_type, datum/attack_source, datum/passive_parry/parry_data)
	return parry_data.parry_frame

//* Data *//

GLOBAL_LIST_EMPTY(passive_parry_data)
/**
 * get a cached version of a passive paary datum
 */
/proc/resolve_passive_parry_data(datum/passive_parry/datalike)
	if(isnull(datalike))
		return
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
	///
	/// * at 136 (1 more than 135), having this TRUE means non-projectiles can hit them from behind as behind is 180.
	/// * at 136 (1 more than 135), having this be FALSE means non-projectiles **cannot** hit them from behind as behind is 180.
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
	///
	/// * only used if not simulated
	var/parry_frame_efficiency = 1
	/// if simulated, how far in do we start? [0, infinity]
	///
	/// * only used if simulated
	var/parry_frame_timing = 0

/datum/passive_parry/New()
	if(IS_ANONYMOUS_TYPEPATH(parry_frame))
		parry_frame = new parry_frame
	else if(ispath(parry_frame))
		parry_frame = new parry_frame
	else if(istype(parry_frame, /datum/parry_frame))
	else
		CRASH("invalid parry frame")

/datum/parry_frame/passive_block
	parry_can_prevent_contact = TRUE
