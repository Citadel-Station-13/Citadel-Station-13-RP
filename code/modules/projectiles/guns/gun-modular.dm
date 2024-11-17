//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Modular Components - Compatibility *//

/**
 * hard check
 */
/obj/item/gun/proc/can_install_component(obj/item/gun_component/component, datum/event_args/actor/actor, silent, force)
	SHOULD_NOT_OVERRIDE(TRUE)
	var/count_for_slot = 1 // 1 because we're adding one
	for(var/obj/item/gun_component/existing in modular_components)
		if(existing.component_slot == component.component_slot)
			count_for_slot++
		if(existing.component_conflict & component.component_conflict)
			if(!silent)
				actor?.chat_feedback(
					SPAN_WARNING("[existing] conflicts with [component] due to being too similar!"),
					target = src,
				)
			return FALSE
		if((existing.component_type || existing.type) == (component.component_type || component.type))
			if(!silent)
				actor?.chat_feedback(
					SPAN_WARNING("[existing] conflicts with [component] due to being too similar!"),
					target = src,
				)
			return FALSE
	var/is_full = (count_for_slot >= modular_component_slots?[component.component_slot])
	return force || component.fits_on_gun(src, fits_modular_component(component), is_full, actor, silent)

/**
 * checks if we can attach a component; component gets final say
 */
/obj/item/gun/proc/fits_modular_component(obj/item/gun_component/component, datum/event_args/actor/actor, silent)
	return TRUE

//* Modular Components - Add / Remove *//

/**
 * * moves the component into us if it wasn't already
 */
/obj/item/gun/proc/attach_modular_component(obj/item/gun_component/component, datum/event_args/actor/actor, silent, force)
	#warn impl

/**
 * * deletes the component if no location is provided to move it to
 */
/obj/item/gun/proc/detach_modular_component(obj/item/gun_component/component, datum/event_args/actor/actor, silent, force, atom/new_loc)
	#warn impl

#warn hook everything in attackby's

//* Modular Components - API *//

/**
 * Try to use a certain amount of power.
 *
 * @return amount used
 */
/obj/item/gun/proc/modular_use_power(obj/item/gun_component/component, joules)
	return obj_cell_slot?.use(DYNAMIC_J_TO_CELL_UNITS(joules))

/**
 * Try to use a certain amount of power. Fails if insufficient.
 *
 * @params
 * * component - the component drawing power
 * * joules - how much power to use, in joules
 * * reserve - how many joules must be remaining after use, in joules
 *
 * @return amount used
 */
/obj/item/gun/proc/modular_use_checked_power(obj/item/gun_component/component, joules, reserve)
	return obj_cell_slot?.checked_use(DYNAMIC_J_TO_CELL_UNITS(joules), reserve)
