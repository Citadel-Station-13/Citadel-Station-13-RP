/mob/living/silicon/robot/update_mobility(blocked, forced)
	if(lockdown)
		blocked |= MOBILITY_FLAGS_ANY_INTERACTION | MOBILITY_FLAGS_ANY_MOVEMENT | MOBILITY_CAN_PULL | MOBILITY_CAN_HOLD | MOBILITY_CAN_RESIST
	. = ..()
	updateicon()
