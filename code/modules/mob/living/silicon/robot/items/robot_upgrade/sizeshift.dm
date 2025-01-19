/obj/item/robot_upgrade/sizeshift
	name = "robot size alteration module"
	desc = "Using technology similar to one used in size guns, allows cyborgs to adjust their own size as necessary."
	icon_state = "cyborg_upgrade2"
	item_state = "cyborg_upgrade"

/obj/item/robot_upgrade/language/on_install(mob/living/silicon/robot/target)
	. = ..()
	add_verb(target, /mob/living/proc/set_size)

/obj/item/robot_upgrade/language/on_uninstall(mob/living/silicon/robot/target)
	. = ..()
	remove_verb(target, /mob/living/proc/set_size)
