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
					"Handy" = "handy-standard",
					"Acheron" = "mechoid-Standard",
					"Shellguard Noble" = "Noble-STD",
					"ZOOM-BA" = "zoomba-standard"
					 )


/obj/item/robot_module/robot/standard/New()
	..()
	src.modules += new /obj/item/melee/baton/loaded(src)
	src.modules += new /obj/item/tool/wrench/cyborg(src)
	src.modules += new /obj/item/healthanalyzer(src)
	src.emag = new /obj/item/melee/energy/sword(src)
