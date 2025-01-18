GENERATE_ROBOT_MODULE_PRESET(/nanotrasen/engineering)
/datum/prototype/robot_module/nanotrasen/engineering
	use_robot_module_path = /obj/item/robot_module/robot/engineering
	allowed_frames = list(
	)

/datum/prototype/robot_module/nanotrasen/engineering/provision_resource_store(datum/robot_resource_store/store)
	..()
	store.provisioned_material_store[/datum/prototype/material/steel::id] = new /datum/robot_resource/provisioned/preset/material/steel
	store.provisioned_material_store[/datum/prototype/material/glass::id] = new /datum/robot_resource/provisioned/preset/material/glass
	store.provisioned_material_store[/datum/prototype/material/plasteel::id] = new /datum/robot_resource/provisioned/preset/material/plasteel
	store.provisioned_material_store[/datum/prototype/material/wood_plank::id] = new /datum/robot_resource/provisioned/preset/material/wood
	store.provisioned_material_store[/datum/prototype/material/plastic::id] = new /datum/robot_resource/provisioned/preset/material/plastic
	store.provisioned_stack_store[/obj/item/stack/cable_coil] = new /datum/robot_resource/provisioned/preset/wire

/datum/prototype/robot_module/nanotrasen/engineering/create_mounted_item_descriptors(list/normal_out, list/emag_out)
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
		normal_out |= list(
			/obj/item/matter_decompiler,
			/obj/item/borg/sight/meson,
			/obj/item/weldingtool/electric/mounted/cyborg,
			/obj/item/tool/screwdriver/cyborg,
			/obj/item/tool/wrench/cyborg,
			/obj/item/tool/wirecutters/cyborg,
			/obj/item/multitool,
			/obj/item/t_scanner,
			/obj/item/rcd/electric/mounted/borg,
			/obj/item/atmos_analyzer,
			/obj/item/barrier_tape_roll/engineering,
			/obj/item/inflatable_dispenser/robot,
			/obj/item/pickaxe/plasmacutter,
			/obj/item/geiger_counter/cyborg,
			/obj/item/pipe_painter,
			/obj/item/floor_painter,
			/obj/item/gripper,
			/obj/item/gripper/no_use/loader,
			/obj/item/pipe_dispenser,
			/obj/item/gripper/circuit,
			/obj/item/lightreplacer,
		)
	if(emag_out)
		emag_out |= list(
			/obj/item/melee/baton/robot/arm,
		)
#warn translate chassis below

/obj/item/robot_module/robot/engineering
	name = "engineering robot module"
	channels = list("Engineering" = 1)
	networks = list(NETWORK_ENGINEERING)
	subsystems = list(/mob/living/silicon/proc/subsystem_power_monitor)
	sprites = list(
		"M-USE Nanotrasen" = "robotEngi",
		"Cabeiri" = "eyebot-engineering",
		"Haruka" = "marinaENG",
		"Usagi" = "tallyellow",
		"Telemachus" = "toiletbotengineering",
		"WTOperator" = "sleekce",
		"XI-GUS" = "spidereng",
		"XI-ALP" = "heavyEng",
		"Basic" = "Engineering",
		"Antique" = "engineerrobot",
		"Landmate" = "landmate",
		"Landmate - Treaded" = "engiborg+tread",
		"Drone" = "drone-engineer",
		"Treadwell" = "treadwell",
		"Handy" = "handy-engineer",
		"Misato" = "tall2engineer",
		"L3P1-D0T" = "Glitterfly-Engineering",
		"Miss M" = "miss-engineer",
		"Coffstruction" = "coffin-Construction",
		"Coffgineer" = "coffin-Engineering",
		"X-88" = "xeightyeight-engineering",
		"Acheron" = "mechoid-Engineering",
		"Shellguard Noble" = "Noble-ENG",
		"ZOOM-BA" = "zoomba-engineering",
		"W02M" = "worm-engineering"
	)

/obj/item/robot_module/robot/quad/engi
	name = "EngiQuad module"
	sprites = list(
		"Pupdozer" = "pupdozer",
		"V2 Engidog" = "thottbot",
		"Borgi" = "borgi-eng",
		"Engineering Hound" = "engihound",
		"Engineering Hound Dark" = "engihounddark",
		"F3-LINE" = "FELI-Engineer",
		"Drake" = "drakeeng",
		"Otie" = "otiee"
	)
	channels = list("Engineering" = 1)
	networks = list(NETWORK_ENGINEERING)
	subsystems = list(/mob/living/silicon/proc/subsystem_power_monitor)
	can_be_pushed = 0
	can_shred = TRUE

