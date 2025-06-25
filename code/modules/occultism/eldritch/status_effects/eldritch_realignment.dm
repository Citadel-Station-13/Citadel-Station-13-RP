//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/status_effect/eldritch_realignment
	identifier = "eldritch-realignment"

	alert_name = "Realignment"
	alert_desc = "Your body is being forced to alignment with your mind by an otherworldly force."
	#warn alert_icon, alert_icon_state

	var/datum/shieldcall/bound/eldritch_realignment_status_effect/shieldcall

	var/damage_instance_pain_mitigation = 0.5
	var/electrocute_stun_mitigation = 0.2
	var/electrocute_damage_mitigation = 0.9

/datum/status_effect/eldritch_realignment/New(mob/owner, duration, list/arguments)
	shieldcall = new(src)
	return ..()

/datum/status_effect/eldritch_realignment/Destroy()
	QDEL_NULL(shieldcall)
	return ..()

/datum/status_effect/eldritch_realignment/on_apply(...)
	..()
	owner.register_shieldcall(shieldcall)

/datum/status_effect/eldritch_realignment/on_remove()
	..()
	owner.unregister_shieldcall(shieldcall)

/datum/status_effect/eldritch_realignment/tick(dt)

#warn impl

/datum/shieldcall/bound/eldritch_realignment_status_effect
	low_level_intercept = TRUE

/datum/shieldcall/bound/eldritch_realignment_status_effect/handle_electrocute(atom/defending, shieldcall_returns, fake_attack, list/electrocute_act_args)

	return NONE

/datum/shieldcall/bound/eldritch_realignment_status_effect/handle_shieldcall(atom/defending, list/shieldcall_args, fake_attack)

	return NONE

