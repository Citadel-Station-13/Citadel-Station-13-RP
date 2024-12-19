/datum/prototype/robot_module/drone
	use_robot_module_path = /obj/item/robot_module/robot/
	allowed_frames = list(
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
		)

#warn translate chassis below

/obj/item/robot_module/drone
	name = "drone module"
	networks = list(NETWORK_ENGINEERING)

/obj/item/robot_module/drone/get_modules()
	. = ..()
	. |= list(
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
		/obj/item/pipe_dispenser
	)

/obj/item/robot_module/drone/handle_special_module_init(mob/living/silicon/robot/R)
	. = ..()

	R.internals = new/obj/item/tank/jetpack/carbondioxide(src)
	. += R.internals

	src.emag = new /obj/item/pickaxe/plasmacutter(src)
	src.emag.name = "Plasma Cutter"

/obj/item/robot_module/drone/construction
	name = "construction drone module"
	channels = list("Engineering" = 1)
	languages = list()

/obj/item/robot_module/drone/construction/get_modules()
	. = ..()
	. |= /obj/item/rcd/electric/mounted/borg/lesser

/obj/item/robot_module/drone/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	var/obj/item/lightreplacer/LR = locate() in src.modules
	LR.Charge(R, amount)
	..()

/obj/item/robot_module/drone/mining
	name = "miner drone module"
	channels = list("Supply" = 1)
	networks = list(NETWORK_MINE)

/obj/item/robot_module/drone/mining/get_modules()
	. = ..()
	. |= list(
		/obj/item/borg/sight/material,
		/obj/item/pickaxe/borgdrill,
		/obj/item/gun/energy/kinetic_accelerator/cyborg,
		/obj/item/storage/bag/ore,
		/obj/item/storage/bag/sheetsnatcher/borg
	)

/obj/item/robot_module/drone/mining/handle_special_module_init(mob/living/silicon/robot/R)
	. = ..()
	src.emag = new /obj/item/pickaxe/diamonddrill(src)

/obj/item/robot_module/drone/construction/matriarch
	name = "matriarch drone module"
