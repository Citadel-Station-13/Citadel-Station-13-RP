/obj/item/weapon/robot_module/drone/New(mob/living/silicon/robot/robot)
	..()
	modules += new /obj/item/device/t_scanner(src)
	modules += new /obj/item/device/analyzer(src)
