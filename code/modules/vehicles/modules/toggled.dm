//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * supertype of simple toggled modules
 */
/obj/item/vehicle_module/toggled
	var/active = FALSE

/obj/item/vehicle_module/toggled/proc/activate(datum/event_args/actor/actor, silent)

/obj/item/vehicle_module/toggled/proc/deactivate(datum/event_args/actor/actor, silent)

/obj/item/vehicle_module/toggled/proc/on_activate(datum/event_args/actor/actor, silent)

/obj/item/vehicle_module/toggled/proc/on_deactivate(datum/event_args/actor/actor, silent)


#warn impl
