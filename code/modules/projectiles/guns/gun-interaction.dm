//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/item/gun/on_attack_self(datum/event_args/actor/e_args)
	. = ..()
	if(.)
		return
	if(should_attack_self_switch_firemodes())
		auto_inhand_switch_firemodes(e_args)
		return TRUE

/obj/item/gun/on_unique_action(datum/event_args/actor/e_args)
	. = ..()
	if(.)
		return
	if(should_unique_action_rack_chamber())
		auto_inhand_rack_chamber(e_args)
		return TRUE

/**
 * * This is used to know if the examine message for unique action chamber racking should be displayed.
 *
 * @return TRUE if unique action should be routed to racking chamber
 */
/obj/item/gun/proc/should_unique_action_rack_chamber()
	return FALSE

/**
 * @return TRUE if handled
 */
/obj/item/gun/proc/auto_inhand_rack_chamber(datum/event_args/actor/e_args)
	return FALSE

/**
 * * This is used to know if the examine message for attack self firemode switching should be displayed.
 *
 * @return TRUE if attack self should be routed to switching firemodes
 */
/obj/item/gun/proc/should_attack_self_switch_firemodes()
	return length(firemodes)

/**
 * @return TRUE if handled
 */
/obj/item/gun/proc/auto_inhand_switch_firemodes(datum/event_args/actor/e_args)
	user_switch_firemodes(e_args)
	return TRUE
