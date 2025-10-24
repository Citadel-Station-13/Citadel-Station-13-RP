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

/obj/vehicle/proc/uninstall_module(obj/item/vehicle_module/v_module, datum/event_args/actor/actor, silent, force, atom/new_loc) as /obj/item/vehicle_module

/obj/vehicle/proc/on_module_attached(obj/item/vehicle_module/v_module)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	queue_update_module_refs()

/obj/vehicle/proc/on_module_detached(obj/item/vehicle_module/v_module)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	queue_update_module_refs()

#warn impl
