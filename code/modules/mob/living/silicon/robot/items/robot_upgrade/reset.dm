/obj/item/robot_upgrade/reset
	name = "robotic module reset board"
	desc = "Used to reset a cyborg's module. Destroys any other upgrades applied to the robot."
	icon_state = "cyborg_upgrade1"
	item_state = "cyborg_upgrade"

/obj/item/robot_upgrade/reset/being_installed(mob/living/silicon/robot/target)
	target.module_reset()
	qdel(src)
