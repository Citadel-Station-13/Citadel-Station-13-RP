GENERATE_ROBOT_MODULE_PRESET(/cybersun/sapper)
/datum/prototype/robot_module/cybersun/sapper
	id = "cybersun-sapper"
	display_name = "CS-ENG"
	visible_name = "Sapper"
	use_robot_module_path = /obj/item/robot_module_legacy/robot/
	light_color = "#FF0000"
	auto_iconsets = list(
		/datum/prototype/robot_iconset/grounded_landmate/engineering_cybersun,
		/datum/prototype/robot_iconset/grounded_spider/combat,
		/datum/prototype/robot_iconset/raptor/syndicate_machinist,
	)

/datum/prototype/robot_module/cybersun/sapper/provision_resource_store(datum/robot_resource_store/store)
	..()
	store.provisioned_material_store[/datum/prototype/material/steel::id] = new /datum/robot_resource/provisioned/preset/material/steel
	store.provisioned_material_store[/datum/prototype/material/glass::id] = new /datum/robot_resource/provisioned/preset/material/glass
	store.provisioned_material_store[/datum/prototype/material/plasteel::id] = new /datum/robot_resource/provisioned/preset/material/plasteel
	store.provisioned_material_store[/datum/prototype/material/wood_plank::id] = new /datum/robot_resource/provisioned/preset/material/wood
	store.provisioned_material_store[/datum/prototype/material/plastic::id] = new /datum/robot_resource/provisioned/preset/material/plastic
	store.provisioned_stack_store[/obj/item/stack/cable_coil] = new /datum/robot_resource/provisioned/preset/wire

/datum/prototype/robot_module/cybersun/sapper/create_mounted_item_descriptors(list/normal_out, list/emag_out)
	..()
	if(normal_out)
		// todo: better way to do 'sum types'?
		normal_out |= list(
			/obj/item/stack/rods,
			/obj/item/stack/tile/floor,
			/obj/item/stack/tile/roofing,
			/obj/item/stack/material/glass/reinforced,

			/obj/item/borg/sight/meson,
			/obj/item/weldingtool/electric/mounted/cyborg,
			/obj/item/tool/screwdriver/cyborg,
			/obj/item/tool/wrench/cyborg,
			/obj/item/tool/wirecutters/cyborg,
			/obj/item/multitool/ai_detector,
			/obj/item/pickaxe/plasmacutter,
			/obj/item/rcd/electric/mounted/borg/lesser, // Can't eat rwalls to prevent AI core cheese.
			/obj/item/melee/transforming/energy/sword/ionic_rapier,

			// FBP repair.
			/obj/item/robotanalyzer,
			/obj/item/shockpaddles/robot,
			/obj/item/gripper/no_use/organ/robotics,

			// Hacking other things.
			/obj/item/card/robot/syndi,
			/obj/item/card/emag,
		)
