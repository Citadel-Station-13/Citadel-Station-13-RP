/obj/item/robot_upgrade/bluespaceorebag
	name = "bluespace mining satchel module"
	desc = "An upgrade to upgrade a robot's ore bag."
	icon_state = "cyborg_upgrade3"
	item_state = "cyborg_upgrade"

/obj/item/robot_upgrade/bluespaceorebag/create_mounted_item_descriptors(list/out_list)
	out_list += /obj/item/storage/bag/ore/bluespace
	return ..()

/obj/item/robot_upgrade/bluespaceorebag/on_install(mob/living/silicon/robot/target)
	. = ..()

/obj/item/robot_upgrade/bluespaceorebag/on_uninstall(mob/living/silicon/robot/target)
	. = ..()

#warn suppress regular ore bag; should only be applied if they have one!
