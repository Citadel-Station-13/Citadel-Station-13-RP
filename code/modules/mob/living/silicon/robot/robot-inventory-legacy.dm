/mob/living/silicon/robot/is_in_inventory(obj/item/I)
	return ..() || is_in_inventory_robot(I)

/mob/living/silicon/robot/is_in_inventory_robot(obj/item/I)
	return istype(I.loc, /obj/item/gripper) && I.loc.loc == src
