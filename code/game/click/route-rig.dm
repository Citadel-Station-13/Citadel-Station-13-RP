//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * This should **not** be called by remote control. This is a direct route from click handling.
 * Remote control of hardsuits should route to the hardsuit's clickchain receiver directly.
 * @return clickchain flags
 */
/mob/proc/attempt_rigsuit_click(datum/event_args/actor/clickchain/clickchain, clickchain_flags, obj/item/hardsuit/use_suit)
	if(!use_suit)
		use_suit = get_hardsuit(TRUE)
	if(!use_suit)
		return NONE
	return use_suit.handle_hardsuit_module_click(clickchain, clickchain_flags)
