//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Routed proc from either wearer or remote click.
 * @return clickchain flags
 */
/obj/vehicle/proc/handle_vehicle_click(datum/event_args/actor/clickchain/clickchain, clickchain_flags, obj/item/vehicle_module/using_module)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(isnull(using_module))
		using_module = module_active_click
	. = clickchain_flags
	if((. = on_vehicle_click(clickchain, clickchain_flags, using_module)) & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return
	if(using_module && ((. = using_module.on_vehicle_click(clickchain, clickchain_flags)) & CLICKCHAIN_FLAGS_INTERACT_ABORT))
		return

/obj/vehicle/proc/on_vehicle_click(datum/event_args/actor/clickchain/clickchain, clickchain_flags, obj/item/vehicle_module/using_module)
	return clickchain_flags
