/obj/item/robot_module/drone/New(mob/living/silicon/robot/robot)
  ..()
  modules += new /obj/item/t_scanner(src)
  modules += new /obj/item/analyzer(src)
