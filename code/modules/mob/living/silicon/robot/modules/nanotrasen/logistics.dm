GENERATE_ROBOT_MODULE_PRESET(/nanotrasen/logistics)
/datum/prototype/robot_module/nanotrasen/logistics
	use_robot_module_path = /obj/item/robot_module/robot/
	allowed_frames = list(
		/datum/robot_frame{
			name = "Canine - Hound";
			robot_chassis = /datum/prototype/robot_chassis/quadruped/canine;
			robot_iconset = /datum/prototype/robot_iconset/dog_k9/logistics;
		},
		/datum/robot_frame{
			name = "Canine - Hound (Dark)";
			robot_chassis = /datum/prototype/robot_chassis/quadruped/canine;
			robot_iconset = /datum/prototype/robot_iconset/dog_k9/logistics_dark;
		},
		/datum/robot_frame{
			name = "Canine - Vale";
			robot_chassis = /datum/prototype/robot_chassis/quadruped/canine;
			robot_iconset = /datum/prototype/robot_iconset/dog_vale/mining;
		},
		/datum/robot_frame{
			name = "Drake";
			robot_chassis = /datum/prototype/robot_chassis/quadruped/draconic;
			robot_iconset = /datum/prototype/robot_iconset/drake_mizartz/medical;
		},
		/datum/robot_frame{
			name = "F3-LINE";
			robot_chassis = /datum/prototype/robot_chassis/quadruped/feline;
			robot_iconset = /datum/prototype/robot_iconset/cat_feli/mining;
		},
		/datum/robot_frame{
			name = "Canine - Otie";
			robot_chassis = /datum/prototype/robot_chassis/quadruped/canine;
			robot_iconset = /datum/prototype/robot_iconset/dog_otie/science;
		},
	)

/datum/prototype/robot_module/nanotrasen/logistics/create_mounted_item_descriptors(list/normal_out, list/emag_out)
	if(normal_out)
		normal_out |= list(
			/obj/item/borg/sight/material,
			/obj/item/tool/wrench/cyborg,
			/obj/item/tool/screwdriver/cyborg,
			/obj/item/storage/bag/ore,
			/obj/item/pickaxe/borgdrill,
			/obj/item/gun/energy/kinetic_accelerator/cyborg,
			/obj/item/storage/bag/sheetsnatcher/borg,
			/obj/item/gripper/miner,
			/obj/item/mining_scanner,
			/obj/item/pickaxe/plasmacutter,
		)
	return ..()

#warn translate chassis below

/obj/item/robot_module/robot/miner
	name = "miner robot module"
	channels = list("Supply" = 1)
	networks = list(NETWORK_MINE)
	sprites = list(
		"NM-USE Nanotrasen" = "robotMine",
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
