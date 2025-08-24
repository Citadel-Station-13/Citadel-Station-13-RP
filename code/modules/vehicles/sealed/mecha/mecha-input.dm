//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Routed proc from either wearer or remote click.
 * @return clickchain flags
 */
/obj/vehicle/sealed/mecha/handle_vehicle_click(datum/event_args/actor/clickchain/clickchain, clickchain_flags, obj/item/vehicle_module/using_module)
	// TODO: eventually we'll want to start re-implementing click_action to be more modular,
	//       but for now we just route over there to the old code
	click_action(clickchain.target, clickchain.performer, clickchain.click_params)
	return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
