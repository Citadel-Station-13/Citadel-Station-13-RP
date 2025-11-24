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
	var/obj/item/storage/bag/ore/our_bag = locate() in provisioning.items
	if(!our_bag)
		return
	var/list/obj/item/suppressed = target.module_provisioning.suppress_all_types_of(/obj/item/storage/bag/ore)
	for(var/obj/item/storage/transferring in suppressed)
		for(var/obj/item/stack/ore/ore in transferring.contents)
			ore.forceMove(our_bag)

/obj/item/robot_upgrade/bluespaceorebag/on_uninstall(mob/living/silicon/robot/target)
	. = ..()
	target.module_provisioning.unsuppress_all_types_of(/obj/item/storage/bag/ore)
