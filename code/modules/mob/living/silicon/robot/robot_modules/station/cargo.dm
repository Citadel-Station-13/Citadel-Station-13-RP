/obj/item/weapon/robot_module/robot/miner
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

/obj/item/weapon/robot_module/robot/miner/New()
	..()
	src.modules += new /obj/item/borg/sight/material(src)
	src.modules += new /obj/item/weapon/tool/wrench/cyborg(src)
	src.modules += new /obj/item/weapon/tool/screwdriver/cyborg(src)
	src.modules += new /obj/item/weapon/storage/bag/ore(src)
	src.modules += new /obj/item/weapon/pickaxe/borgdrill(src)
	src.modules += new /obj/item/weapon/storage/bag/sheetsnatcher/borg(src)
	src.modules += new /obj/item/weapon/gripper/miner(src)
	src.modules += new /obj/item/weapon/mining_scanner(src)
	src.emag = new /obj/item/weapon/pickaxe/plasmacutter(src)
	src.emag = new /obj/item/weapon/pickaxe/diamonddrill(src)
