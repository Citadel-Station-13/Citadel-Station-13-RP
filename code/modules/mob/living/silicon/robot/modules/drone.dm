/datum/prototype/robot_module/drone
	id = "drone"
	display_name = "NT Drone"
	module_hud_state = "platform"
	use_robot_module_path = /obj/item/robot_module_legacy/drone
	auto_iconsets = list(
		/datum/prototype/robot_iconset/baseline_drone/construction,
	)

/datum/prototype/robot_module/drone/provision_resource_store(datum/robot_resource_store/store)
	..()
	store.provisioned_material_store[/datum/prototype/material/steel::id] = new /datum/robot_resource/provisioned/preset/material/steel
	store.provisioned_material_store[/datum/prototype/material/glass::id] = new /datum/robot_resource/provisioned/preset/material/glass
	store.provisioned_material_store[/datum/prototype/material/plasteel::id] = new /datum/robot_resource/provisioned/preset/material/plasteel
	store.provisioned_material_store[/datum/prototype/material/wood_plank::id] = new /datum/robot_resource/provisioned/preset/material/wood
	store.provisioned_material_store[/datum/prototype/material/plastic::id] = new /datum/robot_resource/provisioned/preset/material/plastic
	store.provisioned_stack_store[/obj/item/stack/cable_coil] = new /datum/robot_resource/provisioned/preset/wire

/datum/prototype/robot_module/drone/create_mounted_item_descriptors(list/normal_out, list/emag_out)
	..()
	if(normal_out)
		// todo: better way to do 'sum types'?
		normal_out |= list(
			/obj/item/stack/rods,
			/obj/item/stack/tile/wood,
			/obj/item/stack/tile/floor,
			/obj/item/stack/tile/roofing,
			/obj/item/stack/material/glass/reinforced,
			/obj/item/borg/sight/meson,
			/obj/item/weldingtool/electric/mounted/cyborg,
			/obj/item/tool/screwdriver/cyborg,
			/obj/item/tool/wrench/cyborg,
			/obj/item/tool/crowbar/cyborg,
			/obj/item/tool/wirecutters/cyborg,
			/obj/item/multitool,
			/obj/item/lightreplacer,
			/obj/item/gripper,
			/obj/item/mop,
			/obj/item/gripper/no_use/loader,
			/obj/item/extinguisher,
			/obj/item/pipe_painter,
			/obj/item/floor_painter,
			/obj/item/t_scanner,
			/obj/item/atmos_analyzer,
			/obj/item/inflatable_dispenser/robot,
			/obj/item/barrier_tape_roll/engineering,
			/obj/item/pipe_dispenser,
			/obj/item/tank/jetpack/carbondioxide,
		)
	if(emag_out)
		emag_out |= list(
			/obj/item/pickaxe/plasmacutter,
		)

GENERATE_ROBOT_MODULE_PRESET(/drone/construction)
/datum/prototype/robot_module/drone/construction
	id = "drone-construction"
	display_name = "NT Construction Drone"
	auto_iconsets = list(
		/datum/prototype/robot_iconset/baseline_drone/construction,
	)

/datum/prototype/robot_module/drone/construction/create_mounted_item_descriptors(list/normal_out, list/emag_out)
	..()
	if(normal_out)
		normal_out |= list(
			/obj/item/rcd/electric/mounted/borg/lesser,
		)

GENERATE_ROBOT_MODULE_PRESET(/drone/mining)
/datum/prototype/robot_module/drone/mining
	id = "drone-mining"
	display_name = "NT Mining Drone"
	auto_iconsets = list(
		/datum/prototype/robot_iconset/baseline_drone/mining,
	)

/datum/prototype/robot_module/drone/mining/create_mounted_item_descriptors(list/normal_out, list/emag_out)
	..()
	if(normal_out)
		normal_out |= list(
			/obj/item/borg/sight/material,
			/obj/item/pickaxe/borgdrill,
			/obj/item/gun/projectile/energy/kinetic_accelerator/cyborg,
			/obj/item/storage/bag/ore,
			/obj/item/storage/bag/sheetsnatcher/borg,
		)
	if(emag_out)
		emag_out |= list(
			/obj/item/pickaxe/diamonddrill,
		)

// todo: legacy crap
/obj/item/robot_module_legacy/drone
	channels = list("Engineering" = 1, "Supply" = 1)
	networks = list(NETWORK_ENGINEERING, NETWORK_MINE)

/obj/item/robot_module_legacy/drone/construction/matriarch
