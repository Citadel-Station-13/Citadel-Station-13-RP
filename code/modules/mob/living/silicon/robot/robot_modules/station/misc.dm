/obj/item/robot_module/robot/standard
	name = "standard robot module"
	sprites = list(
		"M-USE NanoTrasen" = "robot",
		"Cabeiri" = "eyebot-standard",
		"Haruka" = "marinaSD",
		"Usagi" = "tallflower",
		"Telemachus" = "toiletbot",
		"WTOperator" = "sleekstandard",
		"WTOmni" = "omoikane",
		"XI-GUS" = "spider",
		"XI-ALP" = "heavyStandard",
		"Basic" = "robot_old",
		"Android" = "droid",
		"Drone" = "drone-standard",
		"Insekt" = "insekt-Default",
		"Misato" = "tall2standard",
		"L3P1-D0T" = "Glitterfly-Standard",
		"Convict" = "servitor",
		"Miss M" = "miss-standard",
		"Coffin" = "coffin-Standard",
		"X-88" = "xeightyeight-standard",
		"Handy" = "handy-standard",
		"Acheron" = "mechoid-Standard",
		"Shellguard Noble" = "Noble-STD",
		"ZOOM-BA" = "zoomba-standard",
		"W02M" = "worm-standard"
	)

/obj/item/robot_module/robot/standard/get_modules()
	. = ..()
	. |= list(
		/obj/item/melee/baton/loaded,
		/obj/item/tool/wrench/cyborg,
		/obj/item/healthanalyzer
	)

/obj/item/robot_module/robot/standard/handle_special_module_init(mob/living/silicon/robot/R)
	. = ..()
	src.emag = new /obj/item/melee/energy/sword(src)

/obj/item/robot_module/robot/quad/basic
	name = "Standard Quadruped module"
	sprites = list(
		"F3-LINE" = "FELI-Standard"
	)
	can_be_pushed = 0

/obj/item/robot_module/robot/quad/basic/get_modules()
	. = ..()
	. |= list(
		/obj/item/melee/baton/loaded,
		/obj/item/tool/wrench/cyborg,
		/obj/item/healthanalyzer,
		/obj/item/dogborg/jaws/small
	)

/obj/item/robot_module/robot/quad/basic/handle_special_module_init(mob/living/silicon/robot/R)
	. = ..()
	// These get a larger water synth.
	synths_by_kind[MATSYN_WATER]:max_energy = 1000
	src.emag = new /obj/item/melee/energy/sword(src)
