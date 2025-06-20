//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * a layer of protective rust
 *
 * * good against ablation / spread damage
 * * bad against precision damage (will damp but be quickly drained and not prevent all damage)
 * * imperfect shielding either way
 */
/datum/component/eldritch_rust_shielding
	/// amount left
	var/amount = 0
	/// bound shieldcall
	var/datum/shieldcall/bound/eldritch_rust_shielding_component/bound_shieldcall
	/// natural falloff per second
	var/falloff_flat = 0.33
	/// natural falloff per second, as ratio to keep
	var/falloff_mult = 0.9975

	/// last time falloff ticked
	var/falloff_last
	/// last refresh by add_rust; if it's been too long, we qdel self when we're empty.
	var/falloff_last_refresh
	/// is timer registered for falling off of something? if so, this is the id
	var/falloff_timer_id

/datum/component/eldritch_rust_shielding/Initialize(amount)
	. = ..()
	if(. == COMPONENT_INCOMPATIBLE)
		return
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE
	bound_shieldcall = new(src)
	src.amount = amount
	falloff_last = world.time
	recreate_falloff_timer()

/datum/component/eldritch_rust_shielding/Destroy()
	QDEL_NULL(bound_shieldcall)
	return ..()

/datum/component/eldritch_rust_shielding/RegisterWithParent()
	..()
	var/atom/parent_atom = parent
	parent_atom.register_shieldcall(bound_shieldcall)

/datum/component/eldritch_rust_shielding/UnregisterFromParent()
	..()
	var/atom/parent_atom = parent
	parent_atom.unregister_shieldcall(bound_shieldcall)

/**
 * @return amount given
 */
/datum/component/eldritch_rust_shielding/proc/add_rust(amount)
	. = amount
	src.amount += amount
	falloff_last_refresh = world.time

/**
 * @return amount removed
 */
/datum/component/eldritch_rust_shielding/proc/remove_rust(amount)
	. = min(amount, src.amount)
	src.amount -= .

/datum/component/eldritch_rust_shielding/proc/recreate_falloff_timer()
	if(falloff_timer_active)
		deltimer(falloff_timer_id)
		falloff_timer_id = null
	falloff_timer_id = addtimer(CALLBACK(src, PROC_REF(falloff_exec)), 20 SECONDS)

/datum/component/eldritch_rust_shielding/proc/falloff_exec()
	var/dt = (world.time - falloff_last) * 0.1
	amount = max(0, amount * falloff_mult ** dt - falloff_flat * dt)
	falloff_last = world.time

	if(!amount && world.time - falloff_last_refresh > 10 SECONDS)
		qdel(src)

/datum/shieldcall/bound/eldritch_rust_shielding_component
	expected_type = /datum/component/eldritch_rust_shielding
	low_level_intercept = TRUE

/datum/shieldcall/bound/eldritch_rust_shielding_component/handle_shieldcall(atom/defending, list/shieldcall_args, fake_attack)
	if(shieldcall_args[SHIELDCALL_ARG_FLAGS] & SHIELDCALL_FLAG_SECOND_CALL)
		return
	. = ..()


/datum/shieldcall/bound/eldritch_rust_shielding_component/handle_bullet(atom/defending, shieldcall_returns, fake_attack, list/bullet_act_args)


/datum/shieldcall/bound/eldritch_rust_shielding_component/handle_melee(atom/defending, shieldcall_returns, fake_attack, datum/event_args/actor/clickchain/clickchain, clickchain_flags, obj/item/weapon, datum/melee_attack/weapon/style)

/datum/shieldcall/bound/eldritch_rust_shielding_component/handle_touch(atom/defending, shieldcall_returns, fake_attack, datum/event_args/actor/clickchain/clickchain, clickchain_flags, contact_flags, contact_specific)

/datum/shieldcall/bound/eldritch_rust_shielding_component/handle_throw_impact(atom/defending, shieldcall_returns, fake_attack, datum/thrownthing/thrown)


#warn impl all; falloff_exec before running.
