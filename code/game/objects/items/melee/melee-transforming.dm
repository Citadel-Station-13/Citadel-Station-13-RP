//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * toggleable shields, like energy combat shields and telescoping shields
 */
/obj/item/melee/transforming
	damage_mode = NONE

	var/active = FALSE

	var/active_weight_class
	var/inactive_weight_class
	var/active_weight_volume
	var/inactive_weight_volume

	var/active_damage_force
	var/inactive_damage_force
	var/active_damage_mode
	var/inactive_damage_mode
	var/active_damage_tier
	var/inactive_damage_tier

	var/active_throw_force
	var/inactive_throw_force
	var/active_throw_resist
	var/inactive_throw_resist
	var/active_throw_range
	var/inactive_throw_range
	var/active_throw_speed
	var/inactive_throw_speed

	/// activation sound; also deactivation if it's not specified
	var/activation_sound = 'sound/weapons/empty.ogg'
	var/deactivation_sound
	/// sound volume
	var/toggle_sound_volume = 50

	/// do not allow passive parry while off
	var/no_block_while_off = TRUE

/obj/item/melee/transforming/passive_parry_intercept(mob/defending, list/shieldcall_args, datum/passive_parry/parry_data)
	if(!active && no_block_while_off)
		return // cancel
	return ..()

/obj/item/melee/transforming/update_icon_state()
	icon_state = "[initial(icon_state)][active ? "_active" : ""]"
	return ..()

/obj/item/melee/transforming/on_attack_self(datum/event_args/actor/e_args)
	. = ..()
	if(.)
		return
	add_fingerprint(e_args.performer)

/**
 * actor can be /datum/event_args/actor or a single mob.
 */
/obj/item/melee/transforming/proc/toggle(datum/event_args/actor/actor, silent)
	active = !active
	if(active)
		on_activate(actor, silent)
	else
		on_deactivate(actor, silent)
	update_icon()
	update_worn_icon()

/**
 * actor can be /datum/event_args/actor or a single mob.
 */
/obj/item/melee/transforming/proc/on_activate(datum/event_args/actor/actor, silent)
	E_ARGS_WRAP_USER_TO_ACTOR(actor)

	damage_force = VALUE_OR_DEFAULT(active_damage_force, initial(damage_force))
	damage_tier = VALUE_OR_DEFAULT(active_damage_tier, initial(damage_tier))
	damage_mode = VALUE_OR_DEFAULT(active_damage_mode, initial(damage_mode))

	throw_force = VALUE_OR_DEFAULT(active_throw_force, initial(throw_force))
	throw_resist = VALUE_OR_DEFAULT(active_throw_resist, initial(throw_resist))
	throw_range = VALUE_OR_DEFAULT(active_throw_range, initial(throw_range))
	throw_speed = VALUE_OR_DEFAULT(active_throw_speed, initial(throw_speed))

	set_weight_class(VALUE_OR_DEFAULT(active_weight_class, initial(w_class)))
	set_weight_volume(VALUE_OR_DEFAULT(active_weight_volume, initial(weight_volume)))

	if(!silent && activation_sound)
		playsound(src, activation_sound, toggle_sound_volume, TRUE)

/**
 * actor can be /datum/event_args/actor or a single mob.
 */
/obj/item/melee/transforming/proc/on_deactivate(datum/event_args/actor/actor, silent)
	E_ARGS_WRAP_USER_TO_ACTOR(actor)

	damage_force = VALUE_OR_DEFAULT(inactive_damage_force, initial(damage_force))
	damage_tier = VALUE_OR_DEFAULT(inactive_damage_tier, initial(damage_tier))
	damage_mode = VALUE_OR_DEFAULT(inactive_damage_mode, initial(damage_mode))

	throw_force = VALUE_OR_DEFAULT(inactive_throw_force, initial(throw_force))
	throw_resist = VALUE_OR_DEFAULT(inactive_throw_resist, initial(throw_resist))
	throw_range = VALUE_OR_DEFAULT(inactive_throw_range, initial(throw_range))
	throw_speed = VALUE_OR_DEFAULT(inactive_throw_speed, initial(throw_speed))

	set_weight_class(VALUE_OR_DEFAULT(inactive_weight_class, initial(w_class)))
	set_weight_volume(VALUE_OR_DEFAULT(inactive_weight_volume, initial(weight_volume)))

	if(!silent && (activation_sound || deactivation_sound))
		playsound(src, deactivation_sound || activation_sound, toggle_sound_volume, TRUE)
