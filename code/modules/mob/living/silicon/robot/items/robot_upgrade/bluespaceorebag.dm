/obj/item/robot_upgrade/bluespaceorebag
	name = "bluespace mining satchel module"
	desc = "An upgrade to upgrade a robot's ore bag."
	icon_state = "cyborg_upgrade3"
	item_state = "cyborg_upgrade"

/obj/item/robot_upgrade/bluespaceorebag/create_mounted_item_descriptors(list/out_list)
	out_list += /obj/item/storage/bag/ore/bluespace
	return ..()

#warn suppress regular ore bag; should only be applied if they have one!
