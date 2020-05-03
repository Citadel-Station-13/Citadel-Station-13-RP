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
					"Drone" = "drone-miner"
				)

/obj/item/robot_module/robot/miner/New()
	..()
	src.modules += new /obj/item/borg/sight/material(src)
	src.modules += new /obj/item/tool/wrench/cyborg(src)
	src.modules += new /obj/item/tool/screwdriver/cyborg(src)
	src.modules += new /obj/item/storage/bag/ore(src)
	src.modules += new /obj/item/pickaxe/borgdrill(src)
	src.modules += new /obj/item/storage/bag/sheetsnatcher/borg(src)
	src.modules += new /obj/item/gripper/miner(src)
	src.modules += new /obj/item/mining_scanner(src)
	src.emag = new /obj/item/pickaxe/plasmacutter(src)
	src.emag = new /obj/item/pickaxe/diamonddrill(src)
