//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * This should **not** be called by remote control. This is a direct route from click handling.
 * Remote control of vehicle should route to the vehicle's clickchain receiver directly.
 * @return clickchain flags
 */
/mob/proc/attempt_mecha_click(datum/event_args/actor/clickchain/clickchain, clickchain_flags, obj/vehicle/use_vehicle)
	if(!use_vehicle)
		return NONE
	return use_vehicle.handle_vehicle_click(clickchain, clickchain_flags)
