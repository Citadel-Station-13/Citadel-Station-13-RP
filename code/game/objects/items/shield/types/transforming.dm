//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * toggleable shields, like energy combat shields and telescoping shields
 */
/obj/item/shield/transforming
	/// are we active?
	var/active = FALSE
	/// when active, do we use an overlay instead of an icon state?
	///
	/// * applies to regular overlay
	/// * applies to worn overlay as well
	var/active_via_overlay = FALSE

	var/active_weight_class = WEIGHT_CLASS_BULKY
	var/inactive_weight_class
	var/active_weight_volume
	var/inactive_weight_volume

	var/active_damage_force
	var/inactive_damage_force

	/// activation sound; also deactivation if it's not specified
	var/activation_sound = 'sound/weapons/empty.ogg'
	var/deactivation_sound
	/// sound volume
	var/toggle_sound_volume = 50

/obj/item/shield/transforming/passive_parry_intercept(mob/defending, attack_type, datum/attack_source, datum/passive_parry/parry_data)
	if(!active)
		return // cancel
	return ..()

/obj/item/shield/transforming/update_icon_state()
	icon_state = "[initial(icon_state)][active && !active_via_overlay ? "-active" : ""]"
	return ..()

/obj/item/shield/transforming/update_overlays()
	. = ..()
	if(!active || !active_via_overlay)
		return
	. += build_active_overlay()

/obj/item/shield/transforming/proc/build_active_overlay()
	RETURN_TYPE(/image)
	var/image/creating = image(icon, "[base_icon_state || icon_state]-active")
	return creating

/obj/item/shield/transforming/proc/build_active_worn_overlay(worn_state)
	RETURN_TYPE(/image)
	var/image/creating = image(icon, "[worn_state]-active")
	return creating

/obj/item/shield/transforming/render_apply_overlays(mutable_appearance/MA, bodytype, inhands, datum/inventory_slot/slot_meta, icon_used)
	. = ..()
	if(active_via_overlay && active)
		MA.overlays += build_active_worn_overlay(MA.icon_state)

/obj/item/shield/transforming/on_attack_self(datum/event_args/actor/e_args)
	. = ..()
	if(.)
		return
	add_fingerprint(e_args.performer)
	toggle(e_args)
	return CLICKCHAIN_DO_NOT_PROPAGATE

/**
 * actor can be /datum/event_args/actor or a single mob.
 */
/obj/item/shield/transforming/proc/toggle(datum/event_args/actor/actor, silent)
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
/obj/item/shield/transforming/proc/on_activate(datum/event_args/actor/actor, silent)
	damage_force = VALUE_OR_DEFAULT(active_damage_force, initial(damage_force))

	set_weight_class(VALUE_OR_DEFAULT(active_weight_class, initial(w_class)))
	set_weight_volume(VALUE_OR_DEFAULT(active_weight_volume, initial(weight_volume)))

	if(!silent && activation_sound)
		playsound(src, activation_sound, toggle_sound_volume, TRUE)

	// todo: logging

/**
 * actor can be /datum/event_args/actor or a single mob.
 */
/obj/item/shield/transforming/proc/on_deactivate(datum/event_args/actor/actor, silent)
	damage_force = VALUE_OR_DEFAULT(inactive_damage_force, initial(damage_force))

	set_weight_class(VALUE_OR_DEFAULT(inactive_weight_class, initial(w_class)))
	set_weight_volume(VALUE_OR_DEFAULT(inactive_weight_volume, initial(weight_volume)))

	if(!silent && (activation_sound || deactivation_sound))
		playsound(src, deactivation_sound || activation_sound, toggle_sound_volume, TRUE)

	// todo: logging
