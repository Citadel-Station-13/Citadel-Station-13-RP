//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/item/gun/projectile/ballistic/microbattery/should_attack_self_switch_firemodes()
	return TRUE

/obj/item/gun/projectile/ballistic/microbattery/auto_inhand_switch_firemodes(datum/event_args/actor/e_args)
	if(length(firemodes) > 1)
		return ..()
	return user_switch_microbattery_group(e_args)

/**
 * @return TRUE if handled
 */
/obj/item/gun/projectile/ballistic/microbattery/proc/user_switch_microbattery_group(datum/event_args/actor/e_args)
	if(!cycle_microbattery_group())
		e_args?.chat_feedback(
			SPAN_WARNING("[src] isn't using a magazine that supports cycling ammunition on the fly."),
			target = src,
		)
		return TRUE
	var/new_mode_name
	var/obj/item/ammo_casing/microbattery/maybe_microbattery_casing = get_chambered()
	if(!maybe_microbattery_casing)
		new_mode_name = "nothing"
	else if(!istype(maybe_microbattery_casing))
		new_mode_name = "unknown"
	else
		new_mode_name = maybe_microbattery_casing.microbattery_mode_name
	e_args?.chat_feedback(
		SPAN_NOTICE("[src] is now set to </b>'[new_mode_name]'</b>."),
		target = src,
	)
	playsound(src, selector_sound, 50, TRUE)
	return TRUE
