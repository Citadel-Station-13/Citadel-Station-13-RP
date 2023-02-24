/obj/item/robot_module/robot/miner
	name = "miner robot module"
	channels = list("Supply" = 1)
	networks = list(NETWORK_MINE)
	sprites = list(
		"NM-USE NanoTrasen" = "robotMine",
		"Cabeiri" = "eyebot-miner",
		"Haruka" = "marinaMN",
		"Telemachus" = "toiletbotminer",
		"WTOperator" = "sleekminer",
		"XI-GUS" = "spidermining",
		"XI-ALP" = "heavyMiner",
		"Basic" = "Miner_old",
		"Advanced Droid" = "droid-miner",
		"Treadhead" = "Miner",
		"Drone" = "drone-miner",
		"Misato" = "tall2miner",
		"L3P1-D0T" = "Glitterfly-Miner",
		"Miss M" = "miss-miner",
		"Carffin" = "coffin-Service",
		"Coffing" = "coffin-Mining",
		"Handy" = "handy-miner",
		"Acheron" = "mechoid-Miner",
		"Shellguard Noble" = "Noble-DIG",
		"ZOOM-BA" = "zoomba-miner",
		"W02M" = "worm-miner"
	)

/obj/item/robot_module/robot/miner/get_modules()
	. = ..()
	. |= list(
		/obj/item/borg/sight/material,
		/obj/item/tool/wrench/cyborg,
		/obj/item/tool/screwdriver/cyborg,
		/obj/item/storage/bag/ore,
		/obj/item/pickaxe/borgdrill,
		/obj/item/storage/bag/sheetsnatcher/borg,
		/obj/item/gripper/miner,
		/obj/item/mining_scanner
	)

/obj/item/robot_module/robot/miner/handle_special_module_init(mob/living/silicon/robot/R)
	. = ..()

	// TODO: Only one emag module is supported right now.
	src.emag = new /obj/item/pickaxe/plasmacutter(src)
	// src.emag = new /obj/item/pickaxe/diamonddrill(src)
	// src.emag = new /obj/item/melee/disruptor/borg(src)

/obj/item/robot_module/robot/quad/miner
	name = "Mining Quadruped module"
	sprites = list(
		"F3-LINE" = "FELI-Mining",
		"K-MINE" = "kmine",
		"Cargo Hound" = "cargohound",
		"Cargo Hound Dark" = "cargohounddark",
		"Drake" = "drakemine",
		"Otie" = "otiec"
	)
	channels = list("Supply" = 1)
	can_be_pushed = 0

/obj/item/robot_module/robot/quad/miner/get_modules()
	. = ..()
	. |= list(
		/obj/item/borg/sight/material,
		/obj/item/tool/wrench/cyborg,
		/obj/item/tool/screwdriver/cyborg,
		/obj/item/storage/bag/ore,
		/obj/item/pickaxe/borgdrill,
		/obj/item/storage/bag/sheetsnatcher/borg,
		/obj/item/gripper/miner,
		/obj/item/mining_scanner,
		/obj/item/dogborg/jaws/small
	)

// In a nutshell, basically service/butler robot but in dog form.
/obj/item/robot_module/robot/quad/miner/handle_special_module_init(mob/living/silicon/robot/R)
	. = ..()

	// TODO: Only one emag module is supported right now.
	src.emag = new /obj/item/pickaxe/plasmacutter(src)
	// src.emag = new /obj/item/pickaxe/diamonddrill(src)
	// src.emag = new /obj/item/melee/disruptor/borg(src)

/obj/item/robot_module/robot/quad/miner/handle_special_module_init(mob/living/silicon/robot/R)
	. = ..()
	// These get a larger water synth.
	synths_by_kind[MATSYN_WATER]:max_energy = 1000
