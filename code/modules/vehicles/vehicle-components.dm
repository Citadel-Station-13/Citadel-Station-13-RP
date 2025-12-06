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
				"",
				target = src,
			)
		return FALSE
	// is the slot free?
	else if(!has_free_hardcoded_slot_for_component(v_comp))
		if(!silent)
			actor?.chat_feedback(
				"",
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
	#warn impl

/obj/vehicle/proc/user_uninstall_component(obj/item/vehicle_component/v_comp, datum/event_args/actor/actor, put_in_hands)
	#warn impl

/obj/vehicle/proc/install_component(obj/item/vehicle_component/v_comp, datum/event_args/actor/actor, silent, force)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	#warn impl
	LAZYADD(components, v_comp)
	v_comp.vehicle = src
	v_comp.on_install(src, actor, silent)
	on_component_attached(v_comp, actor, silent)

/obj/vehicle/proc/uninstall_component(obj/item/vehicle_component/v_comp, datum/event_args/actor/actor, silent, force, atom/new_loc) as /obj/item/vehicle_component
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	#warn impl
	LAZYREMOVE(components, v_comp)
	v_comp.vehicle = null
	v_comp.on_uninstall(src, actor, silent)
	on_component_detached(v_comp, actor, silent)

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
