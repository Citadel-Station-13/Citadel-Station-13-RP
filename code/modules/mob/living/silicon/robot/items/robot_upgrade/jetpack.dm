// todo: ion thruster upgrade instead wtf
/obj/item/robot_upgrade/jetpack
	name = "robot jetpack"
	desc = "A carbon dioxide jetpack suitable for low-gravity operations."
	icon_state = "cyborg_upgrade3"
	item_state = "cyborg_upgrade"

/obj/item/robot_upgrade/bluespaceorebag/create_mounted_item_descriptors(list/out_list)
	out_list += /obj/item/tank/jetpack/carbondioxide
	return ..()
