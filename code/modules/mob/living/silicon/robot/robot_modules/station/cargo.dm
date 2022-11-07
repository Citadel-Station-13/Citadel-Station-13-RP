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

/obj/item/robot_module/robot/miner/Initialize(mapload)
	. = ..()
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
	src.emag = new /obj/item/melee/disruptor/borg(src)

/obj/item/robot_module/robot/quad_miner
	name = "Mining Quadruped module"
	sprites = list(
					"F3-LINE" = "FELI-Mining"
					)
	channels = list("Supply" = 1)
	can_be_pushed = 0

// In a nutshell, basicly service/butler robot but in dog form.
/obj/item/robot_module/robot/quad_miner/Initialize(mapload)
	. = ..()
	var/mob/living/silicon/robot/R = loc
	src.modules += new /obj/item/borg/sight/material(src)
	src.modules += new /obj/item/tool/wrench/cyborg(src)
	src.modules += new /obj/item/tool/screwdriver/cyborg(src)
	src.modules += new /obj/item/storage/bag/ore(src)
	src.modules += new /obj/item/pickaxe/borgdrill(src)
	src.modules += new /obj/item/storage/bag/sheetsnatcher/borg(src)
	src.modules += new /obj/item/gripper/miner(src)
	src.modules += new /obj/item/mining_scanner(src)
	src.modules += new /obj/item/dogborg/jaws/small(src)
	src.modules += new /obj/item/dogborg/boop_module(src)
	src.emag = new /obj/item/pickaxe/plasmacutter(src)
	src.emag = new /obj/item/pickaxe/diamonddrill(src)
	src.emag = new /obj/item/melee/disruptor/borg(src)

	var/datum/matter_synth/water = new /datum/matter_synth(500) // buffy fix, was 0
	water.name = "Water reserves"
	water.recharge_rate = 0
	water.max_energy = 1000
	R.water_res = water
	synths += water

	var/obj/item/dogborg/tongue/T = new /obj/item/dogborg/tongue(src)
	T.water = water
	src.modules += T

	R.icon = 'icons/mob/robots_wide.dmi'
	R.set_base_pixel_x(-16)
	R.dogborg = TRUE
	R.wideborg = TRUE
	R.icon_dimension_x = 64
	R.verbs |= /mob/living/silicon/robot/proc/ex_reserve_refill
	R.verbs |= /mob/living/silicon/robot/proc/rest_style
