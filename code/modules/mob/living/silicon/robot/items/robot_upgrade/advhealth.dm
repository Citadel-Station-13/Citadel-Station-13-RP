/obj/item/robot_upgrade/advhealth
	name = "advanced health analyzer module"
	desc = "An upgrade to add an advanced health analyzer to a robot."
	icon_state = "cyborg_upgrade3"
	item_state = "cyborg_upgrade"

/obj/item/robot_upgrade/advhealth/create_mounted_item_descriptors(list/out_list)
	out_list += /obj/item/healthanalyzer/advanced
	return ..()
