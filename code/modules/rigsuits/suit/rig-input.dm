//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Handles a click.
 * * This is only for module usage, as its name implies. This is very important; when rig remote control
 *   is added, you are controlling a human, and clicking normally to interact with say, your hands,
 *   is not routed here.
 * @params
 * * clickchain
 * * clickchain_flags
 * * route_to_module - if set, route to a specific module. otherwise, route to active.
 *
 * @return clickchain flags
 */
/obj/item/rig/proc/handle_rig_module_click(datum/event_args/actor/clickchain/clickchain, clickchain_flags, obj/item/rig_module/route_to_module)
	if(!route_to_module)
		route_to_module = get_active_rig_module_click()
	if(!route_to_module)
		return clickchain_flags
#warn impl

/obj/item/rig/proc/set_active_rig_module_click(obj/item/rig_module/module)

/obj/item/rig/proc/get_active_rig_module_click()
	return rig_module_click_active
