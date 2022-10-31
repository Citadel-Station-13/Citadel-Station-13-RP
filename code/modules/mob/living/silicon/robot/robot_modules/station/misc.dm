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


/obj/item/robot_module/robot/standard/Initialize(mapload)
	. = ..()
	src.modules += new /obj/item/melee/baton/loaded(src)
	src.modules += new /obj/item/tool/wrench/cyborg(src)
	src.modules += new /obj/item/healthanalyzer(src)
	src.emag = new /obj/item/melee/energy/sword(src)

/obj/item/robot_module/robot/quad_basic
	name = "Standard Quadruped module"
	sprites = list(
					"F3-LINE" = "FELI-Standard"
					)
	can_be_pushed = 0

/obj/item/robot_module/robot/quad_basic/Initialize(mapload)
	. = ..()
	var/mob/living/silicon/robot/R = loc
	src.modules += new /obj/item/melee/baton/loaded(src)
	src.modules += new /obj/item/tool/wrench/cyborg(src)
	src.modules += new /obj/item/healthanalyzer(src)
	src.modules += new /obj/item/dogborg/jaws/small(src)
	src.modules += new /obj/item/dogborg/boop_module(src)
	src.emag = new /obj/item/melee/energy/sword(src)

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
