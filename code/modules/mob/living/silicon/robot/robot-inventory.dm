//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/mob/living/silicon/robot/should_allow_pickup(obj/item/item, datum/event_args/actor/actor, silent)
	return item in robot_inventory?.provided_items

/mob/living/silicon/robot/is_in_inventory(obj/item/item)
	return ..() || is_in_inventory_robot(item)

/mob/living/silicon/robot/proc/is_in_inventory_robot(obj/item/item)
	// Bespoke check that an item is in gripper, as grippers don't count as an inventory slot.
	return istype(item.loc, /obj/item/gripper) && item.loc.loc == src
