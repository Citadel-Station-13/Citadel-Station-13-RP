//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/component/eldritch_rust_shielding
	/// amount left
	var/amount = 0
	/// bound shieldcall
	var/datum/shieldcall/bound/eldritch_rust_shielding_component/bound_shieldcall

#warn impl

/datum/component/eldritch_rust_shielding/Initialize()
	. = ..()
	if(. == COMPONENT_INCOMPATIBLE)
		return
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE
	bound_shieldcall = new(src)

/datum/component/eldritch_rust_shielding/RegisterWithParent()
	. = ..()

/datum/component/eldritch_rust_shielding/UnregisterFromParent()
	. = ..()



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
