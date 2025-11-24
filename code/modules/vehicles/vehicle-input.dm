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
	if(using_module)
		if(using_module.click_restrain_half_angle < 180)
			var/click_angle = clickchain.resolve_click_angle()
			var/our_angle = dir2angle(dir)
			var/angle_diff = closer_angle_difference_approximate(our_angle, click_angle)
			if(angle_diff > using_module.click_restrain_half_angle)
				return
		if((. = using_module.on_vehicle_click(clickchain, clickchain_flags)) & CLICKCHAIN_FLAGS_INTERACT_ABORT)
			return

/obj/vehicle/proc/on_vehicle_click(datum/event_args/actor/clickchain/clickchain, clickchain_flags, obj/item/vehicle_module/using_module)
	return clickchain_flags

/**
 * Called to hook in target scrambling from the vehicle, like from inherent inaccuracy / damage.
 */
/obj/vehicle/proc/request_click_target_scrmabling(atom/target, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	return target

/**
 * Called to hook in target scrambling from the vehicle, like from inherent inaccuracy / damage.
 */
/obj/vehicle/proc/request_click_angle_scrmabling(angle, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	return angle
