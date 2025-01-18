GENERATE_ROBOT_MODULE_PRESET(/nanotrasen/multirole)
/datum/prototype/robot_module/nanotrasen/multirole
	use_robot_module_path = /obj/item/robot_module/robot/standard
	allowed_frames = list(
	)

/datum/prototype/robot_module/nanotrasen/multirole/create_mounted_item_descriptors(list/normal_out, list/emag_out)
	..()
	if(normal_out)
		normal_out |= list(
			/obj/item/melee/baton/loaded,
			/obj/item/tool/wrench/cyborg,
			/obj/item/healthanalyzer,
		)
	if(emag_out)
		emag_out |= list(
			/obj/item/melee/transforming/energy/sword,
		)

#warn translate chassis below

/obj/item/robot_module/robot/standard
	name = "standard robot module"
	sprites = list(
		"M-USE Nanotrasen" = "robot",
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

/obj/item/robot_module/robot/quad/basic
	name = "Standard Quadruped module"
	sprites = list(
		"F3-LINE" = "FELI-Standard"
	)
