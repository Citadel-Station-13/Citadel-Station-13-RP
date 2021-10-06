/obj/item/robot_module/drone/Initialize(mapload)
	. = ..()
	modules += new /obj/item/t_scanner(src)
	modules += new /obj/item/analyzer(src)
