//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/inventory/robot
	held_items_row_mode = 3
	held_items_suppress_buttons = TRUE
	held_items_use_robot_icon = TRUE

// TODO: overriding this is a little bad but what the fuck ever man we'll have another inventory rewrite soon
/datum/inventory/robot/put_in_hand(obj/item/I, index, inv_op_flags)
	if(inv_op_flags & INV_OP_FORCE)
		return ..()
	var/mob/living/silicon/robot/maybe_robot = owner
	if(!istype(maybe_robot))
		return ..()
	if(!(I in maybe_robot.robot_inventory?.provided_items))
		return FALSE
	return ..()
