//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Routed proc from either wearer or remote click.
 * @return clickchain flags
 */
/obj/vehicle/proc/handle_vehicle_click(datum/event_args/actor/clickchain/clickchain, clickchain_flags, obj/item/vehicle_module/using_module)
	// TODO: for now, only mechas can handle this.
	return clickchain_flags
