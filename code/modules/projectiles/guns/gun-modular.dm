//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Modular Components - Compatibility *//

/**
 * hard check
 */
/obj/item/gun/proc/can_install_modular_component(obj/item/gun_component/component, datum/event_args/actor/actor, silent, force)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	var/count_for_slot = 1 // 1 because we're adding one
	if(!modular_component_slots?[component.component_slot])
		if(!silent)
			actor?.chat_feedback(
				SPAN_WARNING("[component] doesn't go on [src]s!"),
				target = src,
			)
		return FALSE
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

/obj/item/gun/proc/user_install_modular_component(obj/item/gun_component/component, datum/event_args/actor/actor)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	if(actor)
		if(actor.performer && actor.performer.is_in_inventory(component))
			if(!actor.performer.can_unequip(component, component.worn_slot))
				actor.chat_feedback(
					SPAN_WARNING("[component] is stuck to your hand!"),
					target = src,
				)
				return FALSE
	if(!install_modular_component(component, actor))
		return FALSE
	// todo: better sound
	playsound(src, 'sound/weapons/empty.ogg', 25, TRUE, -3)
	return TRUE

/obj/item/gun/proc/user_uninstall_modular_component(obj/item/gun_component/component, datum/event_args/actor/actor, put_in_hands)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	if(!component.can_remove)
		actor?.chat_feedback(
			SPAN_WARNING("[component] is not removable."),
			target = src,
		)
		return FALSE
	var/obj/item/uninstalled = uninstall_modular_component(component, actor, new_loc = src)
	if(put_in_hands && actor?.performer)
		actor.performer.put_in_hands_or_drop(uninstalled)
	else
		var/atom/where_to_drop = drop_location()
		ASSERT(where_to_drop)
		uninstalled.forceMove(where_to_drop)
	// todo: better sound
	playsound(src, 'sound/weapons/empty.ogg', 25, TRUE, -3)
	return TRUE

/**
 * * moves the component into us if it wasn't already
 */
/obj/item/gun/proc/install_modular_component(obj/item/gun_component/component, datum/event_args/actor/actor, silent, force)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	if(!can_install_modular_component(component, actor, silent))
		return FALSE

	if(!silent)
		actor?.visible_feedback(
			target = src,
			visible = SPAN_NOTICE("[actor.performer] installs [component] into [src]."),
			range = MESSAGE_RANGE_CONFIGURATION,
		)
	if(component.loc != src)
		component.forceMove(src)

	LAZYADD(modular_components, component)
	component.installed = src
	component.on_install(src, actor, silent)
	// component.update_gun_overlay()
	on_modular_component_install(component, actor, silent)
	// var/mob/holding_mob = get_worn_mob()
	// if(holding_mob)
	// 	component.register_component_actions(holding_mob)
	// todo: logging
	return TRUE

/**
 * * deletes the component if no location is provided to move it to
 *
 * @return uninstalled item
 */
/obj/item/gun/proc/uninstall_modular_component(obj/item/gun_component/component, datum/event_args/actor/actor, silent, force, atom/new_loc) as /obj/item
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	ASSERT(component.installed == src)
	// var/mob/holding_mob = get_worn_mob()
	// if(holding_mob)
	// 	component.unregister_component_actions(holding_mob)
	component.on_uninstall(src, actor, silent)
	// component.remove_gun_overlay()
	component.installed = null
	LAZYREMOVE(modular_components, component)
	on_modular_component_uninstall(component, actor, silent)
	// todo: logging

	if(!silent)
		actor?.visible_feedback(
			target = src,
			visible = SPAN_NOTICE("[actor.performer] pulls [component] out of [src]."),
			range = MESSAGE_RANGE_CONFIGURATION,
		)

	if(new_loc)
		component.forceMove(new_loc)
		. = component
	else
		qdel(component)
		. = null

//* Modular Components - Hooks *//

/obj/item/gun/proc/on_modular_component_install(obj/item/gun_component/component, datum/event_args/actor/actor, silent)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)

/obj/item/gun/proc/on_modular_component_uninstall(obj/item/gun_component/component, datum/event_args/actor/actor, silent)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)

//* Modular Components - API *//

/**
 * Try to use a certain amount of power.
 *
 * @params
 * * component - the component drawing power
 * * amount - how much power to use, in cell units
 *
 * @return amount used
 */
/obj/item/gun/proc/modular_use_power(obj/item/gun_component/component, amount)
	return obj_cell_slot?.use(amount)

/**
 * Try to use a certain amount of power. Fails if insufficient.
 *
 * @params
 * * component - the component drawing power
 * * amount - how much power to use, in cell units
 * * reserve - how many joules must be remaining after use, in joules
 *
 * @return amount used
 */
/obj/item/gun/proc/modular_use_checked_power(obj/item/gun_component/component, amount, reserve)
	return obj_cell_slot?.checked_use(amount, reserve)
