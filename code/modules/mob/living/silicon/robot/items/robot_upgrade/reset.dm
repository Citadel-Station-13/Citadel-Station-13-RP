/obj/item/robot_upgrade/reset
	name = "robotic module reset board"
	desc = "Used to reset a cyborg's module. Destroys any other upgrades applied to the robot."
	icon_state = "cyborg_upgrade1"
	item_state = "cyborg_upgrade"
	require_module = TRUE

/obj/item/robot_upgrade/reset/action(var/mob/living/silicon/robot/R)
	if(..())
		return FALSE
	R.module_reset()
	return TRUE
