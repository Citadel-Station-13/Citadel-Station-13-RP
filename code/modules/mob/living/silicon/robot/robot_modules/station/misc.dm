/obj/item/weapon/robot_module/robot/standard
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
					"Insekt" = "insekt-Default"
					)


/obj/item/weapon/robot_module/robot/standard/New()
	..()
	src.modules += new /obj/item/weapon/melee/baton/loaded(src)
	src.modules += new /obj/item/weapon/tool/wrench/cyborg(src)
	src.modules += new /obj/item/device/healthanalyzer(src)
	src.emag = new /obj/item/weapon/melee/energy/sword(src)
