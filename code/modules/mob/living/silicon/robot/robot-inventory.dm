//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/mob/living/silicon/robot/init_inventory()
	..()
	inventory.set_hand_count(3)

/mob/living/silicon/robot/should_allow_pickup(obj/item/item, datum/event_args/actor/actor, silent)
	return item in robot_inventory?.provided_items
