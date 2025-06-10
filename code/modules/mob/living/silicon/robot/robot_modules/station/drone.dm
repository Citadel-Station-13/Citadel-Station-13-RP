/* Drones */

/obj/item/robot_module/drone
	name = "drone module"
	hide_on_manifest = 1
	no_slip = 1
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

/obj/item/robot_module/drone/get_synths(mob/living/silicon/robot/R)
	. = ..()
	MATTER_SYNTH(MATSYN_METAL, metal, 25000)
	MATTER_SYNTH(MATSYN_GLASS, glass, 25000)
	MATTER_SYNTH(MATSYN_WOOD, wood, 25000)
	MATTER_SYNTH(MATSYN_PLASTIC, plastic, 25000)
	MATTER_SYNTH(MATSYN_WIRE, wire, 30)

/obj/item/robot_module/drone/handle_special_module_init(mob/living/silicon/robot/R)
	. = ..()

	R.internals = new/obj/item/tank/jetpack/carbondioxide(src)
	. += R.internals

	src.emag = new /obj/item/pickaxe/plasmacutter(src)
	src.emag.name = "Plasma Cutter"

	var/obj/item/matter_decompiler/MD = new /obj/item/matter_decompiler(src)
	MD.metal = synths_by_kind[MATSYN_METAL]
	MD.glass = synths_by_kind[MATSYN_GLASS]
	MD.wood = synths_by_kind[MATSYN_WOOD]
	MD.plastic = synths_by_kind[MATSYN_PLASTIC]
	. += MD

	CYBORG_STACK(material/cyborg/steel, MATSYN_METAL)
	CYBORG_STACK(material/cyborg/glass, MATSYN_GLASS)
	CYBORG_STACK(rods/cyborg          , MATSYN_METAL)
	CYBORG_STACK(cable_coil/cyborg    , MATSYN_WIRE)
	CYBORG_STACK(tile/floor/cyborg    , MATSYN_METAL)
	CYBORG_STACK(material/cyborg/glass/reinforced, list(MATSYN_METAL, MATSYN_GLASS))
	CYBORG_STACK(tile/wood/cyborg     , MATSYN_WOOD)
	CYBORG_STACK(material/cyborg/wood , MATSYN_WOOD)
	CYBORG_STACK(material/cyborg/plastic, MATSYN_PLASTIC)

/obj/item/robot_module/drone/construction
	name = "construction drone module"
	hide_on_manifest = 1
	channels = list("Engineering" = 1)
	languages = list()

/obj/item/robot_module/drone/construction/get_modules()
	. = ..()
	. |= /obj/item/rcd/electric/mounted/borg/lesser

/obj/item/robot_module/drone/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	var/obj/item/lightreplacer/LR = locate() in src.modules
	LR.Charge(R, amount)
	..()
	return

/obj/item/robot_module/drone/mining
	name = "miner drone module"
	channels = list("Supply" = 1)
	networks = list(NETWORK_MINE)

/obj/item/robot_module/drone/mining/get_modules()
	. = ..()
	. |= list(
		/obj/item/borg/sight/material,
		/obj/item/pickaxe/borgdrill,
		/obj/item/gun/projectile/energy/kinetic_accelerator/cyborg,
		/obj/item/storage/bag/ore,
		/obj/item/storage/bag/sheetsnatcher/borg
	)

/obj/item/robot_module/drone/mining/handle_special_module_init(mob/living/silicon/robot/R)
	. = ..()
	src.emag = new /obj/item/pickaxe/diamonddrill(src)

/obj/item/robot_module/drone/construction/matriarch
	name = "matriarch drone module"
