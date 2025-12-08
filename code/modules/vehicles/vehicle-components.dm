//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Creates initial components. This should be idempotent in effect; it should
 * replace things already there if needed.
 */
/obj/vehicle/proc/create_initial_components()
	return

/obj/vehicle/proc/recreate_all_components_to_initial()
	destroy_all_components()
	create_initial_components()

/**
 * Destroy all components
 */
/obj/vehicle/proc/destroy_all_components()
	QDEL_LAZYLIST(components)

/**
 * @return list or string
 */
/obj/vehicle/proc/examine_render_components(datum/event_args/examine/examine)
	return list()

/obj/vehicle/proc/can_install_component(obj/item/vehicle_component/v_comp, datum/event_args/actor/actor, silent, force)
	// do we supoprt the component?
	if(!exists_hardcoded_slot_for_component(v_comp))
		if(!silent)
			actor?.chat_feedback(
				SPAN_WARNING("[v_comp] isn't for [src]!"),
				target = src,
			)
		return FALSE
	// is the slot free?
	else if(!has_free_hardcoded_slot_for_component(v_comp))
		if(!silent)
			actor?.chat_feedback(
				SPAN_WARNING("[src] already has a component of [v_comp]'s type!"),
				target = src,
			)
		return FALSE
	. = can_fit_component(v_comp, actor, silent)
	return force || v_comp.fits_on_vehicle(src, ., actor, silent)

/obj/vehicle/proc/can_fit_component(obj/item/vehicle_component/v_comp, datum/event_args/actor/actor, silent)
	return TRUE

/obj/vehicle/proc/exists_hardcoded_slot_for_component(obj/item/vehicle_component/v_comp)
	return FALSE

/obj/vehicle/proc/has_free_hardcoded_slot_for_component(obj/item/vehicle_component/v_comp)
	return FALSE

/obj/vehicle/proc/place_hardcoded_slot_for_component(obj/item/vehicle_component/v_comp)
	return FALSE

/obj/vehicle/proc/unplace_hardcoded_slot_for_component(obj/item/vehicle_component/v_comp) as /obj/item/vehicle_component
	return null

/obj/vehicle/proc/user_install_component(obj/item/vehicle_component/v_comp, datum/event_args/actor/actor)
	if(actor)
		if(actor.performer && actor.performer.is_in_inventory(v_comp))
			if(!actor.performer.can_unequip(v_comp, v_comp.worn_slot))
				actor.chat_feedback(
					SPAN_WARNING("[v_comp] is stuck to your hand!"),
					target = src,
				)
				return FALSE
	if(!install_component(v_comp, actor))
		return FALSE
	// todo: better sound
	playsound(src, 'sound/weapons/empty.ogg', 25, TRUE, -3)
	return TRUE

/obj/vehicle/proc/user_uninstall_component(obj/item/vehicle_component/v_comp, datum/event_args/actor/actor, put_in_hands)
	if(v_comp.intrinsic)
		actor?.chat_feedback(
			SPAN_WARNING("[v_comp] is not removable."),
			target = src,
		)
		return FALSE
	var/obj/item/uninstalled = uninstall_component(v_comp, actor, new_loc = src)
	if(!uninstalled)
		actor?.chat_feedback(
			SPAN_WARNING("You reach in to remove the component, but don't manage to remove anything."),
			target = src,
		)
		return TRUE
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
 * * Moves the component into us if it wasn't already.
 */
/obj/vehicle/proc/install_component(obj/item/vehicle_component/v_comp, datum/event_args/actor/actor, silent, force)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	ASSERT(!v_comp.vehicle)

	if(!can_install_component(v_comp, actor, silent, force))
		return FALSE

	// if we can't set slot obliterate it (this should never happen)
	if(!place_hardcoded_slot_for_component(v_comp))
		stack_trace("couldn't place hardcoded slot for component [v_comp]; did can_install_component incorrectly return?")
		return FALSE

	vehicle_log_for_admins(actor, "component-install", list(
		"component" = "[v_comp]",
		"component-type" = v_comp.type,
	))

	if(!silent)
		if(actor?.performer && !(actor.performer.loc == src) && actor.performer.Reachability(src))
			actor?.visible_feedback(
				target = src,
				visible = SPAN_NOTICE("[actor.performer] installs [v_comp] onto [src]."),
				range = MESSAGE_RANGE_CONSTRUCTION,
			)
		else
			visible_message(
				SPAN_NOTICE("[v_comp] is hoisted and installed onto [src]."),
				range = MESSAGE_RANGE_CONSTRUCTION,
			)
	if(v_comp.loc != src)
		v_comp.forceMove(src)

	LAZYADD(components, v_comp)
	v_comp.vehicle = src
	v_comp.on_install(src, actor, silent)
	on_component_attached(v_comp, actor, silent)

/obj/vehicle/proc/uninstall_component(obj/item/vehicle_component/v_comp, datum/event_args/actor/actor, silent, force, atom/new_loc) as /obj/item/vehicle_component
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	ASSERT(v_comp.vehicle == src)

	var/obj/item/vehicle_component/unplaced = unplace_hardcoded_slot_for_component(v_comp)
	if(unplaced != v_comp)
		stack_trace("unplaced component from hardcoded slot differed from uninstalling component; did someone make hardcoded slot determination non-deterministic?")

	vehicle_log_for_admins(actor, "component-remove", list(
		"component" = "[v_comp]",
		"component-type" = v_comp.type,
	))

	LAZYREMOVE(components, v_comp)
	v_comp.vehicle = null
	v_comp.on_uninstall(src, actor, silent)
	on_component_detached(v_comp, actor, silent)

	if(!silent)
		if(actor?.performer && !(actor.performer.loc == src) && actor.performer.Reachability(src))
			actor?.visible_feedback(
				target = src,
				visible = SPAN_NOTICE("[actor.performer] pulls [v_comp] off of [src]."),
				range = MESSAGE_RANGE_CONSTRUCTION,
			)
		else
			visible_message(
				SPAN_NOTICE("[v_comp] drops out of [src] with a clunk."),
				range = MESSAGE_RANGE_CONSTRUCTION,
			)

	if(new_loc)
		v_comp.forceMove(new_loc)
		. = v_comp
	else
		qdel(v_comp)
		. = null

/obj/vehicle/proc/on_component_attached(obj/item/vehicle_component/v_comp, datum/event_args/actor/actor, silent)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	cached_component_weight += v_comp.get_weight()
	ui_controller?.queue_update_component_refs()
	ui_controller?.queue_update_weight_data()

/obj/vehicle/proc/on_component_detached(obj/item/vehicle_component/v_comp, datum/event_args/actor/actor, silent)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	cached_component_weight -= v_comp.get_weight()
	ui_controller?.queue_update_component_refs()
	ui_controller?.queue_update_weight_data()

/**
 * * Allowed to return nulls, including for the list itself
 * * Returned list shall never be modified, lest dragons eat your soul.
 */
/obj/vehicle/proc/query_repair_droid_components_immutable() as /list
	return components
