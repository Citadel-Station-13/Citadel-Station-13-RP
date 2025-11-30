//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/vehicle/proc/initialize_modules()
	#warn impl

/**
 * Destroy all modules
 */
/obj/vehicle/proc/destroy_all_modules()
	QDEL_LAZYLIST(modules)

/obj/vehicle/proc/can_install_module(obj/item/vehicle_module/v_module, datum/event_args/actor/actor, silent, force)

/obj/vehicle/proc/can_fit_module(obj/item/vehicle_module/v_module, datum/event_args/actor/actor, silent)

/obj/vehicle/proc/user_install_module(obj/item/vehicle_module/v_module, datum/event_args/actor/actor)

/obj/vehicle/proc/user_uninstall_module(obj/item/vehicle_module/v_module, datum/event_args/actor/actor, put_in_hands)

/obj/vehicle/proc/install_module(obj/item/vehicle_module/v_module, datum/event_args/actor/actor, silent, force)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

/obj/vehicle/proc/uninstall_module(obj/item/vehicle_module/v_module, datum/event_args/actor/actor, silent, force, atom/new_loc) as /obj/item/vehicle_module
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

/obj/vehicle/proc/on_module_attached(obj/item/vehicle_module/v_module)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	cached_module_weight += v_module.get_weight()
	ui_controller?.queue_update_module_refs()
	ui_controller?.queue_update_weight_data()

/obj/vehicle/proc/on_module_detached(obj/item/vehicle_module/v_module)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	cached_module_weight += v_module.get_weight()
	ui_controller?.queue_update_module_refs()
	ui_controller?.queue_update_weight_data()

#warn impl

/**
 * * Allowed to return nulls, including for the list itself
 * * Returned list will never be modified.
 */
/obj/vehicle/proc/query_repair_droid_modules_immutable() as /list
	return modules

/**
 * @return list of modules
 */
/obj/vehicle/proc/query_active_click_modules() as /list
	#warn impl

/**
 * @return TRUE for success, FALSE otherwise
 */
/obj/vehicle/proc/set_active_click_module(obj/item/vehicle_module/module, silent)
	#warn impl

/**
 * @return new module or null or FALSE if none available
 */
/obj/vehicle/proc/cycle_active_click_modules(allow_deselect = TRUE, silent) as /obj/item/vehicle_module
	#warn impl
