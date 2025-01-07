/obj/item/robot_upgrade/vtec
	name = "robotic VTEC Module"
	desc = "Used to kick in a robot's VTEC systems, increasing their speed."
	icon_state = "cyborg_upgrade2"
	item_state = "cyborg_upgrade"
	require_module = TRUE

/obj/item/robot_upgrade/vtec/action(var/mob/living/silicon/robot/R)
	if(..())
		return FALSE

	if(R.speed <= -0.5)
		return FALSE

	R.speed = -0.5
	return TRUE
