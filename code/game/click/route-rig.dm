//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * This should **not** be called by remote control. This is a direct route from click handling.
 * Remote control of hardsuits should route to the hardsuit's clickchain receiver directly.
 * @return clickchain flags
 */
/mob/proc/attempt_rigsuit_click(datum/event_args/actor/clickchain/clickchain, clickchain_flags, obj/item/rig/use_suit)
	if(!use_suit)
		use_suit = legacy_get_rigsuit(TRUE)
	if(!use_suit)
		return NONE
	return use_suit.handle_rig_module_click(clickchain, clickchain_flags)

/mob/proc/legacy_get_rigsuit()
	// sigh
	var/static/list/maybe_rig_slots = list(
		/datum/inventory_slot/inventory/back::id,
		/datum/inventory_slot/inventory/belt::id,
		/datum/inventory_slot/inventory/suit::id,
		/datum/inventory_slot/inventory/uniform::id,
	)
	for(var/obj/item/rig/maybe_rig in inventory.get_slots_unsafe(maybe_rig_slots, FALSE))
		return maybe_rig
